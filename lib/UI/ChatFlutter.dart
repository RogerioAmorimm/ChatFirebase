import 'package:chatfirebase/UI/ChatMessage.dart';
import 'package:chatfirebase/UI/Provider.dart';
import 'package:chatfirebase/Uteis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'TextComposer.dart';

class ChatFlutter extends StatefulWidget {
  @override
  _ChatFlutterState createState() => _ChatFlutterState();
}

class _ChatFlutterState extends State<ChatFlutter> {
  ThemeChanger themeChanger;
  bool systemIsDark;

  @override
  Widget build(BuildContext context) {
    themeChanger = Provider.of<ThemeChanger>(context, listen: false);

    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(titulo),
          centerTitle: true,
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  titulo,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              SwitchListTile(
                title: themeChanger.isDark() ? Text('Lights') : Text('Dark'),
                value: themeChanger.isDark(),
                onChanged: (bool value) {
                  themeChanger.setDarkStatus(value);
                  saveData(value);
                },
                secondary: const Icon(Icons.lightbulb_outline),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection(collection_messages).snapshots(),
                builder: (context, snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),);
                    default:
                    return  ListView.builder(
                      reverse:  true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index){
                        List reversedList = snapshot.data.documents.reversed.toList();
                        return ChatMessage(reversedList[index].data);
                      }
                      );
                  }
                }
                ),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(),
            )
          ],
        ),
      ),
    );
  }
}
