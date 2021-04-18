import 'package:flutter/material.dart';

class PlantType {
  static const PLANT1 = PlantType._('Type 1', 'assets/plant1.png');
  static const PLANT2 = PlantType._('Type 2', 'assets/plant2.png');
  static const PLANT3 = PlantType._('Type 3', 'assets/plant3.png');

  static const values = <PlantType>[
    PLANT1,
    PLANT2,
    PLANT3,
  ];

  static PlantType get defaultValue => PLANT1;

  static PlantType? getByName(String name) {
    final a = values.where((element) => element.name == name);
    return a.length == 1 ? a.first : null;
  }

  final String name, assetName;

  const PlantType._(this.name, this.assetName);

  ImageProvider getImage() => AssetImage(assetName);

  String toJson() => name;
}
