import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  FlutterLocalNotificationsPlugin? _plugin;

  NotificationHelper._({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin;

  static Future<NotificationHelper> init() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
      default:
        return NotificationHelper._();
    }

    final notifyHelp = NotificationHelper._(
      plugin: FlutterLocalNotificationsPlugin(),
    );
    await notifyHelp._plugin!.initialize(InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      iOS: IOSInitializationSettings(),
      macOS: MacOSInitializationSettings(),
    ));
    return notifyHelp;
  }

  Future<void> show(
    int id,
    String title,
    String body, {
    String? playload,
  }) async {
    if (_plugin == null) return;

    final notifyDetails = NotificationDetails(
      android: AndroidNotificationDetails('plant', 'Plant', ''),
      iOS: IOSNotificationDetails(),
    );

    return await _plugin!.show(
      id,
      title,
      body,
      notifyDetails,
      payload: playload,
    );
  }
}
