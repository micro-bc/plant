import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/utils/plant_storage.dart';

class PlantsModel extends ChangeNotifier {
  final Map<String, PlantModel> _plants = {};

  PlantsModel();

  PlantsModel.fromList(List<PlantModel> plants) {
    plants.forEach((element) => _plants[element.id] = element);
  }

  UnmodifiableListView<PlantModel> get plants =>
      UnmodifiableListView(_plants.values);

  void add(PlantModel plant) {
    _plants[plant.id] = plant;
    _onChange();
  }

  void remove(String id) {
    _plants.remove(id);
    _onChange();
  }

  void _onChange() {
    notifyListeners();
    PlantStorage.savePlants(plants);
  }
}
