import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_planner/home_page.dart';
import 'package:workout_planner/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String _userID = 'test';
  final String _userPassword = 'test';
  final _loginFormKey = GlobalKey<FormState>();
  final passFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Logo
                      //Container(padding: const EdgeInsets.only(top: 20), width: 500, height: 350, child: Image.asset('assets/Logo/logo_light.png')),
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), color: Theme.of(context).highlightColor),
                          child: const Text('Logo Placeholder')),

                      //Login
                      Stack(
                        children: [
                          Form(
                            key: _loginFormKey,
                            child: Column(
                              children: [
                                Container(
                                  width: 500,
                                  constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
                                  padding: const EdgeInsets.only(top: 40, bottom: 10, left: 5, right: 5),
                                  child: Text('Login:', style: TextStyle(fontSize: 15, color: Theme.of(context).hintColor)),
                                ),

                                // Username Input
                                Container(
                                  constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
                                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Login ID can\'t be empty';
                                      }
                                      if (value != _userID) {
                                        return 'Login ID is incorrect';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context).requestFocus(passFocus);
                                    },
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: 'Login ID',
                                      hintText: 'Enter your login ID (hint: $_userID)',
                                    ),
                                  ),
                                ),

                                // Password Input
                                Container(
                                  constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
                                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                                  child: TextFormField(
                                    focusNode: passFocus,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password can\'t be empty';
                                      }
                                      if (value != _userPassword) {
                                        return 'Password is incorrect';
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: 'Password',
                                      hintText: 'Enter your password (hint: $_userPassword)',
                                    ),
                                    onFieldSubmitted: (value) async {
                                      if (_loginFormKey.currentState!.validate()) {
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1, animation2) => const HomePage(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                //Login Button
                                Container(
                                    constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                                    child: SizedBox(
                                      width: 250,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.only(bottom: 11)),
                                          onPressed: () async {
                                            if (_loginFormKey.currentState!.validate()) {
                                              Navigator.pushReplacement(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context, animation1, animation2) => const HomePage(),
                                                  transitionDuration: Duration.zero,
                                                  reverseTransitionDuration: Duration.zero,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(fontSize: 30),
                                          )),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (MyApp.themeNotifier.value == ThemeMode.dark)
            FloatingActionButton.extended(
              //backgroundColor: Colors.deepOrange[800],
              icon: const Icon(Icons.light_mode),
              label: const Text(
                'Light Theme',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: (() async {
                final prefs = await SharedPreferences.getInstance();
                MyApp.themeNotifier.value = ThemeMode.light;
                prefs.setBool('isDarkModeOn', false);
                setState(() {});
              }),
            ),
          if (MyApp.themeNotifier.value == ThemeMode.light)
            FloatingActionButton.extended(
              //backgroundColor: Colors.deepOrange[800],
              icon: const Icon(Icons.dark_mode),
              label: const Text(
                'Dark Theme',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: (() async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('isDarkModeOn', true);
                MyApp.themeNotifier.value = ThemeMode.dark;
                setState(() {});
              }),
            )
        ],
      ),
    );
  }
}
