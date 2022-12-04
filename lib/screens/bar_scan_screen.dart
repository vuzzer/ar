import 'package:ar/widget/custom_floating_action_button.dart';
import 'package:ar/widget/custom_switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarCodeScreen extends StatefulWidget {
  const BarCodeScreen({super.key});

  @override
  State<BarCodeScreen> createState() => _BarCodeScreenState();
}

class _BarCodeScreenState extends State<BarCodeScreen>
    with SingleTickerProviderStateMixin {
  MobileScannerController controller = MobileScannerController(
    torchEnabled: true,
    ratio: Ratio.ratio_4_3,
  );

  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isDenied) {
      Permission.camera.request().then((value) {
        status = value;
      });
    }
    return status.isGranted;
  }

  void _showDialog(BuildContext context, String txt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Alert Dialog Box"),
        content:  Text(txt),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
              allowDuplicates: false,
              controller: MobileScannerController(
                  facing: CameraFacing.back, torchEnabled: false),
              onDetect: (barcode, args) {
                if (barcode.rawValue == null) {
                  //debugPrint('Failed to scan Barcode');
                  _showDialog(context, 'Failed to scan Barcode');
                } else {
                  final String code = barcode.rawValue!;
                  //debugPrint('Barcode found! $code');
                   _showDialog(context, 'Barcode found! $code');
                }
              }),
          const Positioned(bottom: 20, left: 10, child: CustomSwitchWidget())
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(),
    );
  }
}
