
import 'dart:async';
import 'dart:async';
import 'dart:async';
import 'dart:developer';
import 'dart:ui';

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
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/dish.dart';

class GenerateQRCodeScreen extends StatelessWidget {

  final Dish dish;

  //final qrLogoImage = await qrImageProvider.load();



  const GenerateQRCodeScreen(this.dish, {super.key});

  /*Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }*/

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)
    );
  }

  String get qrCodeData {
    return '{"dishId": ${dish.id}, "dishName": "${dish.name}", "dishDescription": "${dish.description}", "dishPrice": ${dish.price}}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async{

              final qrValidationResult = QrValidator.validate(
                data: qrCodeData,
                version: QrVersions.auto,
                errorCorrectionLevel: QrErrorCorrectLevel.L,


              );

              qrValidationResult.status == QrValidationStatus.valid
                  ? log('QR Code is valid')
                  : log('QR Code is NOT valid');

              final qrCode = qrValidationResult.qrCode;

              if (qrCode == null) {
                log('QR Code is null');
                return;
              }
              final painter = QrPainter.withQr(
                qr: qrCode,
                color: const Color(0xFF000000),
                gapless: true,
              );

              Directory tempDir = await getApplicationDocumentsDirectory();
              String tempPath = tempDir.path;
              final ts = DateTime.now().millisecondsSinceEpoch.toString();
              String path = '$tempPath/$ts.png';

              final picData = await painter.toImageData(2048, format: ImageByteFormat.png);
              await writeToFile(picData!, path);

            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Center(
          child: QrImageView(
            data: qrCodeData,
            version: QrVersions.auto,
            size: 320,
            gapless: false,
            backgroundColor: Colors.white,
            embeddedImage: const AssetImage('assets/images/bokafood-logo-3.png'),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(50, 50),
            ),
          ),
        )
      ),
    );
  }
}