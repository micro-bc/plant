import 'package:flutter/material.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/models/plants.dart';
import 'package:provider/provider.dart';

class AddPlantPage extends StatelessWidget {
  final PlantModel plant = PlantModel();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Plant'),
          actions: [
            IconButton(
              onPressed: () {
                // TODO Validate
                Provider.of<PlantsModel>(context, listen: false).add(plant);
                Navigator.pop(context);
              },
              icon: Icon(Icons.check),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _AddPlantForm(plant: plant),
        ),
      ),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('This will not save the plant'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

class _AddPlantForm extends StatefulWidget {
  final PlantModel plant;

  const _AddPlantForm({Key? key, required this.plant}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddPlantState(plant);
}

class _AddPlantState extends State<_AddPlantForm> {
  final PlantModel plant;

  _AddPlantState(this.plant);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          _FormGroup(
            title: 'Apperance',
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'My plant',
                ),
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
              _CareInput(
                leading: Icon(
                  Icons.opacity,
                  color: Colors.blue[400],
                ),
                name: 'Watering',
              ),
              _CareInput(
                leading: Icon(
                  Icons.blur_on,
                  color: Colors.green[400],
                ),
                name: 'Spraying',
              ),
              _CareInput(
                leading: Icon(
                  Icons.bubble_chart,
                  color: Colors.brown[400],
                ),
                name: 'Feeding',
              ),
              _CareInput(
                leading: Icon(
                  Icons.rotate_right,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CareInput extends StatelessWidget {
  final Widget leading;
  final String name;

  const _CareInput({
    Key? key,
    required this.leading,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          leading,
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(name),
          ),
        ],
      ),
    );
  }
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
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, textScaleFactor: 0.8),
            ...children,
          ],
        ),
      ),
    );
  }
}
