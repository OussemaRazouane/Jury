import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jury/views/essai/essai.dart';
import 'package:jury/views/essai/selection.dart';
import 'package:jury/views/home.dart';
import 'package:jury/views/winner/round.dart';
import 'package:jury/views/winner/selection.dart';
import 'firebase_options.dart';

import 'package:jury/DataBase/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    bool selectScreen = CacheHelper.containKey(key: "Type");
    bool nbRound = CacheHelper.containKey(key: "NbRound");
    bool nbEssai = CacheHelper.containKey(key: "NbEssai");
    String route() {
      if (!selectScreen) {
        return Home.routeName;
      } else if (!nbRound && !nbEssai) {
        if (!["Line follower", "Maze"].contains(CacheHelper.getData(key: "Type"))) {
          return RoundScreen.routeName;
        }else{
          return EssaiScreen.routeName;
        }
      }else if (nbEssai && ["Line follower", "Maze"].contains(CacheHelper.getData(key: "Type"))){
        return EssaiSelection.routeName;
      }else{
        return WinnerSelection.routeName;
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Jury",
      routes: {
        EssaiScreen.routeName: (context) => const EssaiScreen(),
        EssaiSelection.routeName: (context) => const EssaiSelection(),
        Home.routeName: (context) => const Home(),
        RoundScreen.routeName: (context) => const RoundScreen(),
        WinnerSelection.routeName: (context) => const WinnerSelection(),
      },
      initialRoute: route(),
    );
  }
}
