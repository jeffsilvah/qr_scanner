import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_scanner/constants/colors.dart';
import 'package:qr_scanner/functions/showAlert.dart';
import 'package:qr_scanner/functions/storeLink.dart';
import 'package:qr_scanner/widgets/customText.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';

class ReadImageScreen extends StatefulWidget {
  @override
  _ReadImageScreenState createState() => _ReadImageScreenState();
}

class _ReadImageScreenState extends State<ReadImageScreen> {
  File image;
  ImagePicker imagePicker = ImagePicker();
  Uint8List bytes;
  String code;

  Future<void> getImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
        image = File(pickedFile.path);
        getCode(imageFile: image);
      });
    }
  }

  Future<void> getCode({imageFile}) async {
    bytes = imageFile.readAsBytesSync();
    code = await scanner.scanBytes(bytes);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Voltar'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomText(
                  text: 'Ler QR Code',
                  color: initialColor,
                  size: 22,
                  align: TextAlign.center,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: (){
                    getImage();
                  },
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: image == null ? Icon(
                        Icons.image,
                        color: initialColor,
                        size: 150,
                      ) : Image.memory(bytes),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                code != null ? Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: code == null ? Container() : Center(child: CustomText(text: code, color: initialColor, size: 20)),
                ) : Container(),
                SizedBox(height: 20),
                FlatButton(
                  onPressed: () async {
                    if(await canLaunch(code)){
                      await launch(code);
                      storeLink(result: code);
                    }else{
                      showAlert(context);
                    }
                  },
                  child: CustomText(text: 'Abrir', size: 18),
                  color: initialColor,
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
