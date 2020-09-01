import 'package:flutter/material.dart';
import 'package:qr_scanner/widgets/customText.dart';

Future<void> showAlert(context){
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: CustomText(text: 'Eita'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                CustomText(
                  text: 'Ocorreu um erro ao ler o QR code, tente novamente.',
                ),
              ],
            ),
          ),
        );
      }
  );
}