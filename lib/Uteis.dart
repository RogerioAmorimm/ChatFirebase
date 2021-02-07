import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

// CONSTANTES
final String titulo = "ChatApp";
final googleSingin = GoogleSignIn();
final auth = FirebaseAuth.instance;

//COLLECTIONS
const collection_messages = "messages";

//DTO_DATA
const data_senderName = "senderName";
const data_text = "text";
const data_senderPhotoUrl = "senderPhotoUrl";
const data_imgUrl = "imgUrl";
const data_darkTheme = "darkTheme";
const data_senderID = "senderID";

final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kDarkIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kAndroidTheme = new ThemeData(
    primarySwatch: Colors.purple,
    accentColor: Colors.orangeAccent[400],
    backgroundColor: Colors.white,
    brightness: Brightness.light);
final ThemeData kDarkAndroidTheme = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey,
  accentColor: Color.fromRGBO(29, 161, 242, 1.00),
);

//Metodos
Future<Null> ensureLoggedIn() async {
  GoogleSignInAccount user = googleSingin.currentUser;
  await _signInGoogleAcount(user);
  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSingin.currentUser.authentication;
    AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: credentials.idToken, accessToken: credentials.accessToken);
    await auth.signInWithCredential(authCredential);
  }
}

Future _signInGoogleAcount(GoogleSignInAccount user) async {
  if (user == null) user = await googleSingin.signInSilently();
  if (user == null) user = await googleSingin.signIn();
}

void sendMessage({String text, String imgUrl}) {
  Firestore.instance.collection(collection_messages).add({
    data_text: text,
    data_imgUrl: imgUrl,
    data_senderName: googleSingin.currentUser.displayName,
    data_senderPhotoUrl: googleSingin.currentUser.photoUrl
  });
}

handleSubmitted(String text) async {
  await ensureLoggedIn();
  sendMessage(text: text);
}

//METODOS PARA GRAVAR CONFIGURACOES
List configList = [];

Future<File> _getFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File("${directory.path}/data.json");
}

Map<String, dynamic> returnItem(List configList) {
  return configList.firstWhere(
    (element) => element[data_senderID] == googleSingin.currentUser.id,
    orElse: () => null,
  );
}

void _addItem(bool darkTheme) {
  Map<String, dynamic> configItem = returnItem(configList);
  if (configItem != null) {
    configList.elementAt(configList.indexOf(configItem))[data_darkTheme] =
        darkTheme;
  } else {
    configItem =  new Map();
    configItem[data_senderID] = googleSingin.currentUser.id;
    configItem[data_darkTheme] = darkTheme;
    configList.add(configItem);
  }
}

Future<File> saveData(bool darkTheme) async {
  await _signInGoogleAcount(googleSingin.currentUser);
  _addItem(darkTheme);
  String data = json.encode(configList);
  final file = await _getFile();
  return file.writeAsString(data);
}

Future<String> readData() async {
  try {
    final file = await _getFile();

    return file.readAsString();
  } catch (e) {
    return e.toString();
  }
}
