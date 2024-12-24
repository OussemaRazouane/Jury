import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jury/DataBase/cache_helper.dart';
import 'package:jury/constants/constant.dart';
import 'package:jury/views/essai/selection.dart';
import 'package:jury/views/home.dart';
import 'package:jury/widgets/custom_fi.dart';


class EssaiScreen extends StatefulWidget {
  const EssaiScreen({super.key});
  static String routeName = "Essai";
  @override
  State<EssaiScreen> createState() => _EssaiScreenState();
}


class _EssaiScreenState extends State<EssaiScreen> {
  String type = CacheHelper.getData(key: "Type");
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController val=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      backgroundColor: bgColorApp,
      body: Container(
        decoration: const BoxDecoration(
            image:
                DecorationImage(image: AssetImage("1.jpg"), fit: BoxFit.cover)),
        child: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white70.withOpacity(0.75),
                  borderRadius:const BorderRadius.all(Radius.circular(25))),
            width: MediaQuery.of(context).size.width/2.3,
            height: MediaQuery.of(context).size.height/1.85,
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
                          style:const TextStyle(fontSize: titleSize, color: textColor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomField(
                        txtKey: key,
                        value: val,
                        name: "The number of trials",
                        type: TextInputType.number,
                        icon:Icons.timer_rounded,
                      ),
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
                                color: Colors.white, fontSize: labelSize),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (key.currentState!.validate() == true) {
                              CacheHelper.saveData(
                                  key: "NbEssai",
                                  value: val.text);
                              CacheHelper.saveData(
                                  key: "CurrentEssai",
                                  value: 1);
                              Navigator.pushNamed(
                                  context, EssaiSelection.routeName);
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
        ),
      ),
    );
  }
}
