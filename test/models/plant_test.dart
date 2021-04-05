import 'package:flutter_test/flutter_test.dart';
import 'package:plant/models/plant.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('PlantModel', () {
    test('Constructor with name Roža and empty notes', () {
      final plant = PlantModel(name: "Roza");

      expect(plant.name, "Roza");
      expect(plant.notes, "");
      expect(plant.id.length, 36); //standardna dolzina uuid.v4
      expect(Uuid.isValidUUID(plant.id), true);
    });

    test('Constructor with empty name and notes Notes', () {
      final plant = PlantModel(notes: "Notes");

      expect(plant.name, "");
      expect(plant.notes, "Notes");
    });

    test('Plant with id, name and notes', () {
      final plant = PlantModel(id: "1", name: "Kaktus", notes: "Ni obcutljiv");

      expect(plant.id, "1");
      expect(plant.notes, "Ni obcutljiv");
    });

    test('Clone', () {
      final plant = PlantModel(name: "Kokos", notes: "Arrrrrr");
      final clonePlant = plant.clone();

      expect(clonePlant, isNot(plant));
      expect(clonePlant.id, plant.id);
      expect(clonePlant.name, plant.name);
      expect(clonePlant.notes, plant.notes);
    });

    test('Get id', () {
      final plant = PlantModel(id: "42069");

      expect(plant.id, "42069");
    });

    test('Get name', () {
      final plant = PlantModel(name: "banana");

      expect(plant.name, "banana");
    });

    test('Get notes', () {
      final plant = PlantModel(notes: "Cudni tegl");

      expect(plant.notes, "Cudni tegl");
    });

    test('Set name', () {
      final plant = PlantModel();
      plant.name = "Hasagi";

      expect(plant.name, "Hasagi");
    });

    test('Set notes', () {
      final plant = PlantModel();

      plant.notes = "Sup dude";
      expect(plant.notes, "Sup dude");
    });

    test('Set plant watering period', () {
      final plant = PlantModel();
      plant.watering.period = 3;

      expect(plant.watering.period, 3);
    });
  });

  group('PlantCareModel', () {
    test('Constructor', () {
      final plantCare =
          PlantCareModel(period: 14, last: DateTime.utc(1999, 8, 13));

      expect(plantCare.period, 14);
      expect(plantCare.last.month, 8);
    });

    test('Negative period in constructor, expecting exception', () {
      expect(() => PlantCareModel(period: -20), throwsArgumentError);
    });

    test('Last date in past, expecting exception', () {
      final currentDate = DateTime.now();
      final pastDate =
          DateTime(currentDate.year, currentDate.month - 1, currentDate.day);

      expect(() => PlantCareModel(last: pastDate), throwsArgumentError);
    });

    test('Clone', () {
      final plantCareModel = PlantCareModel(period: 69, last: DateTime.now());
      final clone = plantCareModel.clone();

      expect(clone, isNot(plantCareModel));
      expect(clone.period, plantCareModel.period);
      expect(clone.last, plantCareModel.last);
    });

    test('Update last', () {
      final plantCare =
          PlantCareModel(period: 1, last: DateTime.utc(2021, 1, 1));

      plantCare.updateLast();

      expect(plantCare.last.month, DateTime.now().month);
      expect(plantCare.last.day, DateTime.now().day);
    });

    test('Get period', () {
      final plantCare = PlantCareModel(period: 5);

      expect(plantCare.period, 5);
    });

    test('Get last', () {
      final plantCare = PlantCareModel(last: DateTime(2021, 4, 5));

      expect(plantCare.last, DateTime(2021, 4, 5));
    });

    test('Days till care, period null', () {
      final care = PlantCareModel();
      final days = care.daysTillCare;

      expect(days, null);
    });

    test('Days till care, period 5, last now', () {
      final care = PlantCareModel(period: 5);
      final days = care.daysTillCare;

      expect(days, 6); //danes +5 = 6
    });

    test('Days till care, negative, expecting exception', () {
      //exception?
      final care = PlantCareModel(period: -5);
      final days = care.daysTillCare;

      expect(days, isPositive);
    });

    test('Set period', () {
      final care = PlantCareModel();
      care.period = 21;

      expect(care.period, 21);
    });

    test('Set period negative, expecting exception', () {
      final care = PlantCareModel();

      expect(() => care.period = -21, throwsArgumentError);
    });
  });

  group('Json', () {
    test('PlantModel toJson', () {
      final plant = PlantModel(name: "Orhideja", notes: "Jakobova rozica");
      final json = {'name': 'Orhideja', 'notes': 'Jakobova rozica'};
      final actualJson = plant.toJson();

      json.forEach((key, value) => expect(actualJson[key], value));
    });

    test('PlantModel fromJson', () {
      //nebi smelo failat, kontaktiraj Jakoba
      final plant =
          PlantModel.fromJson({'name': 'Orhideja', 'notes': 'Jakobova rozica'});

      expect(plant.name, "Orhideja");
      expect(plant.notes, "Jakobova rozica");
    });
  });
}
