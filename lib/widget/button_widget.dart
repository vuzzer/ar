
import 'package:flutter/material.dart';
const blue = Color(0XFF19A5D1);

class ButtonWidget extends StatelessWidget {
  final Function onPressed;
  final String title;
  final Color color;
  final double raduis;
  const ButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.color = blue, 
      this.raduis = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width, 50),
          shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(raduis)),
          backgroundColor: Color(0XFF252848).withOpacity(0.3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }
}
