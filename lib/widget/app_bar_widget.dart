import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

const blueLight = Color(0XFF252848);

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool leading, actions;
  final VoidCallback shadow;
  const AppBarWidget({
    Key? key,
    required this.shadow,
    this.title = "",
    this.leading = true,
    this.actions = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: AutoSizeText(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      leading: leading
          ? Container(
              margin: const EdgeInsets.only(left: 5),
              child: ElevatedButton(
                  onPressed: shadow,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.square(60),
                      backgroundColor: blueLight,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Icon(Icons.close)))
          : null,
      actions: [
        actions
            ? Container(
                margin: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.square(40),
                        backgroundColor: blueLight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Icon(Icons.close)))
            : const SizedBox.shrink()
      ],
    );
  }
}
