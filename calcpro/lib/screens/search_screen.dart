import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:calcpro/models/calculator_item.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';
import 'package:calcpro/widgets/app_status.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _speech = SpeechToText();
  String _query = '';
  bool _listening = false;
  bool _speechReady = false;

  static const _popular = [
    'Percentage',
    'Mortgage',
    'BMI',
    'EMI',
    'Discount',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() => _query = _controller.text));
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechReady = await _speech.initialize(
      onStatus: (s) {
        if (s == 'done' || s == 'notListening') {
          setState(() => _listening = false);
        }
      },
    );
    if (mounted) setState(() {});
  }

  Future<void> _toggleMic() async {
    AppState.instance.selectionFeedback();
    if (!_speechReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission needed for voice search')),
      );
      _speechReady = await _speech.initialize();
      if (!_speechReady) return;
    }
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (r) {
        setState(() {
          _controller.text = r.recognizedWords;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });
        if (r.finalResult) {
          AppState.instance.addRecentSearch(r.recognizedWords);
        }
      },
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    super.dispose();
  }

  List<CalculatorItem> get _results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return kCalculators.where((c) {
      return c.title.toLowerCase().contains(q) ||
          c.shortTitle.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final recent = AppState.instance.recentSearches;
    final trending = [
      calculatorByRoute('/percentage')!,
      calculatorByRoute('/mortgage')!,
      calculatorByRoute('/health')!,
      calculatorByRoute('/financial')!,
    ];

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SearchField(
                      controller: _controller,
                      autofocus: true,
                      showMic: true,
                      onMicTap: _toggleMic,
                      hint: _listening
                          ? 'Listening...'
                          : 'Search calculators...',
                      onClear: () => _controller.clear(),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_listening)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Speak a calculator name…',
                  style: AppFonts.caption(color: AppColors.primary),
                ),
              ),
            Expanded(
              child: ListenableBuilder(
                listenable: AppState.instance,
                builder: (context, _) {
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                    children: [
                      if (_query.isEmpty) ...[
                        Text('Popular Searches', style: AppFonts.h3()),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final term in _popular)
                              ActionChip(
                                label: Text(term),
                                onPressed: () {
                                  AppState.instance.selectionFeedback();
                                  _controller.text = term;
                                  AppState.instance.addRecentSearch(term);
                                },
                              ),
                          ],
                        ),
                        if (recent.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          Text('Recent Searches', style: AppFonts.h3()),
                          const SizedBox(height: 8),
                          for (final term in recent)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.history_rounded),
                              title: Text(term, style: AppFonts.body1()),
                              trailing: IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18),
                                onPressed: () =>
                                    AppState.instance.removeRecentSearch(term),
                              ),
                              onTap: () => _controller.text = term,
                            ),
                        ],
                        const SizedBox(height: 20),
                        Text('Trending Now', style: AppFonts.h3()),
                        const SizedBox(height: 12),
                        for (final item in trending) ...[
                          _TrendCard(item: item),
                          const SizedBox(height: 10),
                        ],
                      ] else if (_results.isEmpty)
                        AppStatusView.empty(
                          title: 'No calculators found',
                          message: 'Try Percentage, Mortgage, BMI, or EMI.',
                          actionLabel: 'Clear search',
                          onAction: () => _controller.clear(),
                        )
                      else ...[
                        Text('Results', style: AppFonts.h3()),
                        const SizedBox(height: 12),
                        for (final item in _results) ...[
                          _TrendCard(item: item),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  final CalculatorItem item;
  const _TrendCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: dark ? AppColors.surfaceDark : Colors.white,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        onTap: () {
          AppState.instance.selectionFeedback();
          AppState.instance.addRecentSearch(item.shortTitle);
          Navigator.of(context).pushNamed(item.route);
        },
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              AccentIconTile(icon: item.icon, accent: item.accent, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.shortTitle,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: dark ? AppColors.inkDark : AppColors.ink,
                      ),
                    ),
                    Text(
                      'Calculate ${item.shortTitle.toLowerCase()} easily',
                      style: AppFonts.body2(),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
