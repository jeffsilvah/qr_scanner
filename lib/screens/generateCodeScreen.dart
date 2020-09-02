import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner/constants/colors.dart';
import 'package:qr_scanner/widgets/customText.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class GenerateCodeScreen extends StatefulWidget {
  @override
  _GenerateCodeScreenState createState() => _GenerateCodeScreenState();
}

class _GenerateCodeScreenState extends State<GenerateCodeScreen> {
  String inputCode;
  var image;
  TextEditingController controller = TextEditingController();

  void generateCode(String input) async {
    Uint8List result = await scanner.generateBarCode(input);

    await ImageGallerySaver.saveImage(result);

    setState(() {
      image = result;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Voltar',
        ),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                    text: 'Gerar QR Code',
                    color: initialColor,
                    size: 22,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: controller,
                    onChanged: (String value){
                      inputCode = value;
                    },
                    style: TextStyle(
                      color: initialColor
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: cardColor,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        hintText: 'Ex: google.com.br',
                        hintStyle: TextStyle(
                            color: initialColor,
                            fontFamily: 'Saira'
                        )
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: (){
                      if(inputCode != null){
                        controller.clear();
                        generateCode('https://$inputCode');
                      }
                    },
                    child: CustomText(text: 'Gerar', size: 18),
                    color: initialColor,
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  SizedBox(height: 20),
                  image == null ? Container() : CustomText(
                    text: 'Código criado com sucesso, verifique a galeria do seu celular.',
                    color: initialColor,
                    size: 20,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Container(
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
                      ) : Image.memory(image),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
