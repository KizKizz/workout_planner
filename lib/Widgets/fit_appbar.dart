import 'package:flutter/material.dart';

PreferredSizeWidget fitAppbar(context, GlobalKey<ScaffoldState> scaffoldKey, String title, bool showLogo, bool isLogoCenter) {
  return AppBar(
    title: showLogo
        ? isLogoCenter
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5, right: 20),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset(
                      'assets/images/applogo_small.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              )
            : Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Image.asset(
                    'assets/images/applogo_small.png',
                    fit: BoxFit.fitWidth,
                  ),
              ),
            )
        : Text(title),
    actions: [
      IconButton(
        iconSize: 30,
          onPressed: () {
            scaffoldKey.currentState!.openEndDrawer();
          },
          icon: const Icon(Icons.settings))
    ],
  );
}
