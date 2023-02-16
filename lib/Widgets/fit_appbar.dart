import 'package:flutter/material.dart';

PreferredSizeWidget fitAppbar(context, GlobalKey<ScaffoldState> scaffoldKey, String title) {
  return AppBar(
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
