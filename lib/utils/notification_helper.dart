import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _plugin.initialize(InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      iOS: IOSInitializationSettings(),
      macOS: MacOSInitializationSettings(),
    ));
  }

  Future<void> show(
    int id,
    String title,
    String body, {
    String? playload,
  }) async {
    final notifyDetails = NotificationDetails(
      android: AndroidNotificationDetails('plant', 'Plant', ''),
      iOS: IOSNotificationDetails(),
    );

    return await _plugin.show(id, title, body, notifyDetails,
        payload: playload);
  }
}
