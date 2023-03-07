import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:workout_planner/Helpers/state_provider.dart';
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
                            onPageChanged: (int i) {
                              Provider.of<StateProvider>(context, listen: false).instructionPageSet(i + 1);
                            },
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 10,
                                margin: const EdgeInsets.only(top: 5, bottom: 15, left: 20, right: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                    side: BorderSide(width: 1, color: Theme.of(context).primaryColorLight)),
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
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                  onPressed: context.watch<StateProvider>().instructionPageIndex == 1
                                      ? null
                                      : () {
                                          pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.linear);
                                        },
                                  child: const Text('Previous Step')),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                  width: 60,
                                  child: Center(
                                      child: Text(
                                    '${context.watch<StateProvider>().instructionPageIndex} of ${instructions.length}',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                  ))),
                            ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                  onPressed: context.watch<StateProvider>().instructionPageIndex == instructions.length
                                      ? null
                                      : () {
                                          pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.linear);
                                        },
                                  child: const Text('Next Step')),
                            )
                          ],
                        )
                      ],
                    );
                  } else {
                    return const Text('No instruction found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500));
                  }
                }
              }
            }));
  }
}
