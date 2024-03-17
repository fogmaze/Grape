import 'dart:collection';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'fileSync.dart';
import 'Methods.dart';
import 'package:network_info_plus/network_info_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  openDB().then((db) {
    collectParameters.initFromDB(db!).then(
        (value) {
          db.close();
        }
    );
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: MyHomePage(title: "Yeah",),
    );
  }
}

MainTestArea mainTestArea = MainTestArea();

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  void handleChangeLimitInput(String value) {
    setState(() {
      // TODO implement this
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                print("nowTestingElementIdx: $nowTestingElementIdx");
              });
            },
              child: Text("$nowTestingElementIdx"), ),
          Positioned(
            left: mainTestArea.posLeft * MediaQuery.of(context).size.width,
            top: mainTestArea.posTop * MediaQuery.of(context).size.height,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  mainTestArea.handleDragUpdateGesture(details, context);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  mainTestArea.handleDragEndGesture(details);
                });
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.75,
                  child: Column(
                    children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.018),
                      child: mainTestArea.relatedSingleTestingArea.getWidget(),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:mainTestArea.mainSingleTestingArea.getWidget(),
                    ),
                    ],
                  )
                )
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Expandable( // parameter setter
                  firstChild: Text(collectParameters.getLimit()),
                  subChild: const Text("change parameters"),
                  secondChild: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Limit: "),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 300,
                                child: TextField(
                                  onSubmitted: (String value) {
                                    setState(() {
                                      collectParameters.handleLimitInput(value);
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter new limit',
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Load previous: "),
                            Switch(
                              value: collectParameters.loadPrevious,
                              onChanged: (bool value) {
                                setState(() {
                                  collectParameters.loadPrevious = value;
                                });
                              },
                            ),
                        ]),
                        const Text("Method: "),
                        CheckboxListTile(
                          title: const Text("en_voc_def"),
                          value: collectParameters.methods.contains("en_voc_def"),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                collectParameters.methods.add("en_voc_def");
                              } else {
                                collectParameters.methods.remove("en_voc_def");
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("en_voc_spe"),
                          value: collectParameters.methods.contains("en_voc_spe"),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                collectParameters.methods.add("en_voc_spe");
                              } else {
                                collectParameters.methods.remove("en_voc_spe");
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("en_prep_def"),
                          value: collectParameters.methods.contains("en_prep_def"),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                collectParameters.methods.add("en_prep_def");
                              } else {
                                collectParameters.methods.remove("en_prep_def");
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("en_prep_spe"),
                          value: collectParameters.methods.contains("en_prep_spe"),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                collectParameters.methods.add("en_prep_spe");
                              } else {
                                collectParameters.methods.remove("en_prep_spe");
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("notes"),
                          value: collectParameters.methods.contains("notes"),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                collectParameters.methods.add("notes");
                              } else {
                                collectParameters.methods.remove("notes");
                              }
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              openDB().then((db) {
                                collectParameters.save2DB(db!).then(
                                    (value) {
                                      initLoading(db).then(
                                          (value) {
                                            nowId = value;
                                            print("nowId: $nowId");
                                            db.close();
                                          }
                                      );
                                    }
                                );
                              });
                            });
                          },
                          child: const Text("Reget"),
                        ),
                      ]
                    ),
                  )
                ),
            ]),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isServerOn = !isServerOn;
          if (isServerOn) {
            var wifiInfo = NetworkInfo();
            wifiInfo.getWifiIP().then((value) {
              Fluttertoast.showToast(
                  msg: "Server started at $value:8765",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            });
            startServer().then((value) {
              print("server started");
              server = value;
            });
          } else {
            Fluttertoast.showToast(
                msg: "Server stopped",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
            stopServer(server!).then((value) => print("server stopped"));
          }

        },
        tooltip: 'Increment',
        child: const Icon(Icons.accessible_forward),
      ),
    );
  }
}

Future<void> ckeckPermission() async {
  print('ckeckPermission() called');
  var status = await Permission.storage.status;
  print('status');
  if (status.isGranted) {
    print('Permission is granted');
  }
}

Future<Database?> openDB() async {
  var dbDir = await getApplicationDocumentsDirectory();
  var dbPath = '${dbDir.path}/highSchool.db';
  return await openDatabase(dbPath, version: 1, );
}

class CollectParameters {
  Future<void> initFromDB(Database db) async{
    print("initFromDB() called");
    List<Map<String, dynamic>> res = await db.rawQuery('SELECT * FROM settings');
    if (res.isNotEmpty) {
      limit = res[0]['te_tags'];
      handleLimitInput(limit);
      loadPrevious = res[0]['to_lp'] == 1;
      methods = res[0]['te_methods'].split("|");
      methods.sort();
      minLevel = res[0]['te_level'];
    }
  }
  Future<void> save2DB(Database db) async{
    await db.rawUpdate("UPDATE settings SET te_tags=?, te_lp=?, te_methods=?, te_level=?", [limit, loadPrevious?1:0, methods.join("|"), minLevel]);
  }
  int minLevel = -1;
  String limit = "0";
  String limitCode = "";
  bool loadPrevious = false;
  List<String> methods = [];
  String getLimit() {
    // TODO implement this
    return limit;
  }

  List<dynamic> sorted(List list) {
    list.sort();
    return list;
  }
  void handleLimitInput(String value) {
    limit = value;
    String ret = '(';
    sorted(value.split("|")).forEach((element) {
      sorted(element.split("&")).forEach((element) {
        ret += 'tags like "%|$element|%" and ';
      });
      ret = ret.substring(0, ret.length - 4);
      ret += ') or (';
    });
    ret = ret.substring(0, ret.length - 5);
    limitCode = ret;
    print("decode result: $limit");
  }
}

abstract class TestingElement {
  int time;
  String que = "";
  String ans = "";
  TestingElement({required this.time});
  void regetRelatedTestingElements(Database db) async {
    relatedElements = await getRelatedTestingElements(this, db);
  }

  Future<void> getQueAndAns(String tableName, Database db) async {
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT que,ans FROM $tableName WHERE time=$time');
    if (result.isNotEmpty) {
      ans = result[0]['ans'];
      que = result[0]['que'];
    }
  }
  abstract String methodName;
  GestureDetector? detector;
  List<TestingElement>? relatedElements;

  Future<void> init(Database db) async {}

  void resetWidget();
  void expandAll();
  Widget getWidget();
}

class DefaultTestingElement extends TestingElement {
  String methodName = "Default";
  var idx = 0;
  DefaultTestingElement({this.idx = 0, bool isMain=true, required super.time}){
    if (isMain) {
      relatedElements = [
        DefaultTestingElement(idx: 1, isMain: false, time: 0,),
        DefaultTestingElement(idx: 2, isMain: false, time: 0)
      ];
    }
  }
  @override
  Widget getWidget() {
    return DefaultTestingElementWidget(idx: idx);
  }

  @override
  void resetWidget() {
    // TODO: implement resetWidget
  }

  @override
  void expandAll() {
    // TODO: implement expandAll
  }
}

class DefaultTestingElementWidget extends StatefulWidget {
  DefaultTestingElementWidget({super.key, this.idx = 0});
  final int idx;
  @override
  State<StatefulWidget> createState() => _DefaultTestingElementWidgetState();
}

class _DefaultTestingElementWidgetState extends State<DefaultTestingElementWidget> {
  @override
  Widget build(BuildContext context) {
    return Text("DefaultTestingElement${widget.idx}");
  }
}

class SingleTestingArea {
  SingleTestingArea();
  TestingElement element = DefaultTestingElement(time: 0);
  void updateElement(TestingElement element) {
    this.element = element;
  }
  Widget getWidget() => SingleTestingAreaWidget(element: element);
}

class SingleTestingAreaWidget extends StatefulWidget {
  SingleTestingAreaWidget({super.key, required this.element});
  final TestingElement element;
  @override
  State<StatefulWidget> createState() => _SingleTestingAreaWidgetState();
}

class _SingleTestingAreaWidgetState extends State<SingleTestingAreaWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.72,
          height: MediaQuery.of(context).size.height * 0.33,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row( // TODO implement tool
                  children: [
                    const Text("Single Testing Area"),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.element.expandAll();
                        });
                      },
                      icon: const Icon(Icons.lightbulb),
                    )
                  ],
                ),
                const Divider(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.22,
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: widget.element.getWidget()
                ),
              ],
            )
          )
        ),
      ),
    );
  }
}

class MainTestArea {
  SingleTestingArea relatedSingleTestingArea = SingleTestingArea();
  SingleTestingArea mainSingleTestingArea = SingleTestingArea();
  var posLeft = 0.1;
  var posTop = 0.08;

  void updateTestingElement() {
    print("nowTestingElementIdx: $nowTestingElementIdx");
    mainSingleTestingArea.updateElement(testingElements[nowTestingElementIdx]);
    if (testingElements[nowTestingElementIdx].relatedElements != null) {
      relatedSingleTestingArea.updateElement(testingElements[nowTestingElementIdx].relatedElements![0]);
    }
    relatedSingleTestingArea.updateElement(DefaultTestingElement(time: 0));
  }
  void handleDragUpdateGesture(DragUpdateDetails details, BuildContext context) {
    posLeft += details.delta.dx / MediaQuery.of(context).size.width;
    posTop += details.delta.dy / MediaQuery.of(context).size.height;
  }
  void handleDragEndGesture(DragEndDetails details) {
    if (posLeft < 0.0) {
      takeNote();
      change2NextTestingElement();
    }
    else if (posTop > 0.1) {
      change2NextTestingElement();
    }
    posLeft = 0.1;
    posTop = 0.08;
  }
  Widget getWidget() => const MainTestAreaWidget();
}

class MainTestAreaWidget extends StatefulWidget {
  const MainTestAreaWidget({super.key});
  @override
  State<StatefulWidget> createState() => _MainTestAreaWidgetState();
}

class TextTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TextTestState();
}

class _TextTestState extends State<TextTest> {
  @override
  Widget build(BuildContext context) {
    print("TextTest build called");
    return const Text("TextTest");
  }
}

class _MainTestAreaWidgetState extends State<MainTestAreaWidget> {
  @override
  void didUpdateWidget(covariant MainTestAreaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("MainTestAreaWidget didUpdateWidget called");
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: mainTestArea.posLeft * MediaQuery.of(context).size.width,
      top: mainTestArea.posTop * MediaQuery.of(context).size.height,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            mainTestArea.handleDragUpdateGesture(details, context);
          });
        },
        onPanEnd: (details) {
          setState(() {
            mainTestArea.handleDragEndGesture(details);
          });
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.018),
                  child: mainTestArea.relatedSingleTestingArea.getWidget(),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:mainTestArea.mainSingleTestingArea.getWidget(),
                ),
              ],
            )
          )
        ),
      ),
    );
  }
}

void takeNote() {
  print("takeNote() called");
}

Future<void> saveRemain2DB(Database db) async {
  await db.rawInsert("DELETE FROM record_data WHERE id=$nowId");
  for (var e in testingElements.sublist(nowTestingElementIdx)) {
    await db.rawInsert("INSERT INTO record_data (id, method_name, time) VALUES (?, ?, ?)", [nowId, e.methodName, e.time]);
  }
}

void change2NextTestingElement() {
  if (nowTestingElementIdx < testingElements.length - 1) {
    nowTestingElementIdx++;
  } else {
    // shuffle the testing List
    testingElements.shuffle(Random());
    nowTestingElementIdx = 0;
  }
  mainTestArea.updateTestingElement();
}

Future<List<TestingElement>> getRelatedTestingElements(TestingElement element, Database db) async {
  List<TestingElement>? ret;
  List<Map<String, dynamic>> result;
  if (element.methodName.contains("voc")) {
    result = await db.rawQuery("SELECT time FROM en_voc ORDER BY RANDOM() LIMIT 5");
    if (element.methodName.contains("def")) {
      ret = result.map((e) => EnVocDef_TestingElement(time: e['time'])).toList();
    }
  }
  else {
    ret = [DefaultTestingElement(time: 0)];
  }
  if (ret == null) {
    return [DefaultTestingElement(time: 0)];
  }
  for (var e in ret) {
    await e.init(db);
  }
  return ret;
}

Future<int> initLoading(Database db) async {
  List<Map<String, dynamic>> matchedId = await db.rawQuery('SELECT id from record_list WHERE method_names="${collectParameters.methods.join("|")}" AND tags="${collectParameters.limit}"');
  if (matchedId.isEmpty) {
    await reGet(db);
    await db.rawInsert("INSERT INTO record_list (method_names, tags) VALUES (?, ?)", [collectParameters.methods.join("|"), collectParameters.limit]);
    int? id = (await db.rawQuery('SELECT id from record_list WHERE method_names="${collectParameters.methods.join("|")}" AND tags="${collectParameters.limit}"'))[0]['id'] as int?;
    return id!;
  }
  else {
    int id = matchedId[0]['id'];
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT time,method_name FROM record_data WHERE id=$id');
    List<TestingElement> notTested = [];
    List<TestingElement> tested = [];
    for (var e in result) {
      notTested.add(await getTestingElementFromMethodTime(e['method_name'], e['time'], db));
    }
    for (var method in collectParameters.methods) {
      print("method: $method");
      List<Map<String, dynamic>> notTestedResult = await db.rawQuery('SELECT time FROM ${methodName2Table[method]} WHERE ${collectParameters.limitCode} AND time NOT IN (SELECT time FROM record_data WHERE id=$id) ORDER BY RANDOM()');
      for (var e in notTestedResult) {
        tested.add(await getTestingElementFromMethodTime(method, e['time'], db));
      }
    }
    testingElements = tested + notTested;
    nowTestingElementIdx = tested.length;
    return id;
  }
}

Future<TestingElement> getTestingElementFromMethodTime(String method, int time, Database db) async{
  late TestingElement ret;
  if (method == "en_voc_def") {
    ret = EnVocDef_TestingElement(time: time);
  }
  else if (method == "en_voc_spe") {
    ret = EnVocSpe_TestingElement(time: time);
  }
  else if (method == "en_prep_def") {
    ret = EnPrepDef_TestingElement(time: time);
  }
  else if (method == "en_prep_spe") {
    ret = EnPrepSpe_TestingElement(time: time);
  }
  else if (method == "notes") {
    ret = Notes_TestingElement(time: time);
  }
  else {
    ret = DefaultTestingElement(time: time);
  }
  await ret.init(db);
  return ret;
}

Future<void> reGet(Database db) async{
  testingElements = [];
  for (var method in collectParameters.methods) {
    print("method: $method");
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT time FROM ${methodName2Table[method]} WHERE ${collectParameters.limitCode} ORDER BY RANDOM()');
    for (var e in result) {
      testingElements.add(await getTestingElementFromMethodTime(method, e['time'], db));
    }
  }
  testingElements.shuffle(Random());
  mainTestArea.updateTestingElement();
}

CollectParameters collectParameters = CollectParameters();
var nowTestingElementIdx = 0;
var nowId = 0;
List<TestingElement> testingElements = [DefaultTestingElement(idx: 8, time: 0), DefaultTestingElement(time: 0), DefaultTestingElement(idx: 22, time: 0)];
bool isServerOn = false;
HttpServer? server;
Map<String, String> methodName2Table = {
  "en_voc_def": "en_voc",
  "en_voc_spe": "en_voc",
  "en_prep_def": "en_prep",
  "en_prep_spe": "en_prep",
  "notes": "notes"
};