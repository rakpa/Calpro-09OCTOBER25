import 'dart:convert';

import 'package:flutter/material.dart';
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

/// Lightweight persisted app preferences / favorites / history.
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  static const _kOnboarded = 'onboarded';
  static const _kFavorites = 'favorites';
  static const _kHistory = 'history';
  static const _kThemeMode = 'theme_mode';

  SharedPreferences? _prefs;
  bool onboarded = false;
  Set<String> favorites = {};
  List<HistoryEntry> history = [];
  ThemeMode themeMode = ThemeMode.system;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    onboarded = _prefs!.getBool(_kOnboarded) ?? false;
    favorites = (_prefs!.getStringList(_kFavorites) ?? []).toSet();
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
    if (history.length > 80) {
      history = history.take(80).toList();
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
}
