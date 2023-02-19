import 'package:flutter/material.dart';
import 'package:workout_planner/Widgets/fit_appbar.dart';
import 'package:workout_planner/Widgets/fit_appbar_drawer.dart';

// Choices to select
enum WorkoutChoices { buildMuscle, loseWeight }

enum EquipmentChoices { fullEquip, noEquip }

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  final GlobalKey<ScaffoldState> selectionPageScaffoldKey = GlobalKey<ScaffoldState>();
  WorkoutChoices? _workoutChoices;
  EquipmentChoices? _equipmentChoices;

  @override
  Widget build(BuildContext context) {
    final selectedOptionIndex = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      key: selectionPageScaffoldKey,
      appBar: fitAppbar(context, selectionPageScaffoldKey, selectedOptionIndex),
      endDrawer: const FitAppbarDrawer(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // Workout choices
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                  child: Text(
                    'Pick one:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                RadioListTile<WorkoutChoices>(
                  title: const Text('Build Muscle'),
                  value: WorkoutChoices.buildMuscle,
                  groupValue: _workoutChoices,
                  onChanged: (WorkoutChoices? value) {
                    setState(() {
                      _workoutChoices = value;
                    });
                  },
                ),
                RadioListTile<WorkoutChoices>(
                  title: const Text('Lose Weight'),
                  value: WorkoutChoices.loseWeight,
                  groupValue: _workoutChoices,
                  onChanged: (WorkoutChoices? value) {
                    setState(() {
                      _workoutChoices = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),

            // Equipments
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                  child: Text(
                    'Pick one:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                RadioListTile<EquipmentChoices>(
                  title: const Text('Full Equipment'),
                  value: EquipmentChoices.fullEquip,
                  groupValue: _equipmentChoices,
                  onChanged: (EquipmentChoices? value) {
                    setState(() {
                      _equipmentChoices = value;
                    });
                  },
                ),
                RadioListTile<EquipmentChoices>(
                  title: const Text('No Equipment'),
                  value: EquipmentChoices.noEquip,
                  groupValue: _equipmentChoices,
                  onChanged: (EquipmentChoices? value) {
                    setState(() {
                      _equipmentChoices = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),

            ElevatedButton(onPressed: _workoutChoices == null || _equipmentChoices == null ? null : () {}, child: const Text('Continue'))
          ],
        ),
      ),
    );
  }
}
