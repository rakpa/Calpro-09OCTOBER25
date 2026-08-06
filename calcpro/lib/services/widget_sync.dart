import 'package:home_widget/home_widget.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/models/calculator_item.dart';

/// Syncs lightweight snapshot data to the iOS/Android home-screen widget.
class WidgetSync {
  static const androidName = 'CalcaraWidgetProvider';
  static const iOSName = 'CalcaraWidget';
  static const appGroup = 'group.www.calpro.app';

  static Future<void> init() async {
    try {
      await HomeWidget.setAppGroupId(appGroup);
    } catch (_) {}
  }

  static Future<void> publish() async {
    try {
      final state = AppState.instance;
      final latest = state.history.isNotEmpty ? state.history.first : null;
      final popular = kCalculators.take(3).map((c) => c.shortTitle).join(' · ');
      await HomeWidget.saveWidgetData<String>(
        'title',
        latest?.title ?? 'Calcara',
      );
      await HomeWidget.saveWidgetData<String>(
        'result',
        latest?.result ?? 'Open a calculator',
      );
      await HomeWidget.saveWidgetData<String>('popular', popular);
      await HomeWidget.updateWidget(
        name: androidName,
        iOSName: iOSName,
        qualifiedAndroidName: 'www.calpro.app.$androidName',
      );
    } catch (_) {
      // Widget optional — ignore on simulators without extension configured.
    }
  }
}
