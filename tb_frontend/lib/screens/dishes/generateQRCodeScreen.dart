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


/// This class is used to display the qr code screen of a dish.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class GenerateQRCodeScreen extends StatefulWidget {
  final Dish dish;

  const GenerateQRCodeScreen(this.dish, {super.key});

  @override
  State<GenerateQRCodeScreen> createState() => _GenerateQRCodeScreenState();
}

/// This class is used to manage the state of the qr code screen.
class _GenerateQRCodeScreenState extends State<GenerateQRCodeScreen> {

  /// This function is used to write the qr code to a file.
  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  /// This function is used to get the data for the qr code.
  String get qrCodeData {
    return '{"id": ${widget.dish.id}, "name": "${widget.dish.name}", "price": ${widget.dish.price}, "calories": ${widget.dish.calories}, "currentType": "${widget.dish.currentType}", "currentSize": "${widget.dish.currentSize}", "available": ${widget.dish.isAvailable}}';
  }

  /// This function is used to save the qr code to the gallery.
  void _saveQrCode() async{
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

    /// This function is used to encode the image into byteData.
    final ByteData data =
        await rootBundle.load('assets/images/bokafood-logo-3.png');
    final ui.Image logoImage = await decodeImageFromList(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    /// This function is used to generate the qr code image.
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

    /// This function is used to get the path to the temporary directory. Used
    /// to save the qr code image temporarily before saving it to the gallery.
    Directory? tempDir = await getTemporaryDirectory();
    String? tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';

    /// Save the qr code image to the gallery.
    final picData = image;
    await writeToFile(picData!, path);
    final buffer = picData.buffer;
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(
            buffer.asUint8List(picData.offsetInBytes, picData.lengthInBytes)),
        name: "QrCode_$ts");

    /// Show a snackbar to inform the user if the qr code was saved to the gallery.
    /// If the qr code was saved successfully, the snackbar is green. Else it is red.
    if(context.mounted) {
      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR Code saved to gallery', textAlign: TextAlign.center),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
            Text('QR Code not saved to gallery', textAlign: TextAlign.center),
            backgroundColor: Colors.red,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
      }
    }
  }

  /// This function is used to build the qr code screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
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
                embeddedImage:
                    const AssetImage('assets/images/bokafood-logo-3.png'),
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(50, 50),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.dish.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: kColorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
            ],
          )),
    );
  }
}
