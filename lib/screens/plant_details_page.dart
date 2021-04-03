import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant/models/plant.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/utils/care_icons.dart';
import 'package:provider/provider.dart';

class PlantDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                _onDeletePressed(context, context.read<PlantModel>().id)
                    .then((value) {
              if (value) Navigator.pop(context);
            }),
          ),
        ],
      ),
      body: _PlantDetails(),
    );
  }
}

Future<bool> _onDeletePressed(BuildContext context, String id) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text('This will delete the plant'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            context.read<PlantsModel>().remove(id);
            Navigator.of(context).pop(true);
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

class _PlantDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<PlantModel>(
        builder: (context, plant, child) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Image.asset('assets/icon/app_icon.png', height: 150),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(plant.name, textScaleFactor: 1.8),
                ),
              ),
              _CareDetails(
                icon: Icon(CareIcons.water, color: Colors.blue[400]),
                careModel: plant.watering,
                title: 'Watering',
              ),
              _CareDetails(
                icon: Icon(CareIcons.spray, color: Colors.green[400]),
                careModel: plant.spraying,
                title: 'Spraying',
              ),
              _CareDetails(
                icon: Icon(CareIcons.feed, color: Colors.brown[400]),
                careModel: plant.feeding,
                title: 'Feeding',
              ),
              _CareDetails(
                icon: Icon(CareIcons.rotate, color: Colors.purple[400]),
                careModel: plant.rotating,
                title: 'Rotating',
              ),
            ],
          ),
        ),
      );
}

class _CareDetails extends StatelessWidget {
  final String title;
  final Icon icon;
  final PlantCareModel careModel;

  const _CareDetails({
    Key? key,
    required this.icon,
    required this.careModel,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: icon,
                  onPressed: () => careModel.updateLast(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title, textScaleFactor: 1.2),
                  ),
                ),
                if (careModel.period != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _daysTillCare(careModel.daysTillCare!),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Last: ${DateFormat.yMd().format(careModel.last)}',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Text _daysTillCare(int dtc) {
    if (dtc == 0)
      return Text('Do today', style: TextStyle(color: Colors.yellow[600]));
    if (dtc < 0)
      return Text(
        'Missed by ${-dtc} day${dtc < 1 ? "s" : ""}',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    return Text('In $dtc day${dtc > 1 ? "s" : ""}');
  }
}
