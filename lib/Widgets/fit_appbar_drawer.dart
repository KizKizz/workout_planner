import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_planner/main.dart';

import '../login_page.dart';

class FitAppbarDrawer extends StatelessWidget {
  const FitAppbarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: IconButton(
                    iconSize: 50,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<ProfileScreen>(
                          builder: (context) => ProfileScreen(
                            appBar: AppBar(
                              title: const Text('Profile'),
                            ),
                            actions: [
                              SignedOutAction((context) {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ));
                              })
                            ],
                            children: [
                              SizedBox(height: 100, child: Image.asset('assets/images/applogo.png', fit: BoxFit.fitHeight)),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: SizedBox(
                      width: 50,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 30,
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Logout')
                      ],
                    ))),
            // MaterialButton(
            //   onPressed: () {
            //     SignedOutAction(
            //       (context) {
            //         Navigator.pushReplacement(
            //           context,
            //           PageRouteBuilder(
            //             pageBuilder: (context, animation1, animation2) => const LoginPage(),
            //             transitionDuration: Duration.zero,
            //             reverseTransitionDuration: Duration.zero,
            //           ),
            //         );
            //       },
            //     );
            //   },
            //   child: Row(
            //     children: const [Icon(Icons.logout), SizedBox(width: 10), Text('Logout')],
            //   ),
            // ),
          ),
          Divider(
            height: double.minPositive,
            color: Theme.of(context).hintColor,
            indent: 10,
            endIndent: 10,
            thickness: 1,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5, left: 10),
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: MaterialButton(
              onPressed: () async {
                if (MyApp.themeNotifier.value == ThemeMode.light) {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isDarkModeOn', true);
                  MyApp.themeNotifier.value = ThemeMode.dark;
                } else {
                  final prefs = await SharedPreferences.getInstance();
                  MyApp.themeNotifier.value = ThemeMode.light;
                  prefs.setBool('isDarkModeOn', false);
                }
              },
              child: Row(
                  children: MyApp.themeNotifier.value == ThemeMode.light
                      ? const [Icon(Icons.dark_mode), SizedBox(width: 10), Text('Dark Theme')]
                      : const [Icon(Icons.light_mode), SizedBox(width: 10), Text('Light Theme')]),
            ),
          ),
        ],
      ),
    );
  }
}
// Widget fitAppbarDrawer(context) {
//   return Drawer(
//     child: Column(
//       children: [
//         MaterialButton(onPressed: () {},
//         child: Row(children: const [
//           Icon(Icons.logout),
//           Text('Logout')
//         ],),)
//       ],
//     ),
//   );
// }
