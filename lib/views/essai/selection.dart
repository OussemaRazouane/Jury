import 'package:flutter/material.dart';
import 'package:jury/DataBase/cache_helper.dart';
import 'package:jury/constants/constant.dart';
import 'package:jury/views/essai/essai.dart';
import 'package:jury/widgets/data_sheet.dart';

class EssaiSelection extends StatefulWidget {
  const EssaiSelection({super.key});
  static String routeName = "EssaiSelection";
  @override
  State<EssaiSelection> createState() => _EssaiSelectionState();
}

class _EssaiSelectionState extends State<EssaiSelection> {
  final String type = CacheHelper.getData(key: "Type");
  final int nbEssai = int.parse(CacheHelper.getData(
    key: "NbEssai",
  ));
  final int currentEssai = CacheHelper.getData(
    key: "CurrentEssai",
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
                  mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            
                              Navigator.of(context)
                                  .pushNamed(EssaiScreen.routeName);
                            
                          },
                          icon: Icon(Icons.navigate_before_rounded,
                              size: 27, color: Colors.brown[800]),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(EssaiScreen.routeName);
                            },
                            child: Text(
                                "Go back",
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
                              if(currentEssai <= nbEssai){
                                Navigator.of(context)
                                    .pushNamed(EssaiSelection.routeName);
                                CacheHelper.saveData(key: "CurrentEssai", value:currentEssai + 1);
                              }
                            },
                            child: Text(currentEssai<nbEssai?'Next trial':currentEssai==nbEssai?'See final data':"",
                                style: TextStyle(
                                  fontSize: 27,
                                  color: Colors.brown[800],
                                ))),
                        if(currentEssai <= nbEssai)IconButton(
                          onPressed: () {
                            if(currentEssai <= nbEssai){
                                Navigator.of(context)
                                    .pushNamed(EssaiSelection.routeName);
                                CacheHelper.saveData(key: "CurrentEssai", value:currentEssai + 1);
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
                  child: Data(path: type, num:currentEssai,)
              ),
            ],
          ),
        ));
  }
}
