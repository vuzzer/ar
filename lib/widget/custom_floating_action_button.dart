import 'package:ar/provider/app_provider.dart';
import 'package:ar/utils/text_to_speech.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';


class CustomFloatingActionButton extends StatefulWidget {
  @override
  State<CustomFloatingActionButton> createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.linear, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionBubble(
      // Menu items
      items: <Bubble>[
        // Floating action menu item
        Bubble(
          title: "Français",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.language,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Provider.of<AppProvider>(context, listen: false)
                .setLanguage(Language.francais);
            _animationController.reverse();
          },
        ),
        // Floating action menu item
        /*  Bubble(
          title: "Dioula",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.language,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Provider.of<AppProvider>(context, listen: false)
                .setLanguage(Language.dioula);
            _animationController.reverse();
          },
        ), */
        //Floating action menu item
        Bubble(
          title: "Baoulé",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.language,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Provider.of<AppProvider>(context, listen: false)
                .setLanguage(Language.baoule);
            _animationController.reverse();
          },
        ),
      ],
      // animation controller
      animation: _animation,
      
      // On pressed change animation state
      onPress: () {
       
        if (_animationController.isCompleted) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      },
      // Floating Action button Icon color
      iconColor: Colors.blue,
      // Flaoting Action button Icon
      iconData: Icons.settings,
      backGroundColor: Colors.white,
    );
  }
}
