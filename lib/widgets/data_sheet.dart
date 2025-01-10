import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jury/widgets/custom_fi.dart';
import 'package:pluto_grid/pluto_grid.dart';

// import 'package:firebase_storage/firebase_storage.dart';
import 'package:jury/constants/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Data extends StatefulWidget {
  const Data({super.key, required this.path, required this.num});
  final String path;
  final int num;
  @override
  State<Data> createState() => _DataState();
}

// ignore: non_constant_identifier_names
class _DataState extends State<Data> {
  late List<PlutoColumn> columns;
  late List<PlutoRow> rows;
  List<PlutoColumnGroup> columnGroups = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchArticles(String path) async {
    try {
      QuerySnapshot querySnapshot;

      if (!["Line follower", "Maze"].contains(path)) {
        querySnapshot = await _firestore
            .collection(widget.path)
            .where("Round", isEqualTo: widget.num)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection(widget.path)
            .where("Trial", isEqualTo: widget.num)
            .get();
      }
      List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['ID'] = doc.id; // Add document ID to the data map
        return data;
      }).toList();
      columns = [
        PlutoColumn(
            title: 'ID',
            field: 'ID',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            enableRowChecked: true,
            enableSorting: true,
            hide: true),
        PlutoColumn(
            title: "Leader name",
            field: "Leader name",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            enableRowChecked: true,
            enableSorting: true),
        PlutoColumn(
          title: "Robot name",
          field: "Robot name",
          type: PlutoColumnType.text(),
          enableEditingMode: false,
        ),
        PlutoColumn(
          title: "TotalHomPoint",
          field: "TotalHomPoint",
          type: PlutoColumnType.text(),
          enableEditingMode: false,
        ),
        if (!["Line follower", "Maze"].contains(path))
          PlutoColumn(
            title: "Round",
            field: "Round",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
      ];
      for (String key in data[0].keys) {
        if (key.toUpperCase() != "ID" &&
            key != "First image" &&
            key != "Second image" &&
            key != "Leader name" &&
            key != "Robot name" &&
            key != "Round" &&
            key != "TotalHomPoint" &&
            !key.contains("Trial")) {
          columns.add(PlutoColumn(
            title: key,
            field: key,
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ));
        } else if (key == "First image" || key == "Second image") {
          print(data[0][key]);
          columns.add(PlutoColumn(
            title: key,
            field: key,
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            hide: true,
          ));
        } else if (key.contains("Trial")) {
          if (key == "Trial") {
            columns.add(PlutoColumn(
              title: key,
              field: key,
              type: PlutoColumnType.text(),
              enableEditingMode: false,
              hide: true,
            ));
          } else {
            for (String k in data[0][key].keys) {
              columns.add(PlutoColumn(
                title: k,
                field: k,
                type: PlutoColumnType.text(),
                enableEditingMode: false,
              ));
            }
          }
        }
      }
      Map<String, PlutoCell> f(m) {
        Map<String, PlutoCell> l = Map<String, PlutoCell>();

        for (String key in m.keys) {
          if (!key.contains("Trial")) {
            l.addAll({key: PlutoCell(value: m[key])});
          } else if (key.contains("Trial")) {
            if (key == "Trial") {
              l.addAll({key: PlutoCell(value: m[key])});
            } else {
              for (String k in m[key].keys) {
                l.addAll({k: PlutoCell(value: m[key][k])});
              }
            }
          }
        }
        print(l);
        return l;
      }

      // Define rows
      rows = [];
      for (Map<String, dynamic> m in data) {
        rows.add(PlutoRow(
          cells: f(m),
        ));
      }
      if (["Line follower", "Maze"].contains(path)) {
        for (String key in data[0].keys) {
          if (key.contains('Trial')) {
            if (key == "Trial") {
              continue;
            } else {
              columnGroups.add(PlutoColumnGroup(title: key, children: [
                for (String keychild in data[0][key].keys)
                  PlutoColumnGroup(title: keychild, fields: [keychild])
              ]));
            }
          }
        }
      }
      return data;
    } catch (e) {
      print("Error getting Data   ${e}");
      throw e; // Propagate the error
    }
  }

  void _showPopup(BuildContext context, PlutoRow row, String path, int num) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(num: num, path: path, row: row);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: fetchArticles(widget.path),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.brown[900],
              ));
            }
            if (snapshot.hasError) {
              return SingleChildScrollView(
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      "Error: Data not founded",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[900],
                          decoration: TextDecoration.none),
                    ),
                    Image.asset(
                      "assets/errordata2.gif",
                    ),
                  ],
                )),
                
              );
            }
            if (snapshot.hasData) {
              {
                return PlutoGrid(
                  columns: columns,
                  rows: rows,
                  columnGroups: columnGroups,
                  onRowDoubleTap: (event) {
                    _showPopup(context, event.row, widget.path, widget.num);
                  },
                  onRowChecked: (event) {
                    if (event.row!.checked == true) {
                      _showPopup(context, event.row!, widget.path, widget.num);
                    }
                  },
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    PlutoGridStateManager stateManager = event.stateManager;
                    stateManager.setShowColumnFilter(true);
                  },
                  rowColorCallback: (rowContext) {
                    // Change the row color for a specific condition
                    if (rowContext.row.checked == true) {
                      return Colors
                          .green[500]!; // Change color for row with ID = 5
                    }
                    return Colors.white; // Default color
                  },
                  configuration: const PlutoGridConfiguration(),
                );
              }
            }
            return SingleChildScrollView(
              child: Center(
                  child: Column(
                children: [
                  Text(
                    "Error: Data not founded",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[900],
                        decoration: TextDecoration.none),
                  ),
                  Image.asset(
                    "assets/errordata1.gif",
                  ),
                ],
              )),
            );
            // Return empty space when data is not loaded
          }),
    );
  }
}

class CustomDialog extends StatefulWidget {
  const CustomDialog(
      {super.key, required this.row, required this.path, required this.num});
  final PlutoRow row;
  final String path;
  final int num;
  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  Set<bool> descalifier = {true};
  TextEditingController value1 = TextEditingController();
  GlobalKey<FormState> txtKey1 = GlobalKey();
  TextEditingController value2 = TextEditingController();
  GlobalKey<FormState> txtKey2 = GlobalKey();
  String name1 = "Point";
  String name2 = "Time";
  TextInputType type = TextInputType.text;
  IconData icon1 = Icons.rocket_launch_rounded;
  IconData icon2 = Icons.timer_outlined;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 1.45,
          height: MediaQuery.of(context).size.height / 1.3,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Row(children: [
            Container(
              clipBehavior: Clip.antiAlias,
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 1.3,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25)),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.row.cells['First image']?.value != null
                    ? "${widget.row.cells['First image']?.value!}.jpeg"
                    : "",
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                  color: Colors.brown[900],
                )),
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  print(url);
                  return CachedNetworkImage(
                    imageUrl: widget.row.cells['Second image']?.value != null
                        ? "${widget.row.cells['Second image']?.value!}.jpeg"
                        : "",
                    placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                      color: Colors.brown[900],
                    )),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        "assets/errorimage.gif",
                        fit: BoxFit.cover,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You selected:\n",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[900],
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        'Leader name : ${widget.row.cells['Leader name']?.value}\n'
                        'Robot name :  ${widget.row.cells['Robot name']?.value}\n'
                        'Total Hmologation Point :  ${widget.row.cells['TotalHomPoint']?.value}\n'
                        '${[
                          "Line follower",
                          "Maze"
                        ].contains(widget.path) ? "Total Jury Point :  ${widget.row.cells['TotalJuryPoint']?.value}\n" : ""}',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.brown[800],
                            decoration: TextDecoration.none),
                      ),
                      if (["Line follower", "Maze"].contains(widget.path))
                        Card(
                          child: Container(
                              width: 350,
                              child: CustomField(
                                  txtKey: txtKey1,
                                  value: value1,
                                  name: name1,
                                  type: type,
                                  icon: icon1)),
                        ),
                      if (["Line follower", "Maze"].contains(widget.path))
                        const SizedBox(
                          height: 20,
                        ),
                      if (["Line follower", "Maze"].contains(widget.path))
                        Card(
                          child: Container(
                              width: 350,
                              child: CustomField(
                                  txtKey: txtKey2,
                                  value: value2,
                                  name: name2,
                                  type: type,
                                  icon: icon2)),
                        ),
                      if (["Line follower", "Maze"].contains(widget.path))
                        const SizedBox(
                          height: 20,
                        ),
                      if (["Line follower", "Maze"].contains(widget.path))
                        SegmentedButton(
                          segments: <ButtonSegment<bool>>[
                            ButtonSegment(
                                value: true,
                                label: Text(
                                  "Descalifier",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.brown[800],
                                      decoration: TextDecoration.none),
                                )),
                            ButtonSegment(
                                value: false,
                                label: Text(
                                  "Califier",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.brown[800],
                                      decoration: TextDecoration.none),
                                )),
                          ],
                          selected: descalifier,
                          onSelectionChanged: (v) {
                            setState(() {
                              descalifier = v;
                            });
                          },
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Canceled"),
                              ));
                            },
                            minWidth: 130,
                            color: buttonColor,
                            padding: const EdgeInsets.all(padding),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(buttonRadius),
                            ),
                            child: const Text(
                              "Restart",
                              style: TextStyle(
                                  color: Colors.white, fontSize: labelSize),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              DocumentReference<Map<String, dynamic>> up =
                                  await FirebaseFirestore.instance
                                      .collection(widget.path)
                                      .doc(widget.row.cells['ID']?.value);
                              if (["Line follower", "Maze"]
                                  .contains(widget.path)) {
                                int k =
                                    widget.row.cells['TotalJuryPoint']?.value;
                                if (value1.text != "" && value1.text != "-") {
                                  k += int.parse(value1.text);
                                }
                                up.update({
                                  "Trial": widget.num + 1,
                                  "TotalJuryPoint": k,
                                  "Trial ${widget.num}": {
                                    "Descalifier ${widget.num}":
                                        descalifier.last,
                                    "Point ${widget.num}":
                                        value1.text != "" ? value1.text : "-",
                                    "Time ${widget.num}":
                                        value2.text != "" ? value2.text : "-"
                                  },
                                });
                                widget.row.cells['TotalJuryPoint']?.value = k;
                              } else {
                                up.update({"Round": widget.num + 1});
                              }
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("Data saved successfully"),
                              ));
                            },
                            style: ButtonStyle(
                                fixedSize: const WidgetStatePropertyAll(
                                    Size.fromWidth(130)),
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
                      )
                    ]),
              ),
            ),
          ])),
    );
  }
}
