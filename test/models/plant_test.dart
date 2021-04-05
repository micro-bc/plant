import 'package:flutter_test/flutter_test.dart';
import 'package:plant/models/plant.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('PlantModel', () {
    test('PlantModel with name Roža and empty notes', () {
      final plant = PlantModel(name: "Roza");

      expect(plant.name, "Roza");
      expect(plant.notes, "");
      expect(plant.id.length, 36); //standardna dolzina uuid.v4
      expect(Uuid.isValidUUID(plant.id), true);
    });

    //prazen name

    test('Plant with id, name and notes', () {
      final plant = PlantModel(id: "1", name: "Kaktus", notes: "Ni obcutljiv");

      expect(plant.id, "1");
      expect(plant.notes, "Ni obcutljiv");
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
    test('PlantCareModel constructor', () {
      final plantCare =
          PlantCareModel(period: 14, last: DateTime.utc(1999, 8, 13));

      expect(plantCare.period, 14);
      expect(plantCare.last.month, 8);
    });

    test('PlantCareModel update last', () {
      final plantCare =
          PlantCareModel(period: 1, last: DateTime.utc(2021, 1, 1));

      plantCare.updateLast();

      expect(plantCare.last.month, DateTime.now().month);
      expect(plantCare.last.day, DateTime.now().day);
    });

    test('Clone', () {
      final plantCareModel = PlantCareModel(period: 69, last: DateTime.now());
      final clone = plantCareModel.clone();

      expect(clone, isNot(plantCareModel));
      expect(clone.period, plantCareModel.period);
      expect(clone.last, plantCareModel.last);
    });

    test('Negative period in constructor, expecting exception', () {
      expect(() => PlantCareModel(period: -20), throwsArgumentError);
    });

    //isto za set
  });

  group('Json', () {
    test('toJson', () {
      final plant = PlantModel(name: "Orhideja", notes: "Jakobova rozica");
      final json = {'name': 'Orhideja', 'notes': 'Jakobova rozica'};
      final actualJson = plant.toJson();

      json.forEach((key, value) => expect(actualJson[key], value));
    });

    test('fromJson', () {
      final plant =
          PlantModel.fromJson({'name': 'Orhideja', 'notes': 'Jakobova rozica'});

      expect(plant.name, "Orhideja");
      expect(plant.notes, "Jakobova rozica");
    });
  });
}
