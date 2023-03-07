import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_planner/Helpers/state_provider.dart';
import 'package:workout_planner/login_page.dart';

const String appName = 'FIT Workout Planner';

void main() {
  runApp(
    MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => StateProvider()),
  ], child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: MyApp.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: appName,
            // This theme was made for FlexColorScheme version 6.1.1. Make sure
            // you use same or higher version, but still same major version. If
            // you use a lower version, some properties may not be supported. In
            // that case you can also remove them after copying the theme to your app.
            theme: FlexThemeData.light(
              colors: const FlexSchemeColor(
                primary: Color(0xff1145a4),
                primaryContainer: Color(0xff9fb4da),
                secondary: Color(0xffb61d1d),
                secondaryContainer: Color(0xffe1a4a4),
                tertiary: Color(0xff376bca),
                tertiaryContainer: Color(0xffcfdbf2),
                appBarColor: Color(0xffcfdbf2),
                error: Color(0xffb00020),
              ),
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 9,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 10,
                blendOnColors: false,
                textButtonRadius: 1.0,
                elevatedButtonRadius: 0.0,
                outlinedButtonRadius: 1.0,
                inputDecoratorRadius: 1.0,
                inputDecoratorBorderWidth: 0.5,
                inputDecoratorFocusedBorderWidth: 1.0,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              // To use the playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            darkTheme: FlexThemeData.dark(
              colors: const FlexSchemeColor(
                primary: Color(0xffbbcae5),
                primaryContainer: Color(0xff577cbf),
                secondary: Color(0xffe9bfbf),
                secondaryContainer: Color(0xffcb6060),
                tertiary: Color(0xffdde5f5),
                tertiaryContainer: Color(0xff7297d9),
                appBarColor: Color(0xffdde5f5),
                error: null,
              ),
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 15,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                textButtonRadius: 1.0,
                elevatedButtonRadius: 0.0,
                outlinedButtonRadius: 1.0,
                inputDecoratorRadius: 1.0,
                inputDecoratorBorderWidth: 0.5,
                inputDecoratorFocusedBorderWidth: 1.0,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              // To use the Playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

            // Light/Dark mode button switch control
            themeMode: currentMode,
            home: const MyHomePage(title: appName),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDarkModeOn = false;

  // this will run the inside functions once after first loading up
  @override
  void initState() {
    themeModeCheck();
    super.initState();
    //go to login page after 3 seconds
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginPage(),
            )));
  }

  Future<void> themeModeCheck() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkModeOn = (prefs.getBool('isDarkModeOn') ?? false);
    if (isDarkModeOn) {
      MyApp.themeNotifier.value = ThemeMode.dark;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    //Splash screen
    return Scaffold(
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 250, minWidth: 250),
                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), color: Theme.of(context).highlightColor),
                  width: constraints.maxWidth * 0.3,
                  height: constraints.maxWidth * 0.3,
                  child: const Text('Logo Placeholder'),
                ),
              ],
            );
          })),
    );
  }
}
