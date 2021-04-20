import 'package:flutter_test/flutter_test.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/models/plant_care.dart';
import 'package:plant/utils/plant_type.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('Default constructor', () {
    final plant = PlantModel();

    expect(Uuid.isValidUUID(plant.id), isTrue);
    expect(plant.name, isEmpty);
    expect(plant.notes, isEmpty);
    expect(plant.type, same(PlantType.defaultValue));
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
    final type = PlantType.PLANT2;
    final plant = PlantModel(
      id: id,
      name: 'Kaktus',
      notes: 'Ni obcutljiv',
      type: type,
      watering: careModel,
      spraying: careModel,
      feeding: careModel,
      rotating: careModel,
    );

    expect(plant.id, id);
    expect(plant.name, 'Kaktus');
    expect(plant.notes, 'Ni obcutljiv');
    expect(plant.type, same(type));
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
    expect(clonePlant.type, same(plant.type));
    // Are not same instance
    expect(clonePlant.watering, isNot(same(plant.watering)));
    expect(clonePlant.spraying, isNot(same(plant.spraying)));
    expect(clonePlant.feeding, isNot(same(plant.feeding)));
    expect(clonePlant.rotating, isNot(same(plant.rotating)));
  });

  test('Get enabled care, none enabled', () {
    final plant = PlantModel();

    expect(plant.enabledCare.length, 0);
  });

  test('Get enabled care, all enabled', () {
    final careModel = PlantCareModel(period: 2);
    final plant = PlantModel(
      watering: careModel,
      spraying: careModel,
      feeding: careModel,
      rotating: careModel,
    );

    expect(plant.enabledCare.length, 4);
  });

  test('Get needs care, none enabled', () {
    final plant = PlantModel();

    expect(plant.needsCare, isFalse);
  });

  test('Get needs care, expect false', () {
    final careModel = PlantCareModel(
      period: 2,
      last: DateTime.now().subtract(Duration(days: 1)),
    );
    final plant = PlantModel(watering: careModel);

    expect(plant.needsCare, isFalse);
  });

  test('Get needs care, expect true', () {
    final careModel = PlantCareModel(
      period: 2,
      last: DateTime.now().subtract(Duration(days: 5)),
    );
    final plant = PlantModel(watering: careModel);

    expect(plant.needsCare, isTrue);
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

  test('Set type', () {
    final plant = PlantModel();
    plant.type = PlantType.PLANT3;

    expect(plant.type, same(PlantType.PLANT3));
  });

  group('Json', () {
    test('PlantModel toJson', () {
      final id = Uuid().v4();
      final careModel = PlantCareModel();
      final type = PlantType.PLANT2;
      final actualJson = PlantModel(
        id: id,
        name: 'Orhideja',
        notes: 'Jakobova rozica',
        type: type,
        watering: careModel,
        spraying: careModel,
        feeding: careModel,
        rotating: careModel,
      ).toJson();
      final expectedJson = {
        'id': id,
        'name': 'Orhideja',
        'notes': 'Jakobova rozica',
        'type': type.toJson(),
        'watering': careModel.toJson(),
        'spraying': careModel.toJson(),
        'feeding': careModel.toJson(),
        'rotating': careModel.toJson(),
      };

      expect(actualJson, expectedJson);
    });

    test('PlantModel fromJson', () {
      final id = Uuid().v4();
      final plantCare = PlantCareModel(period: 21);
      final type = PlantType.PLANT2;
      final plant = PlantModel.fromJson({
        'id': id,
        'name': 'Orhideja',
        'notes': 'Jakobova rozica',
        'type': type.toJson(),
        'watering': plantCare.toJson(),
        'spraying': plantCare.toJson(),
        'feeding': plantCare.toJson(),
        'rotating': plantCare.toJson(),
      });

      expect(plant.id, id);
      expect(plant.name, 'Orhideja');
      expect(plant.notes, 'Jakobova rozica');
      expect(plant.type, same(type));
      expect(plant.watering.period, 21);
      expect(plant.spraying.period, 21);
      expect(plant.feeding.period, 21);
      expect(plant.rotating.period, 21);
    });

    test('PlantModel fromJson empty', () {
      final plant = PlantModel.fromJson({});

      expect(plant.id, isNotNull);
      expect(plant.name, isEmpty);
      expect(plant.notes, isEmpty);
      expect(plant.type, same(PlantType.defaultValue));
      expect(plant.watering, isInstanceOf<PlantCareModel>());
      expect(plant.spraying, isInstanceOf<PlantCareModel>());
      expect(plant.feeding, isInstanceOf<PlantCareModel>());
      expect(plant.rotating, isInstanceOf<PlantCareModel>());
    });
  });
}
