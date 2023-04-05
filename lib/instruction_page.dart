import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:workout_planner/Helpers/state_provider.dart';
import 'package:workout_planner/Widgets/fit_appbar.dart';
import 'package:workout_planner/Widgets/fit_appbar_drawer.dart';
import 'package:workout_planner/main.dart';

import 'Helpers/instruction_images_helper.dart';


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
        // Header + SIde drawer
        appBar: fitAppbar(context, instructionPageScaffoldKey, selectedWorkoutOptions.first),
        endDrawer: const FitAppbarDrawer(),
        // Body - Instruction data fetcher
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
                        // Horizontal scroll pages
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 110,
                          width: MediaQuery.of(context).size.width,
                          //width: appWidth,
                          child: PageView.builder(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: instructions.length,
                            onPageChanged: (int i) {
                              Provider.of<StateProvider>(context, listen: false).instructionPageSet(i + 1);
                            },
                            itemBuilder: (context, index) {
                              return Center(
                                child: SizedBox(
                                  width: appWidth,
                                  child: Card(
                                    elevation: 10,
                                    margin: const EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        side: BorderSide(width: 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: SizedBox(
                                          width: appWidth,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  constraints: const BoxConstraints(maxHeight: appHeight * 0.5, maxWidth: appWidth),
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context).size.height * 0.5,
                                                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5.0)), border: Border.all(color: Theme.of(context).primaryColorDark)),
                                                  child: Center(child: Image.network(activityImageGet(instructions[index].split(':').first))),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: appHeight * 0.1,
                                              ),
                                              Text(
                                                '${instructions[index].split(':').first}:',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                                              ),
                                              Center(
                                                  child: Text(
                                                instructions[index].split(':').last,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Bottom page buttons
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
