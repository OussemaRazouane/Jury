import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

final buttonColors = WindowButtonColors(
    iconNormal: const Color.fromARGB(255, 255, 255, 255),
    mouseOver: const Color.fromARGB(255, 67, 39, 4),
    mouseDown: const Color.fromARGB(255, 255, 255, 255),
    iconMouseOver: const Color.fromARGB(255, 255, 255, 255),
    iconMouseDown: const Color.fromARGB(255, 67, 39, 4));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal:const Color.fromARGB(255, 255, 255, 255),
    iconMouseOver:const Color.fromARGB(255, 255, 255, 255));

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
