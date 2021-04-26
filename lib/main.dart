import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'models/plants.dart';
import 'utils/notification_helper.dart';
import 'utils/plant_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notifyFuture = NotificationHelper.init();
  final plantFuture = PlantStorage.getPlants();

  _prepare(await notifyFuture, await plantFuture);

  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationHelper>.value(value: await notifyFuture),
        ChangeNotifierProvider<PlantsModel>.value(value: await plantFuture),
      ],
      child: App(),
    ),
  );
}

_prepare(NotificationHelper notifyHelper, PlantsModel plants) {
  // Plant events
  plants.onAdd = (plant) {
    PlantStorage.savePlants(plants.plants);
    notifyHelper.schedulePlant(plant);
  };
  plants.onRemove = (id) {
    PlantStorage.savePlants(plants.plants);
    notifyHelper.cancel(id);
  };

  // Reschedule notifications
  notifyHelper.cancelAll();
  plants.plants.forEach((plant) => notifyHelper.schedulePlant(plant));
}
