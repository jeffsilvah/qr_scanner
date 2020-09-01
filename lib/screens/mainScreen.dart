import 'package:flutter/material.dart';
import 'package:qr_scanner/constants/colors.dart';
import 'package:qr_scanner/functions/database.dart';
import 'package:qr_scanner/functions/navigate.dart';
import 'package:qr_scanner/functions/showAlert.dart';
import 'package:qr_scanner/screens/historyScreen.dart';
import 'package:qr_scanner/widgets/customText.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String result;
  List<String> links = [];

  void scanResult() async {
    result = await scanner.scan();

    if(await canLaunch(result)){
      await launch(result);
      storeLink(result: result);
    }else{
      showAlert(context);
    }
  }

  void storeLink({result}) async {
    getLinkList(key: 'links').then((value) {
      if(value != null){
        links = value;
        links.add(result);

        setLinkList(value: links);
      }
    });
  }

  @override
  void initState(){
    super.initState();

    getLinkList(key: 'links').then((value) {
      if(value != null){
        links = value;
      }else{
        links = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(color: finalColor),
        backgroundColor: initialColor,
        children: [
          SpeedDialChild(
              child: Icon(
                Icons.add,
                color: finalColor,
              ),
              backgroundColor: initialColor,
              label: 'Gerar código',
              labelStyle: TextStyle(fontSize: 18.0, color: initialColor),
              onTap: () => print('Generate code')
          ),
          SpeedDialChild(
              child: Icon(
                Icons.phone_android,
                color: finalColor,
              ),
              backgroundColor: initialColor,
              label: 'Ler QR Code (Imagem)',
              labelStyle: TextStyle(fontSize: 18.0, color: initialColor),
              onTap: () => print('Read image')
          ),
          SpeedDialChild(
              child: Icon(
                Icons.history,
                color: finalColor,
              ),
              backgroundColor: initialColor,
              label: 'Histórico',
              labelStyle: TextStyle(fontSize: 18.0, color: initialColor),
              onTap: () => navigate(context, route: HistoryScreen())
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [initialColor, finalColor],
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomText(
              text: 'Scan QR code',
              align: TextAlign.center,
              weight: FontWeight.bold,
              size: 24,
            ),
            CustomText(
              text: 'Aponte a câmera do seu  celular para o QR code para realizar a leitura.',
              align: TextAlign.center,
              size: 18,
            ),
            GestureDetector(
              onTap: (){
                scanResult();
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 110,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
