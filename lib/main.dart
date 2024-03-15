import 'dart:developer';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'fileSync.dart';
import 'Methods.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //getIp().then((value) => print("ip: $value"));
  //startServer().then((value) => print("server started"));
  collectParameters.handleLimitInput("1|2|3&4|5|6");
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
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                mainTestArea.getWidget(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Method: "),
                            DropdownButton<String>(
                              value: collectParameters.method,
                              onChanged: (String? newValue) {
                                setState(() {
                                  collectParameters.method = newValue!;
                                });
                              },
                              items: <String>['EnVocDef', 'EnVocSpe', 'EnVocDefSpe', 'EnVocDefSpeVoc']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        // button to reget the testing elements
                        ElevatedButton(
                          onPressed: () {
                            reGet();
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
            Fluttertoast.showToast(
                msg: "Server started",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
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
  if (Platform.isAndroid) {
    var dirs = await getExternalStorageDirectories();
    print('dirs: $dirs');
    var dbDir = await getExternalStorageDirectory();
    var dbPath = dbDir!.path + '/highSchool.db';
    return openDatabase(dbPath, version: 1, );
  } else {
    throw 'Unsupported platform';
  }
  return null;
}

class CollectParameters {
  String limit = "0";
  String limitCode = "";
  bool loadPrevious = false;
  String method = "EnVocDef";
  String getLimit() {
    // TODO implement this
    return limit;
  }
  void handleLimitInput(String value) {
    limit = value;
    String ret = '(';
    value.split("|").forEach((element) {
      element.split("&").forEach((element) {
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
  TestingElement({required this.time}) {
    openDB().then((db) {
      db!.rawQuery('SELECT que,ans FROM en_voc WHERE time=$time').then((List<Map<String, dynamic>> result) {
        ans = result[0]['ans'];
        que = result[0]['que'];
        getRelatedTestingElements(this).then((value) => relatedElements = value);
        db.close();
      });
    });
  }
  abstract String methodName;
  GestureDetector? detector;
  List<TestingElement>? relatedElements;

  void resetWidget();
  Widget getWidget();
}

class DefaultTestingElement extends TestingElement {
  String methodName = "Default";
  var idx = 0;
  DefaultTestingElement({this.idx = 0, bool isMain=true, required super.time}) {
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
                      onPressed: () => {},
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
                const Divider(),
                widget.element.getWidget(),
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
    else if (posTop + 0.75 > 1.0) {
      change2NextTestingElement();
    }
    posLeft = 0.1;
    posTop = 0.08;
  }
  Widget getWidget() => MainTestAreaWidget(mainTestArea: this);
}

class MainTestAreaWidget extends StatefulWidget {
  MainTestArea mainTestArea;
  MainTestAreaWidget({super.key, required this.mainTestArea});
  @override
  State<StatefulWidget> createState() => _MainTestAreaWidgetState();
}

class _MainTestAreaWidgetState extends State<MainTestAreaWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.mainTestArea.posLeft * MediaQuery.of(context).size.width,
      top: widget.mainTestArea.posTop * MediaQuery.of(context).size.height,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            widget.mainTestArea.handleDragUpdateGesture(details, context);
          });
        },
        onPanEnd: (details) {
          setState(() {
            widget.mainTestArea.handleDragEndGesture(details);
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
                  child: widget.mainTestArea.relatedSingleTestingArea.getWidget(),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.mainTestArea.mainSingleTestingArea.getWidget(),
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

Future<List<TestingElement>> getRelatedTestingElements(TestingElement element) async {
  Database? db = await openDB();
  List<TestingElement>? ret;
  if (db == null) {
    return [DefaultTestingElement(time: 0)];
  }
  List<Map<String, dynamic>> result;
  if (element.methodName.contains("Voc")) {
    result = await db.rawQuery("SELECT time FROM en_voc ORDER BY RANDOM() LIMIT 5");
    if (element.methodName.contains("Def")) {
      ret = result.map((e) => EnVocDef_TestingElement(time: e['time'])).toList();
    }
  }
  else {
    ret = [DefaultTestingElement(time: 0)];
  }

  db.close();
  if (ret == null) {
    return [DefaultTestingElement(time: 0)];
  }
  return ret;
}

void reGet() {

}

CollectParameters collectParameters = CollectParameters();
var nowTestingElementIdx = 0;
List<TestingElement> testingElements = [DefaultTestingElement(idx: 8, time: 0), DefaultTestingElement(time: 0), DefaultTestingElement(idx: 22, time: 0)];
bool isServerOn = false;
HttpServer? server;
Map<String, String> methodName2Table = {
  "EnVocDef": "en_voc",
  "EnVocSpe": "en_voc",
  "EnPrepDef": "en_prep",
  "EnPrepSpe": "en_prep",
};
