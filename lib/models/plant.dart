import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:plant/models/plant_care.dart';
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
        _type = type ?? PlantType.defaultValue,
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

  List<PlantCareModel> get _allCareModels =>
      <PlantCareModel>[_watering, _spraying, _feeding, _rotating];

  List<PlantCareModel> get enabledCare =>
      _allCareModels.where((care) => care.period != null).toList();

  bool get needsCare =>
      _allCareModels.any((care) => (care.daysTillCare ?? 1) <= 0);

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
