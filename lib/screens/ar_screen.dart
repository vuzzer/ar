import 'dart:io';
import 'package:ar/utils/text_to_speech.dart';
import 'package:ar/widget/shadow_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());

class ArScreen extends StatefulWidget {
  final String code;
  const ArScreen({super.key, required this.code });

  @override
  State<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  //String localObjectReference;
  ARNode? localObjectNode;
  //String webObjectReference;
  ARNode? webObjectNode;
  ARNode? fileSystemNode;
  HttpClient? httpClient;
  bool shadow = false;
  bool voice = false;

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "assets/Images/triangle.png",
          showWorldOrigin: true,
          handleTaps: false,
        );
    this.arObjectManager!.onInitialize();

    //Download model to file system
    httpClient = new HttpClient();
    _downloadFile(
         "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        "LocalDuck.glb");
    // Alternative to use type fileSystemAppFolderGLTF2:
    //_downloadAndUnpack(
    //    "https://drive.google.com/uc?export=download&id=1fng7yiK0DIR0uem7XkV2nlPSGH9PysUs",
    //    "Chicken_01.zip");
  }

  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient!.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    logger.d("Downloading finished, path: " + '$dir/$filename');
    return file;
  }

  Future<void> onFileSystemObjectAtOrigin() async {
    if (this.fileSystemNode != null) {
      this.arObjectManager!.removeNode(this.fileSystemNode!);
      this.fileSystemNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.fileSystemAppFolderGLB,
          uri:  "LocalDuck.glb",
          scale: Vector3(0.2, 0.2, 0.2));
      //Alternative to use type fileSystemAppFolderGLTF2:
      //var newNode = ARNode(
      //    type: NodeType.fileSystemAppFolderGLTF2,
      //    uri: "Chicken_01.gltf",
      //    scale: Vector3(0.2, 0.2, 0.2));
      bool? didAddFileSystemNode = await this.arObjectManager!.addNode(newNode);
      this.fileSystemNode = (didAddFileSystemNode!) ? newNode : null;
    }
  }

  void _shadow() {
    setState(() {
      shadow = !shadow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: GestureDetector(
                onTap: () {},
                onDoubleTap: () {
                  setState(() {
                    shadow = !shadow;
                  });
                },
                child: Stack(children: [
                  ARView(
                    onARViewCreated: onARViewCreated,
                    planeDetectionConfig:
                        PlaneDetectionConfig.horizontalAndVertical,
                  ),
                  !shadow
                      ? Positioned(
                          bottom: 20,
                          left: ScreenUtil().screenWidth * 0.25,
                          child: Row(children: [
                            ElevatedButton(
                                onPressed: () async {
                                  await onFileSystemObjectAtOrigin();
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  minimumSize: const Size.square(60),
                                  backgroundColor:
                                      const Color(0XFF171B2F).withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color:  CupertinoColors.white,
                                )),
                            const SizedBox(width: 20,),
                             ElevatedButton(
                                onPressed: () async {
                                
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  minimumSize: const Size.square(60),
                                  backgroundColor:
                                      const Color(0XFF171B2F).withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                child: const Icon(
                                  Icons.keyboard_voice,
                                  color:  CupertinoColors.white,
                                )),
                                 const SizedBox(width: 20,),
                            //activate language
                            ElevatedButton(
                                onPressed: () async {
                                  text_to_speech(widget.code);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  minimumSize: const Size.square(60),
                                  backgroundColor:
                                      const Color(0XFF171B2F).withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                child: Icon(
                                  Icons.help,
                                  color: voice ? CupertinoColors.systemRed : CupertinoColors.systemGrey,
                                ))
                          ]))
                      : const SizedBox.shrink(),
                  shadow
                      ? ShadowWidget(
                          shadow: _shadow,
                        )
                      : const SizedBox.shrink()
                ]))));
  }
}
