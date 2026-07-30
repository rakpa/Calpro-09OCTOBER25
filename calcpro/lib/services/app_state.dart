import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryEntry {
  final String route;
  final String title;
  final String result;
  final DateTime at;

  HistoryEntry({
    required this.route,
    required this.title,
    required this.result,
    required this.at,
  });

  Map<String, dynamic> toJson() => {
        'route': route,
        'title': title,
        'result': result,
        'at': at.toIso8601String(),
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        route: json['route'] as String,
        title: json['title'] as String,
        result: json['result'] as String,
        at: DateTime.parse(json['at'] as String),
      );
}

/// Persisted preferences, favorites, history, and premium trial.
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  static const _kOnboarded = 'onboarded_v2';
  static const _kFavorites = 'favorites';
  static const _kHistory = 'history';
  static const _kThemeMode = 'theme_mode';
  static const _kHaptics = 'haptics';
  static const _kSound = 'sound';
  static const _kTips = 'show_tips';
  static const _kRecentSearches = 'recent_searches';
  static const _kPremiumTrialStart = 'premium_trial_start';
  static const _kPremiumActive = 'premium_active';

  SharedPreferences? _prefs;
  bool onboarded = false;
  Set<String> favorites = {};
  List<HistoryEntry> history = [];
  ThemeMode themeMode = ThemeMode.system;
  bool hapticsEnabled = true;
  bool soundEnabled = false;
  bool showTips = true;
  List<String> recentSearches = [];
  DateTime? premiumTrialStart;
  bool premiumUnlocked = false;

  bool get isPremium {
    if (premiumUnlocked) return true;
    final start = premiumTrialStart;
    if (start == null) return false;
    return DateTime.now().difference(start) < const Duration(days: 3);
  }

  int get historyLimit => isPremium ? 500 : 40;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    onboarded = _prefs!.getBool(_kOnboarded) ?? false;
    favorites = (_prefs!.getStringList(_kFavorites) ?? []).toSet();
    recentSearches = _prefs!.getStringList(_kRecentSearches) ?? [];
    hapticsEnabled = _prefs!.getBool(_kHaptics) ?? true;
    soundEnabled = _prefs!.getBool(_kSound) ?? false;
    showTips = _prefs!.getBool(_kTips) ?? true;
    premiumUnlocked = _prefs!.getBool(_kPremiumActive) ?? false;
    final trial = _prefs!.getString(_kPremiumTrialStart);
    if (trial != null) premiumTrialStart = DateTime.tryParse(trial);
    final raw = _prefs!.getString(_kHistory);
    if (raw != null) {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      history = list.map(HistoryEntry.fromJson).toList();
    }
    final mode = _prefs!.getString(_kThemeMode);
    themeMode = switch (mode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    onboarded = true;
    await _prefs?.setBool(_kOnboarded, true);
    notifyListeners();
  }

  bool isFavorite(String route) => favorites.contains(route);

  Future<void> toggleFavorite(String route) async {
    if (favorites.contains(route)) {
      favorites.remove(route);
    } else {
      favorites.add(route);
    }
    await _prefs?.setStringList(_kFavorites, favorites.toList());
    notifyListeners();
  }

  Future<void> addHistory({
    required String route,
    required String title,
    required String result,
  }) async {
    history.insert(
      0,
      HistoryEntry(
        route: route,
        title: title,
        result: result,
        at: DateTime.now(),
      ),
    );
    final limit = historyLimit;
    if (history.length > limit) {
      history = history.take(limit).toList();
    }
    await _prefs?.setString(
      _kHistory,
      jsonEncode(history.map((e) => e.toJson()).toList()),
    );
    notifyListeners();
  }

  Future<void> clearHistory() async {
    history = [];
    await _prefs?.remove(_kHistory);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs?.setString(_kThemeMode, value);
    notifyListeners();
  }

  Future<void> setHaptics(bool value) async {
    hapticsEnabled = value;
    await _prefs?.setBool(_kHaptics, value);
    notifyListeners();
  }

  Future<void> setSound(bool value) async {
    soundEnabled = value;
    await _prefs?.setBool(_kSound, value);
    notifyListeners();
  }

  Future<void> setShowTips(bool value) async {
    showTips = value;
    await _prefs?.setBool(_kTips, value);
    notifyListeners();
  }

  Future<void> addRecentSearch(String term) async {
    final t = term.trim();
    if (t.isEmpty) return;
    recentSearches.removeWhere((e) => e.toLowerCase() == t.toLowerCase());
    recentSearches.insert(0, t);
    if (recentSearches.length > 8) {
      recentSearches = recentSearches.take(8).toList();
    }
    await _prefs?.setStringList(_kRecentSearches, recentSearches);
    notifyListeners();
  }

  Future<void> removeRecentSearch(String term) async {
    recentSearches.remove(term);
    await _prefs?.setStringList(_kRecentSearches, recentSearches);
    notifyListeners();
  }

  Future<void> startPremiumTrial() async {
    premiumTrialStart = DateTime.now();
    await _prefs?.setString(
      _kPremiumTrialStart,
      premiumTrialStart!.toIso8601String(),
    );
    notifyListeners();
  }

  Future<void> activatePremium() async {
    premiumUnlocked = true;
    await _prefs?.setBool(_kPremiumActive, true);
    notifyListeners();
  }

  void selectionFeedback() {
    if (hapticsEnabled) HapticFeedback.selectionClick();
    if (soundEnabled) SystemSound.play(SystemSoundType.click);
  }

  void lightFeedback() {
    if (hapticsEnabled) HapticFeedback.lightImpact();
    if (soundEnabled) SystemSound.play(SystemSoundType.click);
  }
}
