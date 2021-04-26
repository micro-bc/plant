import 'package:flutter/material.dart';
import 'package:plant/models/plant_care.dart';
import 'package:provider/provider.dart';

class CareInput extends StatelessWidget {
  final Widget leading;
  final String name;
  final PlantCareModel careModel;

  const CareInput({
    Key? key,
    required this.leading,
    required this.name,
    required this.careModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<PlantCareModel>.value(
        value: careModel,
        child: Consumer<PlantCareModel>(
          builder: (_, __, ___) => Column(
            children: [
              InkWell(
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
                        onChanged: (value) =>
                            careModel.period = (value ? 1 : null),
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
          ),
        ),
      );
}
