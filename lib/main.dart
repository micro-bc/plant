import 'package:flutter/material.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/screens/add_plant_page.dart';
import 'package:plant/screens/home_page.dart';
import 'package:plant/utils/plant_storage.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    FutureBuilder<PlantsModel>(
      future: PlantStorage.getPlants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return _SplashScreen();

        return ChangeNotifierProvider<PlantsModel>(
          create: (context) => snapshot.data!,
          child: App(),
        );
      },
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
    );
  }
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO Beautify
    return Container(
      color: Colors.green[300],
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }
}
