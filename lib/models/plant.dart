import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PlantModel extends ChangeNotifier {
  String _id;
  String _name;
  String _notes;

  int? _wateringPeriod;
  int? _sprayingPeriod;
  int? _feedingPeriod;
  int? _rotationPeriod;
  DateTime _lastWatered;
  DateTime _lastSprayed;
  DateTime _lastFed;
  DateTime _lastRotated;

  PlantModel({
    String? id,
    String? name,
    String? notes,
    int? wateringPeriod,
    int? sprayingPeriod,
    int? feedingPeriod,
    int? rotationPeriod,
    DateTime? lastWatered,
    DateTime? lastSprayed,
    DateTime? lastFed,
    DateTime? lastRotated,
  })  : _id = id ?? Uuid().v4(),
        _name = name ?? "",
        _notes = notes ?? "",
        _wateringPeriod = wateringPeriod,
        _sprayingPeriod = sprayingPeriod,
        _feedingPeriod = feedingPeriod,
        _rotationPeriod = rotationPeriod,
        _lastWatered = lastWatered ?? DateTime.now(),
        _lastSprayed = lastSprayed ?? DateTime.now(),
        _lastFed = lastFed ?? DateTime.now(),
        _lastRotated = lastRotated ?? DateTime.now();

  PlantModel clone() {
    return PlantModel(
      id: _id,
      name: _name,
      notes: _notes,
      wateringPeriod: _wateringPeriod,
      sprayingPeriod: _sprayingPeriod,
      feedingPeriod: _feedingPeriod,
      rotationPeriod: _rotationPeriod,
      lastWatered: _lastWatered,
      lastSprayed: _lastSprayed,
      lastFed: _lastFed,
      lastRotated: _lastRotated,
    );
  }

  String get id => _id;
  String get name => _name;
  String get notes => _notes;

  int? get wateringPeriod => _wateringPeriod;
  int? get sprayingPeriod => _sprayingPeriod;
  int? get feedingPeriod => _feedingPeriod;
  int? get rotationPeriod => _rotationPeriod;
  DateTime get lastWatered => _lastWatered;
  DateTime get lastSprayed => _lastSprayed;
  DateTime get lastFed => _lastFed;
  DateTime get lastRotated => _lastRotated;

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set notes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  void water() => _lastWatered = DateTime.now();
  set wateringPeriod(int? period) {
    _wateringPeriod = period;
    notifyListeners();
  }

  void spray() => _lastSprayed = DateTime.now();
  set sprayingPeriod(int? period) {
    _sprayingPeriod = period;
    notifyListeners();
  }

  void feed() => _lastFed = DateTime.now();
  set feedingPeriod(int? period) {
    _feedingPeriod = period;
    notifyListeners();
  }

  void rotate() => _lastRotated = DateTime.now();
  set rotationPeriod(int? period) {
    _rotationPeriod = period;
    notifyListeners();
  }
}
