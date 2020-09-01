import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setLinkList({@required List<String> value}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  
  preferences.setStringList('links', value);
}

Future<List<String>> getLinkList({@required String key}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return preferences.getStringList(key);
}

Future<void> removeAll() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  preferences.setStringList('links', []);
}