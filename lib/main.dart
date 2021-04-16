import 'package:flutter/material.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/screens/add_plant_page.dart';
import 'package:plant/screens/edit_plant_page.dart';
import 'package:plant/screens/home_page.dart';
import 'package:plant/screens/plant_details_page.dart';
import 'package:plant/utils/notification_helper.dart';
import 'package:plant/utils/plant_storage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notifyFuture = NotificationHelper.init();
  final plantFuture = PlantStorage.getPlants();

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
        WidgetBuilder builder;

        switch (settings.name) {
          case '/details':
            builder = (context) => ChangeNotifierProvider.value(
                  value: settings.arguments as PlantModel,
                  child: PlantDetailsPage(),
                );
            break;
          case '/edit':
            builder = (context) => ChangeNotifierProvider(
                  create: (context) =>
                      (settings.arguments as PlantModel).clone(),
                  child: EditPlantPage(),
                );
            break;
          default:
            builder = (context) => Center(child: Text('404'));
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
