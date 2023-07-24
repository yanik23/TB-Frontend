
import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';

import '../../models/dish.dart';

class GenerateQRCodeScreen extends StatelessWidget {

  final Dish dish;

  const GenerateQRCodeScreen(this.dish, {super.key});

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)
    );
  }

  String get qrCodeData {
    //return '{"dishId": ${dish.id}, "dishName": "${dish.name}", "dishPrice": ${dish.price}}';
    return '{"id": ${dish.id}, "name": "${dish.name}", "price": ${dish.price}, "calories": ${dish.calories}, "currentType": "${dish.currentType}", "currentSize": "${dish.currentSize}", "available": ${dish.isAvailable}}';
  }


  void _saveQrCode() async {
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
    final ByteData data = await rootBundle.load('assets/images/bokafood-logo-3.png');
    final ui.Image logoImage = await decodeImageFromList(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));


    final image = await QrPainter(
      data: qrCodeData,
      version: QrVersions.auto,
      gapless: true,
      color: Colors.black,
      emptyColor: Colors.white,
      embeddedImage: logoImage,
      embeddedImageStyle: const QrEmbeddedImageStyle(
        size: Size(320, 320),
      ),
    ).toImageData(2048, format: ui.ImageByteFormat.png);

    Directory? tempDir = await getApplicationDocumentsDirectory();
    String? tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    log("=====================path : $tempPath/$ts.png");
    String path = '$tempPath/$ts.png';

    final picData = image;
    await writeToFile(picData!, path);
    final buffer = picData.buffer;
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(buffer.asUint8List(picData.offsetInBytes, picData.lengthInBytes)), name: "QrCode_$ts");
    log("=====================result : $result");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async{
              _saveQrCode();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              QrImageView(
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
            const SizedBox(height: 16),
            Text(dish.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: kColorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
          ],

        )
      ),
    );
  }
}