import 'package:chatfirebase/UI/MyApp.dart';
import 'package:chatfirebase/UI/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeChanger>(
          create: (_) =>ThemeChanger(),
        )
      ],
      child:  MyApp(),)
    );
}
