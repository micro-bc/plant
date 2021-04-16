import 'package:flutter/material.dart';
import 'package:plant/components/plant_form.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/models/plants.dart';
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
            body: PlantForm(),
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
