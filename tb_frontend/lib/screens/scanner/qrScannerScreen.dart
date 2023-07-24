import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tb_frontend/screens/dishes/createDishScreen.dart';
import 'package:tb_frontend/screens/dishes/dishDetailsScreen.dart';

import '../../models/dish.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with SingleTickerProviderStateMixin {
  //late MobileScannerController controller = MobileScannerController();
  //Barcode? barcode;
  BarcodeCapture? barcode;

  /*Future<void> onDetect(BarcodeCapture barcode) async {
    capture = barcode;
    setState(() => this.barcode = barcode.barcodes.first);
  }*/
  MobileScannerArguments? arguments;

  final MobileScannerController controller = MobileScannerController(
    //torchEnabled: true,
    // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
    // detectionSpeed: DetectionSpeed.normal
    // detectionTimeoutMs: 1000,
    // returnImage: false,
  );

  bool isStarted = true;

  void _startOrStop() {
    try {
      if (isStarted) {
        controller.stop();
      } else {
        controller.start();
      }
      setState(() {
        isStarted = !isStarted;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong! $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /*@override
  void initState() {
    // TODO: implement initState
    //cameraController.stop();
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            //iconSize: 32.0,
            onPressed: () => controller.toggleTorch(),
              //cameraController.toggleTorch();
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
        controller: controller,
        errorBuilder: (context, error, child) {
          return Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
        fit: BoxFit.contain,
        onDetect: (barcode) {
          setState(() {
            this.barcode = barcode;
          });

          if (barcode != null) {
            log("===================stoppping camera");
            controller.stop();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Barcode found!'),
                content:
                    Text('Type: ${barcode.barcodes.first.rawValue}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      log('===========================================hkjhkjh=== starting camera');
                      Navigator.of(context).pop();
                      setState(() {
                        log('============================================== starting camera');
                        controller.start();
                        /*barcodes.clear();
                        barcode = null;*/
                      });
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {

                        String? rawValue = barcode.barcodes.first.rawValue;
                        if (rawValue != null) {
                          Dish dish = Dish.fromJson(jsonDecode(rawValue));
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => DishDetailsScreen(dish)));
                        }
                        //Dish dish = Dish.fromJson(jsonDecode(barcode.barcodes.first.rawValue));
                    },
                    child: const Text('Dish Details'),
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
