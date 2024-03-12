import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expandable_widgets/expandable_widgets.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  MainTestArea mainTestArea = MainTestArea();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectParameters collectParameters = CollectParameters();

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
          widget.mainTestArea,
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
    log('dbPath: $dbPath');
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
    return const Text("DefaultTestingElement");
  }
}

class SingleTestingArea extends StatefulWidget {
  SingleTestingArea({super.key});
  TestingElement element = DefaultTestingElement();
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
          width: MediaQuery.of(context).size.width * 0.7,
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

  @override
  State<StatefulWidget> createState() => _MainTestAreaState();
}

class _MainTestAreaState extends State<MainTestArea> {
  @override
  Widget build(BuildContext context) {

    return Center(
      child:
      Padding(
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
                  padding: const EdgeInsets.all(8.0),
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
      )
    );
  }
}