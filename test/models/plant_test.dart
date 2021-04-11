import 'package:flutter_test/flutter_test.dart';
import 'package:plant/models/plant.dart';
import 'package:uuid/uuid.dart';

import '../custom_matchers.dart';

void main() {
  group('PlantModel', () {
    test('Default constructor', () {
      final plant = PlantModel();

      expect(Uuid.isValidUUID(plant.id), isTrue);
      expect(plant.name, '');
      expect(plant.notes, '');
      // Are not same instance
      expect(plant.watering, isNot(same(plant.spraying)));
      expect(plant.watering, isNot(same(plant.feeding)));
      expect(plant.watering, isNot(same(plant.rotating)));
      expect(plant.spraying, isNot(same(plant.feeding)));
      expect(plant.spraying, isNot(same(plant.rotating)));
      expect(plant.feeding, isNot(same(plant.rotating)));
      expect(plant.watering.period, isNull);
      expect(plant.spraying.period, isNull);
      expect(plant.feeding.period, isNull);
      expect(plant.rotating.period, isNull);
    });

    test('Constructor with parameters', () {
      final id = Uuid().v4();
      final careModel = PlantCareModel(period: 5);
      final plant = PlantModel(
        id: id,
        name: 'Kaktus',
        notes: 'Ni obcutljiv',
        watering: careModel,
        spraying: careModel,
        feeding: careModel,
        rotating: careModel,
      );

      expect(plant.id, id);
      expect(plant.name, 'Kaktus');
      expect(plant.notes, 'Ni obcutljiv');
      // Are not same instance
      expect(plant.watering, isNot(same(careModel)));
      expect(plant.spraying, isNot(same(careModel)));
      expect(plant.feeding, isNot(same(careModel)));
      expect(plant.rotating, isNot(same(careModel)));
      // Are equals
      expect(plant.watering, careModel);
      expect(plant.spraying, careModel);
      expect(plant.feeding, careModel);
      expect(plant.rotating, careModel);
    });

    test('Clone', () {
      final plant = PlantModel(name: 'Kokos', notes: 'Arrrrrr');
      final clonePlant = plant.clone();

      // Is not same instance
      expect(clonePlant, isNot(same(plant)));
      // Are equals
      expect(clonePlant, plant);
      // Are not same instance
      expect(clonePlant.watering, isNot(same(plant.watering)));
      expect(clonePlant.spraying, isNot(same(plant.spraying)));
      expect(clonePlant.feeding, isNot(same(plant.feeding)));
      expect(clonePlant.rotating, isNot(same(plant.rotating)));
    });

    test('Set name', () {
      final plant = PlantModel();
      plant.name = 'Hasagi';

      expect(plant.name, 'Hasagi');
    });

    test('Set notes', () {
      final plant = PlantModel();
      plant.notes = 'Water lightly';

      expect(plant.notes, 'Water lightly');
    });
  });

  group('PlantCareModel', () {
    test('Default constructor', () {
      final plantCare = PlantCareModel();

      expect(plantCare.period, isNull);
      expect(plantCare.last, isToday);
    });

    test('Constructor with parameters', () {
      final plantCare = PlantCareModel(
        period: 14,
        last: DateTime.utc(1999, 8, 13),
      );

      expect(plantCare.period, 14);
      expect(plantCare.last, DateTime.utc(1999, 8, 13));
    });

    test('Invalid period in constructor, expecting exception', () {
      expect(() => PlantCareModel(period: -20), throwsArgumentError);
      expect(() => PlantCareModel(period: 0), throwsArgumentError);
    });

    test('Last date in future, expecting exception', () {
      final futureDate = DateTime.now().add(Duration(days: 5));

      expect(() => PlantCareModel(last: futureDate), throwsArgumentError);
    }, skip: 'Not implemented');

    test('Clone', () {
      final plantCareModel = PlantCareModel(period: 69, last: DateTime.now());
      final clone = plantCareModel.clone();

      expect(clone, isNot(same(plantCareModel)));
      expect(clone, plantCareModel);
    });

    test('Update last', () {
      final plantCare = PlantCareModel(
        period: 1,
        last: DateTime.utc(2021, 1, 1),
      );

      plantCare.updateLast();

      expect(plantCare.last, isToday);
    });

    test('Days till care, period null', () {
      final care = PlantCareModel(period: null);

      expect(care.daysTillCare, null);
    });

    test('Days till care, period 5, last now', () {
      final care = PlantCareModel(
        period: 5,
        last: DateTime.now().subtract(Duration(seconds: 10)),
      );

      expect(care.daysTillCare, 5);
    });

    test('Days till care, period 5, last yesterday', () {
      final care = PlantCareModel(
        period: 5,
        last: DateTime.now().subtract(Duration(seconds: 10, days: 1)),
      );

      expect(care.daysTillCare, 4);
    });

    test('Days till care, period 5, last 6 days ago', () {
      final care = PlantCareModel(
        period: 5,
        last: DateTime.now().subtract(Duration(seconds: 10, days: 6)),
      );

      expect(care.daysTillCare, 0);
    });

    test('Days till care, period 5, last 10 days ago', () {
      final care = PlantCareModel(
        period: 5,
        last: DateTime.now().subtract(Duration(seconds: 10, days: 10)),
      );

      expect(care.daysTillCare, -4);
    });

    test('Set period', () {
      final care = PlantCareModel();
      care.period = 21;

      expect(care.period, 21);
    });

    test('Set period invalid, expecting exception', () {
      final care = PlantCareModel();

      expect(() => care.period = -21, throwsArgumentError);
      expect(() => care.period = 0, throwsArgumentError);
    });
  });

  group('Json', () {
    test('PlantModel toJson', () {
      final id = Uuid().v4();
      final careModel = PlantCareModel();
      final actualJson = PlantModel(
        id: id,
        name: 'Orhideja',
        notes: 'Jakobova rozica',
        watering: careModel,
        spraying: careModel,
        feeding: careModel,
        rotating: careModel,
      ).toJson();
      final expectedJson = {
        'id': id,
        'name': 'Orhideja',
        'notes': 'Jakobova rozica',
        'watering': careModel.toJson(),
        'spraying': careModel.toJson(),
        'feeding': careModel.toJson(),
        'rotating': careModel.toJson(),
      };

      expect(actualJson, expectedJson);
    });

    test('PlantCareModel toJson', () {
      final last = DateTime.now();
      final actualJson = PlantCareModel(
        period: 21,
        last: last,
      ).toJson();
      final expectedJson = {
        'period': 21,
        'last': last.toIso8601String(),
      };

      expect(actualJson, expectedJson);
    });

    test('PlantModel fromJson', () {
      final id = Uuid().v4();
      final plantCare = PlantCareModel(period: 21);
      final plant = PlantModel.fromJson({
        'id': id,
        'name': 'Orhideja',
        'notes': 'Jakobova rozica',
        'watering': plantCare.toJson(),
        'spraying': plantCare.toJson(),
        'feeding': plantCare.toJson(),
        'rotating': plantCare.toJson(),
      });

      expect(plant.id, id);
      expect(plant.name, 'Orhideja');
      expect(plant.notes, 'Jakobova rozica');
      expect(plant.watering.period, 21);
      expect(plant.spraying.period, 21);
      expect(plant.feeding.period, 21);
      expect(plant.rotating.period, 21);
    });

    test('PlantCareModel fromJson', () {
      final care = PlantCareModel.fromJson({
        'period': 21,
        'last': '2021-04-07',
      });

      expect(care.period, 21);
      expect(care.last.toIso8601String().substring(0, 10), '2021-04-07');
    });

    test('PlantModel fromJson empty', () {
      final plant = PlantModel.fromJson({});

      expect(plant.id, isNotNull);
      expect(plant.name, isEmpty);
      expect(plant.notes, isEmpty);
      expect(plant.watering, isInstanceOf<PlantCareModel>());
      expect(plant.spraying, isInstanceOf<PlantCareModel>());
      expect(plant.feeding, isInstanceOf<PlantCareModel>());
      expect(plant.rotating, isInstanceOf<PlantCareModel>());
    });

    test('PlantCareModel fromJson empty', () {
      final careModel = PlantCareModel.fromJson({});

      expect(careModel.period, isNull);
      expect(careModel.last, isToday);
    });
  });
}
