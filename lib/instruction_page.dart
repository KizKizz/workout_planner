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

List<String> instructions = [];

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
    final PageController pageController = PageController();
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
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 110,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: instructions.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 10,
                                margin: const EdgeInsets.only(top: 5, bottom: 15, left: 20, right: 20),
                                shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5.0)), side: BorderSide(width: 1, color: Theme.of(context).primaryColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    instructions[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                  )),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  pageController.previousPage(duration: Duration(seconds: 2), curve: Curves.bounceIn);
                                },
                                child: const Text('Previous Step')),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(''),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  pageController.nextPage(duration: Duration(seconds: 2), curve: Curves.bounceOut);
                                },
                                child: const Text('Next Step'))
                          ],
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
