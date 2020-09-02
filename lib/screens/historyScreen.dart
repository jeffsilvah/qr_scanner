import 'package:flutter/material.dart';
import 'package:qr_scanner/constants/colors.dart';
import 'package:qr_scanner/functions/showAlert.dart';
import 'package:qr_scanner/widgets/customText.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Widget> tileList = [];

  Future listLinks() async {
    var response = await Hive.openBox('searchedLinks');
    List<Widget> widgetList = [];

    response.toMap().forEach((key, value) {
      widgetList.add(
        Container(
          margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8)
            ),
            child: ListTile(
              leading: Icon(Icons.search, color: initialColor, size: 40),
              title: CustomText(
                text: value['link'],
                weight: FontWeight.bold,
                color: initialColor,
              ),
              subtitle: CustomText(
                text: value['time'],
                color: initialColor,
                size: 12,
              ),
              onTap: () async {
                if(await canLaunch(value['link'])){
                  await launch(value['link']);
                }else{
                  showAlert(context);
                }
              },
            ),
          ),
      );
    });

    tileList = widgetList;

    return response.toMap();
  }

  void removeAll() async {
    var response = await Hive.openBox('searchedLinks');

    response.toMap().forEach((key, value) {
      response.delete(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Voltar'),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                removeAll();
              });
            },
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: listLinks(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              if(tileList.length != 0){
                return ListView(
                  children: tileList,
                );
              }else{
                return Center(
                  child: CustomText(
                    text: 'Nada aqui',
                    color: initialColor,
                    size: 23,
                  ),
                );
              }
            }else{
              return Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(initialColor),
              ));
            }
          },
        ),
      ),
    );
  }
}
