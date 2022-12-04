import 'dart:io';
import 'package:ar/constant/medoc.dart';
import 'package:ar/provider/app_provider.dart';
import 'package:ar/screens/ar_screen.dart';
import 'package:ar/utils/text_to_speech.dart';
import 'package:ar/widget/custom_floating_action_button.dart';
import 'package:ar/widget/custom_switch_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

var logger = Logger(printer: PrettyPrinter());

class QrScanScreen extends StatefulWidget {
  static const routeName = "/qr-scan";
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    //log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isDenied) {
      Permission.camera.request().then((value) {
        status = value;
      });
    }
    return status.isGranted;
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    setState(() {
        this.controller = controller;
    });
  
    controller.scannedDataStream.listen((scanData) {
      if (scanData != result) {
        result = scanData;
        //logger.d(result?.code);
        final String code = result?.code as String;
        controller.dispose();
        logger.d(code);
        logger.d(mapId[code]);
     
         if (mapId[code] == "Tanzol" ) {
          text_to_recommend();
        } else {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ArScreen(code: code)));
        }
      } 
    });
  }

  Widget buildQrScan(BuildContext context) {
    return Consumer<AppProvider>(
        builder: (context, value, child) => QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                _onQRViewCreated(controller, context);
              },
              overlay: QrScannerOverlayShape(
                borderColor: value.turn == Turn.off
                    ? CupertinoColors.systemGreen
                    : CupertinoColors.systemRed,
                borderRadius: 20,
                borderWidth: 10,
                cutOutSize: ScreenUtil().screenWidth * 0.7,
              ),
              onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            ));
  }

  @override
  Widget build(BuildContext context) {
    requestPermission();
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrScan(context),
          Positioned(
              top: 20,
              child: Row(
                children: [
                  Consumer<AppProvider>(
                      builder: (context, value, child) => AutoSizeText(
                            value.language.name,
                            style: const TextStyle(color: Colors.white),
                          )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.flash_on,
                        color: Colors.white,
                      ))
                ],
              )),
          const Positioned(bottom: 20, child: CustomSwitchWidget())
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(),
    );
  }
}
