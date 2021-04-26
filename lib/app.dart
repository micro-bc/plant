import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/plant.dart';
import 'screens/add_plant_page.dart';
import 'screens/edit_plant_page.dart';
import 'screens/home_page.dart';
import 'screens/plant_details_page.dart';

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
            builder = (context) => ChangeNotifierProvider<PlantModel>.value(
                  value: settings.arguments as PlantModel,
                  child: PlantDetailsPage(),
                );
            break;

          case '/edit':
            builder = (context) => ChangeNotifierProvider<PlantModel>(
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
