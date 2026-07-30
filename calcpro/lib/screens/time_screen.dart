import 'package:flutter/material.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  int mode = 0;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? startDate;
  DateTime? endDate;
  String? result;

  void _clear() {
    setState(() {
      startTime = endTime = null;
      startDate = endDate = null;
      result = null;
    });
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? startTime : endTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => isStart ? startTime = picked : endTime = picked);
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? startDate : endDate) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => isStart ? startDate = picked : endDate = picked);
    }
  }

  void _calc() {
    if (mode == 0) {
      if (startTime == null || endTime == null) return;
      final start = Duration(hours: startTime!.hour, minutes: startTime!.minute);
      var end = Duration(hours: endTime!.hour, minutes: endTime!.minute);
      var diff = end - start;
      if (diff.isNegative) diff += const Duration(hours: 24);
      setState(() =>
          result = '${diff.inHours}h ${diff.inMinutes % 60}m');
    } else {
      if (startDate == null || endDate == null) return;
      final days = endDate!.difference(startDate!).inDays.abs();
      setState(() => result = '$days days');
    }
    AppState.instance.addHistory(route: '/time', title: 'Time', result: result!);
    WidgetSync.publish();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ready = mode == 0
        ? startTime != null && endTime != null
        : startDate != null && endDate != null;

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(
        title: const Text('Time'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/time');
              return IconButton(
                onPressed: () => AppState.instance.toggleFavorite('/time'),
                icon: Icon(
                  fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: fav ? AppColors.accentPink : null,
                ),
              );
            },
          ),
          IconButton(onPressed: _clear, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          SegmentControl(
            labels: const ['Time Diff', 'Days Between'],
            index: mode,
            onChanged: (i) => setState(() {
              mode = i;
              result = null;
            }),
          ),
          const SizedBox(height: 16),
          if (result != null)
            AppCard(
              child: Column(
                children: [
                  Text('Result', style: AppFonts.body2()),
                  Text(result!, style: AppFonts.result()),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: mode == 0
                ? Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Start time'),
                        trailing: Text(
                          startTime?.format(context) ?? 'Select',
                          style: AppFonts.body1(),
                        ),
                        onTap: () => _pickTime(true),
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('End time'),
                        trailing: Text(
                          endTime?.format(context) ?? 'Select',
                          style: AppFonts.body1(),
                        ),
                        onTap: () => _pickTime(false),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Start date'),
                        trailing: Text(
                          startDate == null
                              ? 'Select'
                              : '${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}',
                          style: AppFonts.body1(),
                        ),
                        onTap: () => _pickDate(true),
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('End date'),
                        trailing: Text(
                          endDate == null
                              ? 'Select'
                              : '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}',
                          style: AppFonts.body1(),
                        ),
                        onTap: () => _pickDate(false),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Calculate', onPressed: ready ? _calc : null),
        ],
      ),
    );
  }
}
