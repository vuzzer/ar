import 'package:ar/provider/app_provider.dart';
import 'package:ar/utils/text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';


class CustomSwitchWidget extends StatefulWidget {
  const CustomSwitchWidget({super.key});

  @override
  State<CustomSwitchWidget> createState() => _CustomSwitchWidgetState();
}

class _CustomSwitchWidgetState extends State<CustomSwitchWidget> {
  bool value = true;
  @override
  Widget build(BuildContext context) {
    return LiteRollingSwitch(
      //initial value
      value: true,
      textOn: 'Posologie',
      textOff: 'Medicament',
      colorOn: Colors.greenAccent,
      colorOff: Colors.redAccent,
      iconOn: Icons.done,
      iconOff: Icons.remove_circle_outline,
      textSize: 16.0,
      onChanged: (bool state) {
        //Use it to manage the different states
        if (state) {
          Provider.of<AppProvider>(context, listen: false).setTurn(Turn.off);
        } else {
          Provider.of<AppProvider>(context, listen: false).setTurn(Turn.on);
        }
      },
      onSwipe: () {},
      onDoubleTap: () {},
      onTap: () {},
    );
  }
}
