import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/utils/care_icons.dart';
import 'package:provider/provider.dart';

class AddPlantPage extends StatelessWidget {
  // TODO Form key provider
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => PlantModel(),
        builder: (context, _) => WillPopScope(
          onWillPop: () => _onBackPressed(context),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Add Plant'),
              actions: [
                IconButton(
                  onPressed: () {
                    // TODO Validate
                    context
                        .read<PlantsModel>()
                        .add(context.read<PlantModel>().clone());
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                )
              ],
            ),
            body: _AddPlantForm(),
          ),
        ),
      );
}

Future<bool> _onBackPressed(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text('This will not save the plant'),
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

class _AddPlantForm extends StatelessWidget {
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
                  _CareInput(
                    careModel: plant.watering,
                    leading: Icon(
                      CareIcons.water,
                      color: Colors.blue[400],
                    ),
                    name: 'Watering',
                  ),
                  _CareInput(
                    careModel: plant.spraying,
                    leading: Icon(
                      CareIcons.spray,
                      color: Colors.green[400],
                    ),
                    name: 'Spraying',
                  ),
                  _CareInput(
                    careModel: plant.feeding,
                    leading: Icon(
                      CareIcons.feed,
                      color: Colors.brown[400],
                    ),
                    name: 'Feeding',
                  ),
                  _CareInput(
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

class _CareInput extends StatelessWidget {
  final Widget leading;
  final String name;
  final PlantCareModel careModel;

  const _CareInput({
    Key? key,
    required this.leading,
    required this.name,
    required this.careModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          GestureDetector(
            onTap: careModel.period == null
                ? () => careModel.period = 1
                : () => careModel.period = null,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  leading,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(name),
                    ),
                  ),
                  if (careModel.period != null)
                    Text(
                      careModel.period == 1
                          ? 'every day'
                          : 'every ${careModel.period} days',
                      textScaleFactor: 1.2,
                    ),
                  Switch(
                    value: careModel.period != null,
                    onChanged: (value) => careModel.period = (value ? 1 : null),
                  ),
                ],
              ),
            ),
          ),
          if (careModel.period != null)
            // TODO Log. scale
            Slider(
              value: careModel.period!.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              onChanged: (value) => careModel.period = value.toInt(),
            ),
        ],
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
