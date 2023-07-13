import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tb_frontend/screens/dishes/createDishScreen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late MobileScannerController controller = MobileScannerController();
  Barcode? barcode;
  BarcodeCapture? capture;

  Future<void> onDetect(BarcodeCapture barcode) async {
    capture = barcode;
    setState(() => this.barcode = barcode.barcodes.first);
  }

  MobileScannerArguments? arguments;
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    // TODO: implement initState
    cameraController.stop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    cameraController.stop();
    cameraController.start();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          /*IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),*/
        ],
      ),
      body: MobileScanner(
        // fit: BoxFit.contain,
        /*controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          //facing: CameraFacing.back,
          torchEnabled: false,
        ),*/

        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Barcode barcode = barcodes.last;
          final Uint8List? image = capture.image;
          /*for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
          }*/
          //cameraController.start();
          if (barcode.rawValue != null) {
            cameraController.stop();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Barcode found!'),
                content:
                    Text('Type: ${barcode.type}\nData: ${barcode.rawValue}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                      log('============================================new dish');
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => CreateDishScreen()));
                    },
                    child: const Text('Edit dish'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add to new Delivery'),
                  ),
                ],
              ),
            );
            /*Future.delayed(const Duration(seconds: 5), () {
              Navigator.pop(context);
            });*/
          }
        },
      ),
    );
  }
}
