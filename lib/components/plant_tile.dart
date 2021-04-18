import 'package:flutter/material.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/utils/care_icons.dart';

class PlantTile extends StatelessWidget {
  final PlantModel plant;

  const PlantTile({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/details', arguments: plant),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image(image: plant.type.getImage(), height: 90),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        textScaleFactor: 1.2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: [
                          if (plant.watering.period != null)
                            _CareStatusIcon(
                              icon: CareIcons.water,
                              value: plant.watering.daysTillCare!,
                            ),
                          if (plant.spraying.period != null)
                            _CareStatusIcon(
                              icon: CareIcons.spray,
                              value: plant.spraying.daysTillCare!,
                            ),
                          if (plant.feeding.period != null)
                            _CareStatusIcon(
                              icon: CareIcons.feed,
                              value: plant.feeding.daysTillCare!,
                            ),
                          if (plant.rotating.period != null)
                            _CareStatusIcon(
                              icon: CareIcons.rotate,
                              value: plant.rotating.daysTillCare!,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CareStatusIcon extends StatelessWidget {
  final IconData icon;
  final int value;

  const _CareStatusIcon({
    Key? key,
    required this.icon,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Icon(icon, size: 18),
          ),
          Text(value.toString()),
        ],
      ),
    );
  }
}
