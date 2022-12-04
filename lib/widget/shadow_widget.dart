import 'package:ar/widget/app_bar_widget.dart';
import 'package:ar/widget/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShadowWidget extends StatelessWidget {
  final VoidCallback shadow;
  const ShadowWidget({Key? key, required this.shadow}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          ...[
            'Indication'
                'posologie',
            'effet',
            'Contre_indication',
            'precaution',
            'interaction',
            'surdosage',
            'grossesse'
          ]
              .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ButtonWidget(onPressed: () {}, title: e, raduis: 30, )))
              .toList(),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: shadow,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
                minimumSize: const Size.square(60),
                backgroundColor: const Color(0XFF171B2F).withOpacity(0.3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: const Icon(
                Icons.close,
                color: CupertinoColors.systemGrey,
              ))
        ],
      ),
    );
  }
}
