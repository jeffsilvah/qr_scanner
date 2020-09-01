import 'package:flutter/cupertino.dart';

void navigate(context, {@required Widget route}){
  Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
}