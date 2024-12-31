import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jury/constants/constant.dart';
import 'package:jury/views/essai/essai.dart';
import 'package:jury/views/essai/selection.dart';
import 'package:jury/views/home.dart';
import 'package:jury/views/winner/round.dart';
import 'package:jury/views/winner/selection.dart';
import 'firebase_options.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:jury/DataBase/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(900, 700);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.show();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
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
      initialRoute: Home.routeName,
    );
  }
}
