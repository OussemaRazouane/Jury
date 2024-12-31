// ignore_for_file: sized_box_for_whitespace

import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:jury/DataBase/cache_helper.dart';
import 'package:jury/constants/constant.dart';
import 'package:jury/views/essai/essai.dart';
import 'package:jury/views/winner/round.dart';
import 'package:jury/widgets/closeable.dart';



class Home extends StatefulWidget {
  const Home({super.key});
  static String routeName = "Home";
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  late String type;
  bool obscure = true;
  List<String> types=["All roads","Line follower","Maze","Fighter","Junior"];
  Map<String,String> motDePasse = {
    "All roads":"Juryallroad2025", 
    "Fighter":"Juryfighter2025", 
    "Line follower":"Jurylinefollower2025", 
    "Maze":"Juryrobotmaze2025", 
    "Junior":"Juryjunior2025"
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorApp,
      body: Container(
        decoration:const BoxDecoration(
            image:DecorationImage(image:AssetImage("assets/2.jpg"),fit: BoxFit.cover )
          ),
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
                        borderRadius:const BorderRadius.all(Radius.circular(25))),
                    width: MediaQuery.of(context).size.width/2.3,
                    height: MediaQuery.of(context).size.height/1.6,
                    alignment: AlignmentDirectional.center,
                      child:
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                const Row(
                                  children: [
                                    Text(
                                      "Jury Login Panel",
                                      style:  TextStyle(fontSize: titleSize,color: textColor,fontWeight:FontWeight.bold),
                                    ),  
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Center(
                                  child: DropdownMenu(
                                    helperText:"Select the type" ,
                                    leadingIcon:const Icon(Icons.keyboard_alt_rounded,color:textColor),
                                    textStyle:const TextStyle(color:textColor ,fontWeight: FontWeight.bold) ,
                                    inputDecorationTheme:InputDecorationTheme(
                                      focusColor:
                                        const Color.fromARGB(255, 214, 197, 141),
                                      hoverColor:
                                        const Color.fromARGB(255, 203, 192, 158),
                                      labelStyle: const TextStyle(
                                        color: textColor, fontWeight: FontWeight.bold),
                                      hintStyle:  const TextStyle(color: textColor),
                                      border: OutlineInputBorder(
                                        borderSide:  const BorderSide(
                                          color: textColor, width: 2.5),
                                        borderRadius: BorderRadius.circular(fieldRadius),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:  const BorderSide(
                                            color: textColor, width: 2.5),
                                        borderRadius: BorderRadius.circular(fieldRadius),
                                      ),
                                    ),
                                    menuStyle:MenuStyle(
                                      backgroundColor:const WidgetStatePropertyAll(Color.fromARGB(255, 170, 162, 139)),
                                      padding:const WidgetStatePropertyAll(EdgeInsets.only(left:20,right:20 ,top:15)),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ) 
                                    ),
                                    enableFilter: true,
                                    onSelected: (val){
                                      setState(() {
                                        type=val!;
                                      });
                                    },
                                    dropdownMenuEntries:<DropdownMenuEntry<String>>[
                                      for(int i=0;i<types.length;i++)
                                        DropdownMenuEntry(
                                          value:types[i],
                                          label:types[i],
                                          style:const ButtonStyle(
                                            alignment: Alignment.center,
                                            textStyle:WidgetStatePropertyAll(TextStyle(color:textColor ,fontWeight: FontWeight.bold)) ,
                                          ),
                                        )
                                    ]
                                  ),
                                ),
                              const SizedBox(
                              height: 20,
                              ),
                              Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Form(
                                key: key,
                                child: TextFormField(
                                  controller: password,
                                  obscureText: obscure,
                                  decoration: InputDecoration(
                                    focusColor: fieldColor,
                                    labelStyle: const TextStyle(
                                        color: textColor, fontWeight: FontWeight.bold),
                                    hintStyle: const TextStyle(color: textColor),
                                    prefixIcon: const Icon(
                                      Icons.password_outlined,
                                      color: textColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(fieldRadius),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: textColor, width: 2.5),
                                      borderRadius: BorderRadius.circular(fieldRadius),
                                    ),
                                    labelText: "Password",
                                    hintText: "Enter your Password",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscure = !obscure;
                                        });
                                      },
                                      icon: !obscure
                                          ? const Icon(Icons.visibility,
                                              color: textColor)
                                          : const Icon(Icons.visibility_off,
                                              color: textColor),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Password is required";
                                    } else if (value!=motDePasse[type]) {
                                      return "Sheik the Password";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                                Center(
                                  child: MaterialButton(
                                      onPressed: () {
                                        if (key.currentState!.validate() == true) {
                                          CacheHelper.saveData(key: "Type", value: type);
                                          if(["Line follower","Maze"].contains(type)){
                                            Navigator.pushReplacementNamed(context, EssaiScreen.routeName);
                                          }else{
                                            Navigator.pushReplacementNamed(context,RoundScreen.routeName);
                                          }
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text("Login successfully"),
                                          ));
                                        }
                                      },
                                      color: buttonColor,
                                      padding: const EdgeInsets.all(padding),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        "Save",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                ),
                              ]
                            ),
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
