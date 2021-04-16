import 'package:flutter/material.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/utils/care_icons.dart';
import 'package:provider/provider.dart';

import 'care_input.dart';

class PlantForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Form(
        child: Consumer<PlantModel>(
          builder: (context, plant, child) => ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              _FormGroup(
                title: 'Apperance',
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'My plant',
                    ),
                    initialValue: plant.name,
                    onChanged: (value) => plant.name = value,
                    validator: (value) {
                      if (value!.isEmpty) return 'Name cannot be empty!';
                    },
                  )
                ],
              ),
              _FormGroup(
                title: 'Periodic care',
                children: [
                  CareInput(
                    careModel: plant.watering,
                    leading: Icon(
                      CareIcons.water,
                      color: Colors.blue[400],
                    ),
                    name: 'Watering',
                  ),
                  CareInput(
                    careModel: plant.spraying,
                    leading: Icon(
                      CareIcons.spray,
                      color: Colors.green[400],
                    ),
                    name: 'Spraying',
                  ),
                  CareInput(
                    careModel: plant.feeding,
                    leading: Icon(
                      CareIcons.feed,
                      color: Colors.brown[400],
                    ),
                    name: 'Feeding',
                  ),
                  CareInput(
                    careModel: plant.rotating,
                    leading: Icon(
                      CareIcons.rotate,
                      color: Colors.purple[400],
                    ),
                    name: 'Rotate',
                  ),
                ],
              ),
              _FormGroup(
                title: 'Other',
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Notes'),
                    maxLines: null,
                    initialValue: plant.notes,
                    onChanged: (value) => plant.notes = value,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class _FormGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FormGroup({
    Key? key,
    required this.title,
    this.children = const <Widget>[],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: Container(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, textScaleFactor: 0.9),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: children),
              ),
            ],
          ),
        ),
      );
}
