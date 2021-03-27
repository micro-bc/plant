import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:plant/models/plant.dart';

class PlantsModel extends ChangeNotifier {
  final Map<String, PlantModel> _plants = {};

  UnmodifiableListView<PlantModel> get plants =>
      UnmodifiableListView(_plants.values);

  void add(PlantModel plant) {
    _plants[plant.id] = plant;
    notifyListeners();
  }

  void remove(String id) {
    _plants.remove(id);
    notifyListeners();
  }
}
