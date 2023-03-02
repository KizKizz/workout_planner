import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:workout_planner/Widgets/fit_appbar.dart';
import 'package:workout_planner/Widgets/fit_appbar_drawer.dart';

class InstructionPage extends StatefulWidget {
  const InstructionPage({super.key});

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  final GlobalKey<ScaffoldState> instructionPageScaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<String>> getInstructionText(String filePath) async {
    List<String> textLines = [];
    if (kIsWeb) {
      await rootBundle.loadString(filePath).asStream().transform(const LineSplitter()).forEach((line) => textLines.add(line));
    } else {
      if (File(filePath).existsSync()) {
        await File(filePath).openRead().transform(utf8.decoder).transform(const LineSplitter()).forEach((line) => textLines.add(line));
      }
    }

    return textLines;
  }

  @override
  Widget build(BuildContext context) {
    final selectedWorkoutOptions = ModalRoute.of(context)!.settings.arguments as List<String>;
    List<String> instructions = [];
    return Scaffold(
        key: instructionPageScaffoldKey,
        appBar: fitAppbar(context, instructionPageScaffoldKey, selectedWorkoutOptions.first),
        endDrawer: const FitAppbarDrawer(),
        body: FutureBuilder(
            future:
                kIsWeb ? getInstructionText('assets/workout_instructions/${selectedWorkoutOptions.last}.txt') : getInstructionText('assets/workout_instructions/${selectedWorkoutOptions.last}.txt'),
            builder: (
              BuildContext context,
              AsyncSnapshot snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Loading Data',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator(),
                  ],
                );
              } else {
                if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Error while loading data',
                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 20),
                      ),
                    ],
                  );
                } else if (!snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Loading Data',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator(),
                    ],
                  );
                } else {
                  instructions = snapshot.data;
                  if (instructions.isNotEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < instructions.length; i++)
                          ListTile(
                            title: Text(
                              '- ${instructions[i]}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            onTap: () {},
                            trailing: ElevatedButton(
                              onPressed: i != 0
                                  ? null
                                  : () {
                                      instructions.removeAt(i);
                                      setState(() {});
                                    },
                              child: const Text('Done'),
                            ),
                          )
                      ],
                    );
                  } else {
                    return const Text('No instruction found');
                  }
                }
              }
            }));
  }
}
