import 'package:flutter_test/flutter_test.dart';
import 'package:plant/models/plant_care.dart';

import '../custom_matchers.dart';

void main() {
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

  test('Days till care, period 5, last 5 days ago', () {
    final care = PlantCareModel(
      period: 5,
      last: DateTime.now().subtract(Duration(seconds: 10, days: 5)),
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

  test('Get next care, null period', () {
    final care = PlantCareModel();

    expect(care.nextCare, isNull);
  });

  test('Get next care', () {
    final care = PlantCareModel(period: 2);

    expect(care.nextCare, isNotNull);
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

  group('Json', () {
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

    test('PlantCareModel fromJson', () {
      final care = PlantCareModel.fromJson({
        'period': 21,
        'last': '2021-04-07',
      });

      expect(care.period, 21);
      expect(care.last.toIso8601String().substring(0, 10), '2021-04-07');
    });

    test('PlantCareModel fromJson empty', () {
      final careModel = PlantCareModel.fromJson({});

      expect(careModel.period, isNull);
      expect(careModel.last, isToday);
    });
  });
}
