import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:jury/DataBase/cache_helper.dart';
import 'package:jury/constants/constant.dart';
import 'package:jury/views/home.dart';
import 'package:jury/views/winner/selection.dart';
import 'package:jury/widgets/closeable.dart';
import 'package:jury/widgets/custom_fi.dart';

class RoundScreen extends StatefulWidget {
  const RoundScreen({super.key});
  static String routeName = "RoundScreen";
  @override
  State<RoundScreen> createState() => _RoundScreenState();
}

class _RoundScreenState extends State<RoundScreen> {
  String type = CacheHelper.getData(key: "Type");
  GlobalKey<FormState> key1 = GlobalKey();
  GlobalKey<FormState> key2 = GlobalKey();
  TextEditingController val1 = TextEditingController(),
      val2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorApp,
      body: Container(
        decoration: const BoxDecoration(
            image:
                DecorationImage(image: AssetImage("assets/1.jpg"), fit: BoxFit.cover)),
        child: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: Stack(
              children: [
                WindowTitleBarBox(
                  child: Row(
                    children: [
                      Expanded(child: MoveWindow()),
                      const WindowButtons()
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white70.withOpacity(0.75),
                        borderRadius: const BorderRadius.all(Radius.circular(25))),
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: MediaQuery.of(context).size.height / 1.85,
                    alignment: AlignmentDirectional.center,
                    child: Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  type,
                                  style: const TextStyle(
                                      fontSize: titleSize,
                                      color: textColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: CustomField(
                                  txtKey: key1,
                                  value: val1,
                                  name: "The number of turns",
                                  type: TextInputType.number,
                                  icon: Icons.roundabout_right_rounded),
                            ),
                            const SizedBox(
                              height: 37,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    CacheHelper.clearAllData();
                                    Navigator.pushReplacementNamed(
                                        context, Home.routeName);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Logout successfully"),
                                    ));
                                  },
                                  color: buttonColor,
                                  padding: const EdgeInsets.all(padding),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(buttonRadius),
                                  ),
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: labelSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    if (key1.currentState!.validate() == true) {
                                      CacheHelper.saveData(
                                          key: "NbRound", value: val1.text);
                                      CacheHelper.saveData(
                                          key: "CurrentRound", value: 1);
                                      Navigator.pushNamed(
                                          context, WinnerSelection.routeName);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text("Data saved successfully"),
                                      ));
                                    }
                                  },
                                  style: ButtonStyle(
                                      overlayColor:
                                          const WidgetStatePropertyAll(buttonColor),
                                      padding: const WidgetStatePropertyAll(
                                          EdgeInsetsDirectional.all(padding)),
                                      side: const WidgetStatePropertyAll(
                                          BorderSide(color: textColor, width: 1.8)),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(buttonRadius),
                                        ),
                                      )),
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: labelSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
