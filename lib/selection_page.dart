import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_planner/Helpers/state_provider.dart';
import 'package:workout_planner/Widgets/fit_appbar.dart';
import 'package:workout_planner/Widgets/fit_appbar_drawer.dart';
import 'package:workout_planner/instruction_page.dart';

// Choices to select
enum WorkoutChoices { buildMuscle, loseWeight }

enum EquipmentChoices { fullEquip, noEquip }

// Text file name
String instructionFileName = '';

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  final GlobalKey<ScaffoldState> selectionPageScaffoldKey = GlobalKey<ScaffoldState>();
  WorkoutChoices? _workoutChoices;
  EquipmentChoices? _equipmentChoices;
  final List<String> _textFileNameParts = [];
  final List<List<String>> _workoutParts = [
    ['Abs', 'abs'],
    ['Chest', 'chest'],
    ['Back', 'back'],
    ['Arms', 'arm'],
    ['Legs', 'leg'],
  ];

  @override
  Widget build(BuildContext context) {
    final selectedOptionIndex = ModalRoute.of(context)!.settings.arguments as List<String>;
    return Scaffold(
        key: selectionPageScaffoldKey,
        appBar: fitAppbar(context, selectionPageScaffoldKey, selectedOptionIndex.first),
        endDrawer: const FitAppbarDrawer(),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5.0)), side: BorderSide(width: 3, color: Theme.of(context).highlightColor)),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 250, maxWidth: 250),
                      width: constraints.maxWidth,
                      height: constraints.maxWidth,
                      child: Image(
                        image: AssetImage(selectedOptionIndex.last),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),

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

                ElevatedButton(
                    onPressed: _workoutChoices == null || _equipmentChoices == null
                        ? null
                        : () {
                            Provider.of<StateProvider>(context, listen: false).instructionPageReset();
                            String curWorkoutChoice = '${selectedOptionIndex.first} - ';
                            _textFileNameParts.clear();
                            int index = _workoutParts.indexWhere((element) => element.first == selectedOptionIndex.first);
                            _textFileNameParts.add(_workoutParts[index].last);
                            if (_workoutChoices == WorkoutChoices.buildMuscle) {
                              _textFileNameParts.add('bm');
                              curWorkoutChoice += 'Build Muscle - ';
                            } else if (_workoutChoices == WorkoutChoices.loseWeight) {
                              _textFileNameParts.add('lw');
                              curWorkoutChoice += 'Lose Weight - ';
                            }
                            if (_equipmentChoices == EquipmentChoices.fullEquip) {
                              _textFileNameParts.add('we');
                              curWorkoutChoice += 'With Equipment';
                            } else if (_equipmentChoices == EquipmentChoices.noEquip) {
                              _textFileNameParts.add('ne');
                              curWorkoutChoice += 'No Equipment';
                            }

                            instructionFileName = _textFileNameParts.join('_');
                            //print(instructionFileName);

                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) => const InstructionPage(),
                                  settings: RouteSettings(arguments: [curWorkoutChoice, instructionFileName]),
                                  transitionDuration: const Duration(milliseconds: 200),
                                  transitionsBuilder: (context, anim1, anim2, child) {
                                    return FadeTransition(
                                      opacity: anim1,
                                      child: child,
                                    );
                                  }),
                            );
                          },
                    child: const Text('Continue'))
              ],
            );
          }),
        ));
  }
}
