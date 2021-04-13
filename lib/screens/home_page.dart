import 'package:flutter/material.dart';
import 'package:plant/components/plant_tile.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/utils/notification_helper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant'),
        actions: [
          IconButton(
            onPressed: () => context
                .read<NotificationHelper>()
                .show(0, 'Ur plant ded', 'Yo m8, water ur plant'),
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/add'),
            icon: const Icon(Icons.add_circle_outline),
            key: Key('addButton'),
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
