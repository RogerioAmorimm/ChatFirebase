import 'dart:io';

import 'package:chatfirebase/Uteis.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final _textController = new TextEditingController();
  bool _ehComposer = false;
  void _reset() {
    _textController.clear();
    setState(() {
      _ehComposer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
        child: Row(
          children: <Widget>[
            Container(
              child: IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () async {
                    File imgFile =
                        await ImagePicker.pickImage(source: ImageSource.camera);

                    if (imgFile == null) return;

                    await ensureLoggedIn();
                    StorageUploadTask task = FirebaseStorage.instance
                        .ref()
                        .child(googleSingin.currentUser.id.toString() +
                            DateTime.now().millisecondsSinceEpoch.toString())
                        .putFile(imgFile);

                    StorageTaskSnapshot taskSnapshot = await task.onComplete;
                    String url = await taskSnapshot.ref.getDownloadURL();
                    sendMessage(imgUrl: url);
                    
                  }),
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar uma Mensagem"),
                onChanged: (texto) {
                  setState(() {
                    _ehComposer = texto.length > 0;
                  });
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? (_ehComposer
                        ? CupertinoButton(
                            child: Text("Enviar"),
                            onPressed: () {
                              handleSubmitted(_textController.text);
                              _reset();
                            })
                        : null)
                    : (_ehComposer
                        ? IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              handleSubmitted(_textController.text);
                              _reset();
                            })
                        : null))
          ],
        ),
      ),
    );
  }
}
