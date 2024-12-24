import 'package:flutter/material.dart';
import 'package:jury/DataBase/cache_helper.dart';
import 'package:jury/constants/constant.dart';
import 'package:jury/widgets/data_sheet.dart';

class WinnerSelection extends StatefulWidget {
  const WinnerSelection({super.key});
  static String routeName = "WinnerSelectionScreen";

  @override
  State<WinnerSelection> createState() => _WinnerSelectionState();
}

class _WinnerSelectionState extends State<WinnerSelection> {
  final String type = CacheHelper.getData(key: "Type");
  final int nbRound = int.parse(CacheHelper.getData(
    key: "NbRound",
  ));
  final int currentRound = CacheHelper.getData(
    key: "CurrentRound",
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColorGen,
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.03,
                height: 60,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            CacheHelper.saveData(
                                key: "CurrentRound", value: currentRound - 1);
                          },
                          icon: Icon(Icons.navigate_before_rounded,
                              size: 27, color: Colors.brown[800]),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              CacheHelper.saveData(
                                  key: "CurrentRound", value: currentRound + 1);
                            },
                            child: Text("Go back",
                                style: TextStyle(
                                  fontSize: 27,
                                  color: Colors.brown[800],
                                ))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              if (currentRound <= nbRound) {
                                Navigator.of(context)
                                    .pushNamed(WinnerSelection.routeName);
                                CacheHelper.saveData(
                                    key: "CurrentRound",
                                    value: currentRound + 1);
                              }
                            },
                            child: Text(
                                currentRound < nbRound
                                    ? 'Next trial'
                                    : 'See final data',
                                style: TextStyle(
                                  fontSize: 27,
                                  color: Colors.brown[800],
                                ))),
                        IconButton(
                          onPressed: () {
                            if (currentRound <= nbRound) {
                              Navigator.of(context)
                                  .pushNamed(WinnerSelection.routeName);
                              CacheHelper.saveData(
                                  key: "CurrentRound", value: currentRound + 1);
                            }
                          },
                          icon: Icon(Icons.navigate_next_rounded,
                              size: 27, color: Colors.brown[800]),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.03,
                  height: MediaQuery.of(context).size.height - 120,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Data(
                    path: type,
                    num: currentRound,
                  )),
            ],
          ),
        ));
  }
}
