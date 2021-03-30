import 'package:flutter/material.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/screens/add_plant_page.dart';
import 'package:plant/screens/home_page.dart';
import 'package:plant/utils/plant_storage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder<PlantsModel>(
        future: PlantStorage.getPlants(),
        builder: (context, snapshot) {
          // TODO Error message
          if (snapshot.hasError) return Container();

          if (!snapshot.hasData) return _SplashScreen();

          return ChangeNotifierProvider<PlantsModel>(
            create: (context) => snapshot.data!,
            child: _Navigator(),
          );
        },
      ),
    );
  }
}

class _Navigator extends Navigator {
  _Navigator()
      : super(
          initialRoute: '/',
          onGenerateRoute: (settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case '/':
                builder = (context) => HomePage();
                break;
              case '/add':
                builder = (context) => AddPlantPage();
                break;
              default:
                builder = (context) => Container(); // TODO Page not found
                break;
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        );
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[400],
      child: Center(
        child: Icon(
          Icons.local_florist,
          color: Colors.white,
          size: 80,
        ),
      ),
    );
  }
}
