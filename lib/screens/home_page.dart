import 'package:flutter/material.dart';
import 'package:plant/models/plant.dart';
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
          itemBuilder: (context, index) => _PlantTile(plant: plants[index]),
        );
      },
    );
  }
}

class _PlantTile extends StatelessWidget {
  static const double padd = 18;
  final PlantModel plant;

  const _PlantTile({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: padd),
        child: Row(
          children: [
            Container(
              child: const Icon(Icons.ac_unit),
              margin: const EdgeInsets.only(right: padd),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.name, textScaleFactor: 1.2),
                  Row(
                    children: [
                      SubIcon(),
                      SubIcon(),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SubIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: const Icon(Icons.timer, size: 18),
          ),
          const Text('20'),
        ],
      ),
    );
  }
}
