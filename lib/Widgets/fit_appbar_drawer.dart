import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_planner/main.dart';

class FitAppbarDrawer extends StatelessWidget {
  const FitAppbarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5, left: 10),
            child: Text('Username Placeholder'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: SignOutButton(variant: ButtonVariant.outlined,),
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
              style: TextStyle(fontWeight: FontWeight.w500),
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
