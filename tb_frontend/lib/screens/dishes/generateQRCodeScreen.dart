
import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:barcode_widget/barcode_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:barcode_image/barcode_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/dish.dart';

class GenerateQRCodeScreen extends StatelessWidget {

  final Dish dish;


  const GenerateQRCodeScreen(this.dish, {super.key});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  /*Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {

              /*final image = img.Image(width: 350, height: 350);
              img.fill(image, color: img.ColorRgb8(255, 255, 255));
              drawBarcode(image, Barcode.qrCode(), 'Hello World', font: img.arial24);*/

              // Encode the resulting image to the PNG image format.
              //final png = img.encodePng(image);

             // final path =  _localPath;


             // log('==============================$path');

              //final path = '${directory.path}/$fileName';

             // File(path as String).writeAsBytesSync(png);
              /*// Convert the QR code image to PNG format
              final qrCodeImage = img.decodeImage(image!.buffer.asUint8List());*/

              // Show a dialog with the PNG file path
              /*showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('PNG Exported'),
                  content: Text('The QR code has been exported as a PNG image at: $path'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );*/
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),

        child: Center(
          child: QrImageView(
            data: '{"dishId": ${dish.id}, "dishName": "${dish.name}", "dishDescription": "${dish.description}", "dishPrice": ${dish.price}}',
            version: QrVersions.auto,
            size: 320,
            gapless: false,
            backgroundColor: Colors.white,
            embeddedImage: const AssetImage('assets/images/bokafood-logo-3.png'),
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: const Size(50, 50),
            ),
          ),
        )
      ),
    );
  }
}