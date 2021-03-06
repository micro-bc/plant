import 'package:flutter/material.dart';
import 'package:plant/components/plant_tile.dart';
import 'package:plant/models/plants.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/add'),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: _PlantListView(),
    );
  }
}

class _PlantListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlantsModel>(
      builder: (context, value, child) {
        var plants = value.plants;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: plants.length,
          itemBuilder: (context, index) => PlantTile(plant: plants[index]),
        );
      },
    );
  }
}
