import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/models/plants.dart';

class PlantStorage {
  PlantStorage._();

  static Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/plants.json');
  }

  static Future<PlantsModel> getPlants() async {
    try {
      final file = await _localFile;

      List<dynamic> data = jsonDecode(await file.readAsString());

      return PlantsModel.fromList(
        List.generate(
          data.length,
          (index) => PlantModel.fromJson(data[index]),
        ),
      );
    } catch (e) {
      return PlantsModel();
    }
  }

  static Future<File> savePlants(List<PlantModel> plants) async {
    final file = await _localFile;

    return file.writeAsString(jsonEncode(plants));
  }
}
