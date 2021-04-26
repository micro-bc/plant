import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'plant.dart';

class PlantsModel extends ChangeNotifier {
  final Map<String, PlantModel> _plants = {};

  void Function(PlantModel) onAdd = (plant) {};
  void Function(String) onRemove = (id) {};

  PlantsModel();

  PlantsModel.fromList(List<PlantModel> plants) {
    plants.forEach((element) => _plants[element.id] = element);
  }

  UnmodifiableListView<PlantModel> get plants =>
      UnmodifiableListView(_plants.values);

  void add(PlantModel plant) {
    _plants[plant.id] = plant;
    onAdd(plant);
    notifyListeners();
  }

  void remove(String id) {
    _plants.remove(id);
    onRemove(id);
    notifyListeners();
  }
}
