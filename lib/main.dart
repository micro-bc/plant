import 'package:flutter/material.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/screens/add_plant_page.dart';
import 'package:plant/screens/home_page.dart';
import 'package:plant/screens/plant_details_page.dart';
import 'package:plant/utils/notification_helper.dart';
import 'package:plant/utils/plant_storage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notifications = NotificationHelper();
  final notifyFuture = notifications.init();
  final plants = await PlantStorage.getPlants();
  await notifyFuture;

  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationHelper>.value(value: notifications),
        ChangeNotifierProvider<PlantsModel>.value(value: plants),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => HomePage(),
        '/add': (context) => AddPlantPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details')
          return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: settings.arguments as PlantModel,
              child: PlantDetailsPage(),
            ),
            settings: settings,
          );
      },
    );
  }
}
