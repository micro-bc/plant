import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant/components/care_input.dart';
import 'package:plant/components/plant_form.dart';
import 'package:plant/components/plant_tile.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/models/plant_care.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/screens/add_plant_page.dart';
import 'package:plant/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('Home page', () {
    testWidgets('Empty home page', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => PlantsModel(),
          child: MaterialApp(home: HomePage()),
        ),
      );

      expect(find.byType(PlantTile), findsNothing);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    });

    testWidgets('Open AddPlantPage', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      final addButton = find.byIcon(Icons.add_circle_outline);

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => PlantsModel(),
          child: MaterialApp(
            home: HomePage(),
            routes: <String, WidgetBuilder>{
              '/add': (context) => AddPlantPage(),
            },
            navigatorObservers: [mockObserver],
          ),
        ),
      );

      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      verify(mockObserver.navigator?.pushNamed('/add')).called(1);

      expect(find.byType(AddPlantPage), findsOneWidget);
    });
  });

  group('AddPlantPage', () {
    testWidgets('Empty add plant page', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => PlantModel(),
          child: MaterialApp(home: AddPlantPage()),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byType(PlantForm), findsOneWidget);
    });

    testWidgets('Add empty plant', (WidgetTester tester) async {
      final plants = PlantsModel();
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: plants,
          child: MaterialApp(
            home: AddPlantPage(),
            navigatorObservers: [mockObserver],
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      verify(mockObserver.navigator?.pop()).called(1);

      expect(plants.plants.length, 1);
    });
  });

  group('PlantForm', () {
    testWidgets('Enter name', (WidgetTester tester) async {
      final plant = PlantModel();
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: plant,
            child: PlantForm(),
          ),
        ),
      );

      await tester.enterText(find.byKey(Key('form_name')), 'Kaktus');

      expect(plant.name, 'Kaktus');
    });

    testWidgets('Enter notes', (WidgetTester tester) async {
      final plant = PlantModel();
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: plant,
            child: PlantForm(),
          ),
        ),
      );

      await tester.enterText(find.byKey(Key('form_notes')), 'Zelo obcutljiva');

      expect(plant.notes, 'Zelo obcutljiva');
    });

    group('CareInput', () {
      testWidgets('Default', (WidgetTester tester) async {
        final careModel = PlantCareModel();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CareInput(
                leading: Icon(Icons.opacity),
                name: 'Watering',
                careModel: careModel,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.opacity), findsOneWidget);
        expect(find.text('Watering'), findsOneWidget);
        expect(find.byType(Slider), findsNothing);
        expect(find.byType(Switch), findsOneWidget);
      });

      testWidgets('Enabled', (WidgetTester tester) async {
        final careModel = PlantCareModel(period: 2);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CareInput(
                leading: Icon(Icons.opacity),
                name: 'Watering',
                careModel: careModel,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.opacity), findsOneWidget);
        expect(find.text('Watering'), findsOneWidget);
        expect(find.textContaining('2'), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
        expect(find.byType(Switch), findsOneWidget);
      });

      testWidgets('Enable', (WidgetTester tester) async {
        final careModel = PlantCareModel();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CareInput(
                leading: Icon(Icons.opacity),
                name: 'Watering',
                careModel: careModel,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(careModel.period, 1);
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('Disable', (WidgetTester tester) async {
        final careModel = PlantCareModel(period: 2);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CareInput(
                leading: Icon(Icons.opacity),
                name: 'Watering',
                careModel: careModel,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(careModel.period, null);
        expect(find.byType(Slider), findsNothing);
      });

      testWidgets('Increase period', (WidgetTester tester) async {
        final careModel = PlantCareModel(period: 1);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CareInput(
                leading: Icon(Icons.opacity),
                name: 'Watering',
                careModel: careModel,
              ),
            ),
          ),
        );

        await tester.drag(find.byType(Slider), Offset(0, 30));
        expect(careModel.period, greaterThan(1));
      });
    });
  });
}
