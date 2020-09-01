import 'package:flutter/material.dart';
import 'package:qr_scanner/constants/colors.dart';
import 'package:qr_scanner/functions/database.dart';
import 'package:qr_scanner/functions/showAlert.dart';
import 'package:qr_scanner/widgets/customText.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> linkList;

  Future<List<String>> listLinks() async {
    List<String> response = await getLinkList(key: 'links');

    linkList = response;

    return response;
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
              if(linkList.length != 0){
                return ListView.separated(
                  itemCount: linkList.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: ListTile(
                        leading: Icon(Icons.search, color: initialColor, size: 40),
                        title: CustomText(
                          text: linkList[index],
                          color: initialColor,
                        ),
                        onTap: () async {
                          if(await canLaunch(linkList[index])){
                            await launch(linkList[index]);
                          }else{
                            showAlert(context);
                          }
                        },
                      ),
                    );
                  },
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
