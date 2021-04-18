import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:plant/utils/plant_type.dart';
import 'package:uuid/uuid.dart';

class PlantModel extends ChangeNotifier with EquatableMixin {
  String _id, _name, _notes;
  PlantType _type;
  PlantCareModel _watering, _spraying, _feeding, _rotating;

  @override
  List<Object?> get props =>
      [_id, _name, _notes, _type, _watering, _spraying, _feeding, _rotating];

  PlantModel({
    String? id,
    String? name,
    String? notes,
    PlantType? type,
    PlantCareModel? watering,
    PlantCareModel? spraying,
    PlantCareModel? feeding,
    PlantCareModel? rotating,
  })  : _id = id ?? Uuid().v4(),
        _name = name ?? "",
        _notes = notes ?? "",
        _type = type ?? PlantType.PLANT1,
        _watering = watering?.clone() ?? PlantCareModel(),
        _spraying = spraying?.clone() ?? PlantCareModel(),
        _feeding = feeding?.clone() ?? PlantCareModel(),
        _rotating = rotating?.clone() ?? PlantCareModel() {
    _watering.addListener(notifyListeners);
    _spraying.addListener(notifyListeners);
    _feeding.addListener(notifyListeners);
    _rotating.addListener(notifyListeners);
  }

  PlantModel clone() => PlantModel(
        id: _id,
        name: _name,
        notes: _notes,
        type: _type,
        watering: _watering.clone(),
        spraying: _spraying.clone(),
        feeding: _feeding.clone(),
        rotating: _rotating.clone(),
      );

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
        'notes': _notes,
        'type': _type.toJson(),
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
          type: map['type'] == null ? null : PlantType.getByName(map['type']),
          watering: map['watering'] == null
              ? null
              : PlantCareModel.fromJson(map['watering']),
          spraying: map['spraying'] == null
              ? null
              : PlantCareModel.fromJson(map['spraying']),
          feeding: map['feeding'] == null
              ? null
              : PlantCareModel.fromJson(map['feeding']),
          rotating: map['rotating'] == null
              ? null
              : PlantCareModel.fromJson(map['rotating']),
        );

  String get id => _id;
  String get name => _name;
  String get notes => _notes;
  PlantType get type => _type;

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

  set type(PlantType type) {
    _type = type;
    notifyListeners();
  }
}

class PlantCareModel extends ChangeNotifier with EquatableMixin {
  int? _period;
  DateTime _last;

  @override
  List<Object?> get props => [_period, _last];

  PlantCareModel({
    int? period,
    DateTime? last,
  })  : _period = period,
        _last = last ?? DateTime.now() {
    if ((period ?? 1) < 1) throw ArgumentError('Period must be >= 1 or null');
  }

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
          last: json['last'] == null ? null : DateTime.tryParse(json['last']),
        );

  void updateLast() {
    _last = DateTime.now();
    notifyListeners();
  }

  int? get period => _period;
  DateTime get last => _last;
  int? get daysTillCare => _period == null
      ? null
      : _last.add(Duration(days: _period!)).difference(DateTime.now()).inDays +
          1;

  set period(int? period) {
    if ((period ?? 1) < 1) throw ArgumentError('Period must be >= 1 or null');
    _period = period;
    notifyListeners();
  }
}
