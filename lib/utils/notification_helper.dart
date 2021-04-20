import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plant/models/plant.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

class NotificationHelper {
  final FlutterLocalNotificationsPlugin? _plugin;

  NotificationHelper._({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin;

  static Future<NotificationHelper> init() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        break;
      default:
        return NotificationHelper._();
    }

    initializeTimeZones();
    final notifyHelp = NotificationHelper._(
      plugin: FlutterLocalNotificationsPlugin(),
    );
    await notifyHelp._plugin!.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
        iOS: IOSInitializationSettings(),
      ),
    );
    return notifyHelp;
  }

  Future<void> schedule(
    int id,
    String title,
    String body,
    DateTime time, {
    String? payload,
  }) async =>
      await _plugin?.zonedSchedule(
        id,
        title,
        body,
        TZDateTime.from(time, local),
        _getNotificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: payload,
      );

  Future<void> schedulePlant(PlantModel plant) async {
    if (_plugin == null) return;
    if (plant.enabledCare.isEmpty) return;
    final minVal = plant.enabledCare
        .map((e) => e.nextCare!.millisecondsSinceEpoch)
        .reduce(min);

    await cancel(plant.id);
    await schedule(
      plant.id.hashCode,
      '${plant.name} needs your care',
      'Click to open',
      DateTime.fromMillisecondsSinceEpoch(
        max(minVal, DateTime.now().millisecondsSinceEpoch + 5000),
      ),
    );
  }

  Future<void> show(
    int id,
    String title,
    String body, {
    String? payload,
  }) async =>
      await _plugin?.show(
        id,
        title,
        body,
        _getNotificationDetails(),
        payload: payload,
      );

  Future<void> cancel(String id) async => await _plugin?.cancel(id.hashCode);

  Future<void> cancelAll() async => await _plugin?.cancelAll();

  NotificationDetails _getNotificationDetails() => NotificationDetails(
        android: AndroidNotificationDetails('plant', 'Plant', ''),
        iOS: IOSNotificationDetails(),
      );
}
