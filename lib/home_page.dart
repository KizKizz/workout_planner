import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workout_planner/main.dart';
import 'package:workout_planner/selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Local vars go here
  final List<String> _tiles = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
    'Option 6',
  ];

  // Functions go here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.shortestSide < 600 ? 2 : 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: _tiles.length,
              itemBuilder: ((context, index) {
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10.0)), side: BorderSide(width: 2, color: Theme.of(context).highlightColor)),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10.0)), side: BorderSide(width: 2, color: Theme.of(context).highlightColor)),
                    tileColor: Colors.blueAccent,
                    title: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          _tiles[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        // MaterialPageRoute(
                        //   builder: (context) => const SelectionPage(),
                        //   settings: RouteSettings(arguments: _tiles[index]),
                        // ),
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => const SelectionPage(),
                            settings: RouteSettings(arguments: _tiles[index]),
                            transitionDuration: const Duration(milliseconds: 200),
                            transitionsBuilder: (context, anim1, anim2, child) {
                              return FadeTransition(
                                opacity: anim1,
                                child: child,
                              );
                            }),
                      );
                    },
                  ),
                );
              }))),
    );
  }
}
