import 'package:localstorage/localstorage.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/models/plants.dart';

class PlantStorage {
  const PlantStorage._();

  static Future<LocalStorage> _getLocalStorage() async {
    final storage = LocalStorage('storage');
    if (!await storage.ready) throw Error();
    return storage;
  }

  static Future<PlantsModel> getPlants() async {
    final storage = await _getLocalStorage();
    final List<dynamic>? data = storage.getItem('plants');

    if (data == null) return PlantsModel();

    return PlantsModel.fromList(
      List.generate(
        data.length,
        (index) => PlantModel.fromJson(data[index]),
      ),
    );
  }

  static Future<void> savePlants(List<PlantModel> plants) async {
    final storage = await _getLocalStorage();

    return await storage.setItem('plants', plants);
  }
}
