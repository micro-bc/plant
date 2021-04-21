import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant/components/care_input.dart';
import 'package:plant/models/plant.dart';
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

      final titleText = find.text("Plant");

      expect(find.byType(IconButton), findsNWidgets(2));
      expect(titleText, findsOneWidget);
    });

    testWidgets('Open AddPlantPage', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      final addButton = find.byKey(ValueKey("addButton"));

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

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      verify(mockObserver.navigator?.pushNamed('/add')).called(1);

      expect(find.byType(AddPlantPage), findsOneWidget);
    });
  });

  group('Add plant page', () {
    testWidgets('Empty add plant page', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => PlantModel(),
          child: MaterialApp(home: AddPlantPage()),
        ),
      );

      final titleText = find.text("Add Plant");
      final apperanceText = find.text("Apperance");
      final nameText = find.text("Name");
      final periodicCareText = find.text("Periodic care");
      final wateringText = find.text("Watering");
      final sprayingText = find.text("Spraying");
      final feedingText = find.text("Feeding");
      final rotateText = find.text("Rotate");
      final otherText = find.text("Other");
      final notesText = find.text("Notes");

      expect(titleText, findsOneWidget);
      expect(apperanceText, findsOneWidget);
      expect(nameText, findsOneWidget);
      expect(periodicCareText, findsOneWidget);
      expect(wateringText, findsOneWidget);
      expect(sprayingText, findsOneWidget);
      expect(feedingText, findsOneWidget);
      expect(rotateText, findsOneWidget);
      expect(otherText, findsOneWidget);
      expect(notesText, findsOneWidget);
    });

    testWidgets('On tap apperance show My plant text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => PlantModel(),
          child: MaterialApp(home: AddPlantPage()),
        ),
      );

      final textField = find.byKey(ValueKey("plantName"));
      await tester.tap(textField);

      final myPlantText = find.text("My plant");
      expect(myPlantText, findsOneWidget);
    });

    testWidgets('Enter plant name', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => PlantModel(),
          child: MaterialApp(home: AddPlantPage()),
        ),
      );

      final textField = find.byKey(ValueKey("plantName"));
      await tester.enterText(textField, "Kaktus");

      expect(find.text("Kaktus"), findsOneWidget);
    });

    testWidgets('Enter notes', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => PlantModel(),
          child: MaterialApp(home: AddPlantPage()),
        ),
      );

      final textField = find.byKey(ValueKey("plantNotes"));
      await tester.enterText(textField, "Obcutljiva rastlina");

      expect(find.text("Obcutljiva rastlina"), findsOneWidget);
    });

    testWidgets('Enable watering period', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => PlantModel(),
          child: MaterialApp(home: AddPlantPage()),
        ),
      );

      final wateringInput = find.byType(CareInput).first;
      await tester.tap(wateringInput);
      await tester.pump();

      expect(find.text("every day"), findsOneWidget);
    });

    testWidgets('Set watering period', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => PlantModel(),
          child: MaterialApp(home: AddPlantPage()),
        ),
      );

      final wateringInput = find.byType(CareInput).first;

      await tester.tap(wateringInput);
      await tester.pump();

      expect(find.text("every day"), findsOneWidget);

      final slider = find.byType(Slider);

      await tester.drag(slider, Offset(200, 0));
      await tester.pump();

      final text = find.byKey(ValueKey('periodText')).toString();
      final ogText = text;
      print(ogText);

      expect(text, isNot("every day"));

      await tester.drag(slider, Offset(200, 0));
      await tester.pump();
      final textToCompare = find.byKey(ValueKey('periodText')).toString();
      print(textToCompare);

      expect(textToCompare, isNot(ogText));
    });
  });
}
