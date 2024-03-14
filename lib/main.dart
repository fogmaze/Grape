import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'fileSync.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIp().then((value) => print("ip: $value"));
  startServer().then((value) => print("server started"));
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
                                  onChanged: handleChangeLimitInput,
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
                      ]
                    ),
                  )
                ),

            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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
    var dbPath = dbDir!.path + '/my_db.db';
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      return db.execute('CREATE TABLE my_table (id INTEGER PRIMARY KEY, name TEXT)');
    });
  } else {
    throw 'Unsupported platform';
  }
  return null;
}

class CollectParameters {
  String limit = "0";
  bool loadPrevious = false;
  TestingElement? element;
  String getLimit() {
    // TODO implement this
    return limit;
  }
}

abstract class TestingElement {
  String methodName = "AbstractTestingElementState";
  int time = 0;
  GestureDetector? detector;
  List<TestingElement> relatedElements = [];

  void resetWidget();
  Widget getWidget();
}

class DefaultTestingElement extends TestingElement {
  var idx = 0;
  DefaultTestingElement({this.idx = 0, bool isMain=true}) {
    if (isMain) {
      relatedElements = [
        DefaultTestingElement(idx: 1, isMain: false,),
        DefaultTestingElement(idx: 2, isMain: false,)
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
  TestingElement element = DefaultTestingElement();
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
    relatedSingleTestingArea.updateElement(
        testingElements[nowTestingElementIdx].relatedElements[0]);
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

CollectParameters collectParameters = CollectParameters();
var nowTestingElementIdx = 0;
List<TestingElement> testingElements = [DefaultTestingElement(idx: 8,), DefaultTestingElement(idx: 9,), DefaultTestingElement(idx: 22,)];
