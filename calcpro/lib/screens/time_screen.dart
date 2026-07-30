import 'package:flutter/material.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabs;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? startDate;
  DateTime? endDate;
  String? timeResult;
  String? daysResult;

  @override
  void initState() {
    super.initState();
    tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      startTime = endTime = null;
      startDate = endDate = null;
      timeResult = daysResult = null;
    });
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? startTime : endTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
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
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _calcTimeDiff() {
    if (startTime == null || endTime == null) return;
    final start = Duration(hours: startTime!.hour, minutes: startTime!.minute);
    var end = Duration(hours: endTime!.hour, minutes: endTime!.minute);
    var diff = end - start;
    if (diff.isNegative) {
      diff += const Duration(hours: 24);
    }
    setState(() {
      timeResult = '${diff.inHours} hours and ${diff.inMinutes % 60} minutes';
    });
  }

  void _calcDays() {
    if (startDate == null || endDate == null) return;
    final days = endDate!.difference(startDate!).inDays.abs();
    setState(() => daysResult = '$days days');
  }

  String _fmtTime(TimeOfDay? t) =>
      t == null ? 'Select time' : t.format(context);

  String _fmtDate(DateTime? d) {
    if (d == null) return 'Select date';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CalcScaffold(
      title: 'Time',
      route: '/time',
      icon: Icons.access_time,
      description: 'Calculate time-of-day differences and days between dates.',
      onClear: _clear,
      body: Column(
        children: [
          TabBar(
            controller: tabs,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: 'Time Difference'),
              Tab(text: 'Days Between'),
            ],
          ),
          SizedBox(
            height: 320,
            child: TabBarView(
              controller: tabs,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      OutlinedButton(
                        onPressed: () => _pickTime(true),
                        child: Text('Start: ${_fmtTime(startTime)}'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => _pickTime(false),
                        child: Text('End: ${_fmtTime(endTime)}'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed:
                            startTime == null || endTime == null ? null : _calcTimeDiff,
                        child: const Text('Calculate'),
                      ),
                      if (timeResult != null)
                        ResultPanel(child: Text(timeResult!)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      OutlinedButton(
                        onPressed: () => _pickDate(true),
                        child: Text('Start: ${_fmtDate(startDate)}'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => _pickDate(false),
                        child: Text('End: ${_fmtDate(endDate)}'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed:
                            startDate == null || endDate == null ? null : _calcDays,
                        child: const Text('Calculate'),
                      ),
                      if (daysResult != null)
                        ResultPanel(child: Text(daysResult!)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
