import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expandable_widgets/expandable_widgets.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  mainTestArea.updateTestingElement();
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
        alignment: Alignment.topCenter,
        children: <Widget>[
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                collectParameters.limit = "sa";
                print("collectParameters.limit: ${collectParameters.limit}");
              });
            },
              child: mainTestArea
          ),
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

abstract class TestingElement extends StatefulWidget {
  String methodName = "AbstractTestingElementState";
  int time = 0;
  GestureDetector? detector;
  List<TestingElement> relatedElements = [];

  void reload();
  void resetWidget();
  TestingElement({super.key, });
}

class DefaultTestingElement extends TestingElement {
  var idx = 0;
  DefaultTestingElement({super.key, this.idx = 0, bool isMain=true}) {
    if (isMain) {
      relatedElements = [
        DefaultTestingElement(idx: 1, isMain: false,),
        DefaultTestingElement(idx: 2, isMain: false,)
      ];
    }
  }
  @override
  State<StatefulWidget> createState() => _DefaultTestingElementState();

  @override
  void reload() {
    // TODO: implement reload
  }

  @override
  void resetWidget() {
    // TODO: implement resetWidget
  }
}

class _DefaultTestingElementState extends State<DefaultTestingElement> {
  @override
  Widget build(BuildContext context) {
    return Text("DefaultTestingElement${widget.idx}");
  }
}

class SingleTestingArea extends StatefulWidget {
  SingleTestingArea({super.key});
  TestingElement element = DefaultTestingElement();
  void updateElement(TestingElement element) {
    this.element = element;
  }
  @override
  State<StatefulWidget> createState() => _SingleTestingAreaState();
}

class _SingleTestingAreaState extends State<SingleTestingArea> {
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
                widget.element,
              ],
            )
          )
        ),
      ),
    );
  }
}

class MainTestArea extends StatefulWidget {
  MainTestArea({super.key});
  SingleTestingArea relatedSingleTestingArea = SingleTestingArea();
  SingleTestingArea mainSingleTestingArea = SingleTestingArea();
  void updateTestingElement() {
    print("nowTestingElementIdx: $nowTestingElementIdx");
    mainSingleTestingArea.updateElement(testingElements[nowTestingElementIdx]);
    relatedSingleTestingArea.updateElement(testingElements[nowTestingElementIdx].relatedElements[0]);
  }

  @override
  State<StatefulWidget> createState() => _MainTestAreaState();
}

class _MainTestAreaState extends State<MainTestArea> {
  @override
  Widget build(BuildContext context) {

    return Center(
      child:
      GestureDetector(
        onTap: () {
          setState(() {
            change2NextTestingElement();
            collectParameters.limit = "se";
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    child: widget.relatedSingleTestingArea,
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.mainSingleTestingArea,
                  ),
                ],
              )
            )
          ),
        ),
      )
    );
  }
}

CollectParameters collectParameters = CollectParameters();

var nowTestingElementIdx = 0;
List<TestingElement> testingElements = [DefaultTestingElement(idx: 8,), DefaultTestingElement(idx: 9,), DefaultTestingElement(idx: 22,)];

void change2NextTestingElement() {
  if (nowTestingElementIdx < testingElements.length - 1) {
    nowTestingElementIdx++;
  } else {
    // shuffle the testing List
    testingElements.shuffle(Random());
    nowTestingElementIdx = 0;
  }
  mainTestArea.updateTestingElement();
  print("nowTestingElementIdx: $nowTestingElementIdx");
}

