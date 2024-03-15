import 'main.dart';
import 'package:flutter/material.dart';

class EnVocDef_TestingElement extends TestingElement {
  @override
  String methodName = "EnVocDef";
  bool isShow = false;
  EnVocDef_TestingElement({required super.time});
  @override
  Widget getWidget() {
    return EnVocDef_TestingElementWidget(element: this);
  }

  @override
  void resetWidget() {
    isShow = false;
  }
}

class EnVocDef_TestingElementWidget extends StatefulWidget {
  EnVocDef_TestingElement element;
  EnVocDef_TestingElementWidget({super.key, required this.element});
  @override
  EnVocDef_TestingElementWidgetState createState() => EnVocDef_TestingElementWidgetState();
}

class EnVocDef_TestingElementWidgetState extends State<EnVocDef_TestingElementWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Tap to see the definition"),
        const SizedBox(height: 20),
        Text(widget.element.que),
        const SizedBox(height: 20),
        if (widget.element.isShow) Text(widget.element.ans)
      ],
    );
  }
}

class EnVocSpe_TestingElement extends TestingElement {
  @override
  String methodName = "EnVocSpe";

  EnVocSpe_TestingElement({required super.time});

  @override
  Widget getWidget() {
    return EnVocSpe_TestingElementWidget(element: this);
  }

  @override
  void resetWidget() {
    // TODO: implement resetWidget
  }
}

class EnVocSpe_TestingElementWidget extends StatefulWidget {
  EnVocSpe_TestingElement element;
  EnVocSpe_TestingElementWidget({super.key, required this.element});
  @override
  EnVocSpe_TestingElementWidgetState createState() => EnVocSpe_TestingElementWidgetState();
}

class EnVocSpe_TestingElementWidgetState extends State<EnVocSpe_TestingElementWidget> {
  @override
  Widget build(BuildContext context) {
    return Text("EnVocSpe_TestingElementWidgetState");
  }
}

class EnPrepDef_TestingElement extends TestingElement {
  @override
  String methodName = "EnPrepDef";
  EnPrepDef_TestingElement({required super.time});

  @override
  Widget getWidget() {
    return EnPrepDef_TestingElementWidget(element: this);
  }

  @override
  void resetWidget() {
    // TODO: implement resetWidget
  }
}

class EnPrepDef_TestingElementWidget extends StatefulWidget {
  EnPrepDef_TestingElement element;
  EnPrepDef_TestingElementWidget({super.key, required this.element});
  @override
  EnPrepDef_TestingElementWidgetState createState() => EnPrepDef_TestingElementWidgetState();
}

class EnPrepDef_TestingElementWidgetState extends State<EnPrepDef_TestingElementWidget> {
  @override
  Widget build(BuildContext context) {
    return Text("EnPrepDef_TestingElementWidgetState");
  }
}

class EnPrepSpe_TestingElement extends TestingElement {
  EnPrepSpe_TestingElement({required super.time});
  @override
  String methodName = "EnPrepSpe";

  @override
  Widget getWidget() {
    return EnPrepSpe_TestingElementWidget(element: this);
  }

  @override
  void resetWidget() {
    // TODO: implement resetWidget
  }
}

class EnPrepSpe_TestingElementWidget extends StatefulWidget {
  EnPrepSpe_TestingElement element;
  EnPrepSpe_TestingElementWidget({super.key, required this.element});
  @override
  EnPrepSpe_TestingElementWidgetState createState() => EnPrepSpe_TestingElementWidgetState();
}

class EnPrepSpe_TestingElementWidgetState extends State<EnPrepSpe_TestingElementWidget> {
  @override
  Widget build(BuildContext context) {
    return Text("EnPrepSpe_TestingElementWidgetState");
  }
}

