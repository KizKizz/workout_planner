
import 'package:flutter/material.dart';
import 'package:workout_planner/Widgets/fit_appbar.dart';
import 'package:workout_planner/Widgets/fit_appbar_drawer.dart';
import 'package:workout_planner/main.dart';
import 'package:workout_planner/selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Local vars go here
  final GlobalKey<ScaffoldState> homePageScaffoldKey = GlobalKey<ScaffoldState>();
  final List<List<String>> _tiles = [
    ['Abs', 'assets/images/abs.png'],
    ['Chest', 'assets/images/chest.png'],
    ['Back', 'assets/images/back.png'],
    ['Arms', 'assets/images/arms.png'],
    ['Legs', 'assets/images/legs.png'],
  ];

  // Functions go here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homePageScaffoldKey,
      appBar: fitAppbar(context, true, homePageScaffoldKey, appName),
      endDrawer: const FitAppbarDrawer(),
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
                return 
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10.0)), side: BorderSide(width: 2, color: Theme.of(context).highlightColor)),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10.0)), side: BorderSide(width: 2, color: Theme.of(context).highlightColor)),
                    //tileColor: Colors.blueAccent,
                    title: Stack(
                      children: [
                        Image(image: AssetImage(_tiles[index][1]), fit: BoxFit.fill,),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              _tiles[index][0],
                              //style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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
                            settings: RouteSettings(arguments: _tiles[index][0]),
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
