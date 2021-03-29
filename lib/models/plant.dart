import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PlantModel extends ChangeNotifier {
  String _id;
  String _name;
  String _notes;

  PlantCareModel _watering;
  PlantCareModel _spraying;
  PlantCareModel _feeding;
  PlantCareModel _rotating;

  PlantModel({
    String? id,
    String? name,
    String? notes,
    PlantCareModel? watering,
    PlantCareModel? spraying,
    PlantCareModel? feeding,
    PlantCareModel? rotating,
  })  : _id = id ?? Uuid().v4(),
        _name = name ?? "",
        _notes = notes ?? "",
        _watering = watering ?? PlantCareModel(),
        _spraying = spraying ?? PlantCareModel(),
        _feeding = feeding ?? PlantCareModel(),
        _rotating = rotating ?? PlantCareModel() {
    _watering.addListener(notifyListeners);
    _spraying.addListener(notifyListeners);
    _feeding.addListener(notifyListeners);
    _rotating.addListener(notifyListeners);
  }

  PlantModel clone() => PlantModel(
        id: _id,
        name: _name,
        notes: _notes,
        watering: _watering.clone(),
        spraying: _spraying.clone(),
        feeding: _feeding.clone(),
        rotating: _rotating.clone(),
      );

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
        'notes': _notes,
        'watering': _watering.toJson(),
        'spraying': _spraying.toJson(),
        'feeding': _feeding.toJson(),
        'rotating': _rotating.toJson(),
      };

  PlantModel.fromJson(Map<String, dynamic> map)
      : this(
          id: map['id'],
          name: map['name'],
          notes: map['notes'],
          watering: PlantCareModel.fromJson(map['watering']),
          spraying: PlantCareModel.fromJson(map['spraying']),
          feeding: PlantCareModel.fromJson(map['feeding']),
          rotating: PlantCareModel.fromJson(map['rotating']),
        );

  String get id => _id;
  String get name => _name;
  String get notes => _notes;

  PlantCareModel get watering => _watering;
  PlantCareModel get spraying => _spraying;
  PlantCareModel get feeding => _feeding;
  PlantCareModel get rotating => _rotating;

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set notes(String notes) {
    _notes = notes;
    notifyListeners();
  }
}

class PlantCareModel extends ChangeNotifier {
  int? _period;
  DateTime _last;

  PlantCareModel({
    int? period,
    DateTime? last,
  })  : _period = period,
        _last = last ?? DateTime.now();

  PlantCareModel clone() => PlantCareModel(
        period: _period,
        last: _last,
      );

  Map<String, dynamic> toJson() => {
        'period': _period,
        'last': _last.toIso8601String(),
      };

  PlantCareModel.fromJson(Map<String, dynamic> json)
      : this(
          period: json['period'],
          last: DateTime.tryParse(json['last']) ?? DateTime.now(),
        );

  int? get period => _period;
  DateTime get last => _last;
  int? get daysTillCare => _period == null
      ? null
      : _last.add(Duration(days: _period!)).difference(DateTime.now()).inDays +
          1;

  set period(int? period) {
    _period = period;
    notifyListeners();
  }

  set last(DateTime last) {
    _last = last;
    notifyListeners();
  }
}
