import 'package:flutter/material.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/utils/plant_type.dart';
import 'package:provider/provider.dart';

class SelectPlant extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Ink(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: () => showDialog<PlantType>(
              context: context,
              builder: (context) => _SelectPlantDialog(),
            ).then((value) {
              if (value != null) context.read<PlantModel>().type = value;
            }),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image(
                image: context
                    .select<PlantModel, PlantType>((value) => value.type)
                    .getImage(),
              ),
            ),
          ),
        ),
      );
}

class _SelectPlantDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: const Text('Select type'),
        children: PlantType.values
            .map((e) => SimpleDialogOption(
                  onPressed: () => Navigator.of(context).pop(e),
                  child: Row(
                    children: [
                      Image(image: e.getImage(), height: 80),
                      Text(e.name, textScaleFactor: 1.2),
                    ],
                  ),
                ))
            .toList(),
      );
}
