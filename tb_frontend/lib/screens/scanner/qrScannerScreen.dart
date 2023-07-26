import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tb_frontend/screens/dishes/createDishScreen.dart';
import 'package:tb_frontend/screens/dishes/dishDetailsScreen.dart';
import '../../models/dish.dart';


/// This class is used to display the qr scanner screen of the application.
/// Inspired by: https://pub.dev/packages/mobile_scanner/example
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

/// This class is used to manage the state of the qr scanner screen.
class _QrScannerScreenState extends State<QrScannerScreen> with SingleTickerProviderStateMixin {
  BarcodeCapture? barcode;

  MobileScannerArguments? arguments;

  final MobileScannerController controller = MobileScannerController();

  bool isStarted = true;

  /// This function is used to initialize the state of the qr scanner screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        actions: [
          /// This button is used to toggle the torch of the qr scanner.
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
            onPressed: () => controller.toggleTorch(),
          ),
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
          /// This dialog is used to display the detected qr code.
          if (barcode != null) {
            controller.stop();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Barcode found!'),
                content: Text('Type: ${barcode.barcodes.first.rawValue}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        controller.start();
                      });
                    },
                    child: const Text('OK'),
                  ),
                  /// This button is used to navigate to the create dish screen with the details of the dish that was scanned.
                  TextButton(
                    onPressed: () {
                      String? rawValue = barcode.barcodes.first.rawValue;
                      if (rawValue != null) {
                        Dish dish = Dish.fromJson(jsonDecode(rawValue));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => DishDetailsScreen(dish)));
                      }
                    },
                    child: const Text('Dish Details'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
