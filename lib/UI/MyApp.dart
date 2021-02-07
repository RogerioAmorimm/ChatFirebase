import 'dart:convert';
import 'package:chatfirebase/UI/ChatFlutter.dart';
import 'package:chatfirebase/UI/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Uteis.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    readData().then((data) async {
      configList = json.decode(data);
      await googleSingin.signInSilently();
      if (googleSingin.currentUser != null) {
        dynamic itemList = returnItem(configList);
        if (itemList != null) {
          Provider.of<ThemeChanger>(context, listen: false).setDarkStatus(
              configList
                  .elementAt(configList.indexOf(itemList))[data_darkTheme]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkThemeEnabled = Provider.of<ThemeChanger>(context).isDark();

    return MaterialApp(
      title: titulo,
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? kIOSTheme
          : kAndroidTheme,
      darkTheme: Theme.of(context).platform == TargetPlatform.iOS
          ? kDarkIOSTheme
          : kDarkAndroidTheme,
      themeMode: darkThemeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: ChatFlutter(),
    );
  }
}
