import 'package:hive/hive.dart';

void storeLink({result}) async {
  var box = await Hive.openBox('searchedLinks');
  DateTime dateTime = DateTime.now();

  box.add({
    'link': result,
    'time': '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute}'
  });
}