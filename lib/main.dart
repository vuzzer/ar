import 'dart:io';

import 'package:ar/provider/app_provider.dart';
import 'package:ar/screens/ar_screen.dart';
import 'package:ar/screens/bar_scan_screen.dart';
import 'package:ar/screens/qr_scan_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:google_fonts/google_fonts.dart';


const d_green = Color(0xFF54D3C2);
List<CameraDescription> cameras = <CameraDescription>[];

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kReleaseMode) {
      exit(1);
    }
  };

  runApp( 
     MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AppProvider())
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medoc-Help',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: DevicePreview.appBuilder,
      home: ResponsiveWrapper.builder(
        const QrScanScreen(),
        maxWidth: 1200,
        minWidth: 480,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(480, name: TABLET),
        ],
      ),
    ));
  }
}


// Maalox 3582910022084
// Tanzol 8902292605715
// Gaviscon 3309525
// DIAZOLE


