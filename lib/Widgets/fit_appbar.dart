import 'package:flutter/material.dart';

PreferredSizeWidget fitAppbar(context, bool isHomePage, GlobalKey<ScaffoldState> scaffoldKey, String title) {
  return AppBar(
    automaticallyImplyLeading: isHomePage ? false : true,
    //leading: SizedBox(),
    title: Text(title),
    actions: [
      IconButton(
          onPressed: () {
            scaffoldKey.currentState!.openEndDrawer();
          },
          icon: const Icon(Icons.settings))
    ],
  );
}
