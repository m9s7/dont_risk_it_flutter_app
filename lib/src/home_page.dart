import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController atkController;
  TextEditingController defController;
  TextEditingController surController;

  void initState() {
    super.initState();
    atkController = new TextEditingController(text: "");
    defController = new TextEditingController(text: "");
    surController = new TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Attack tanks: ',
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: atkController,
                ),
              ),
              Text(
                'Survivor tanks: ',
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: surController,
                ),
              ),
              Text(
                'Defence tanks: ',
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: defController,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print("atk: " +
                      getTextFieldValue(atkController, 2).toString() +
                      "\nsur: " +
                      getTextFieldValue(surController, 1).toString() +
                      "\ndef: " +
                      getTextFieldValue(defController, 1).toString() +
                      "\n");
                },
                child: Text("Action!"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getValidInputString(TextEditingController controller) {
    String input = controller.text;
    input = input.replaceFirst(RegExp(r"0*"), '');
    if (input.isEmpty) input = "0";
    return input;
  }

  int getTextFieldValue(TextEditingController controller, int inputMinimum) {
    int value = int.parse(getValidInputString(controller));
    if (value < inputMinimum) {
      controller
        ..text = inputMinimum.toString()
        ..selection = TextSelection.collapsed(offset: controller.text.length);
      return inputMinimum;
    }
    controller
      ..text = value.toString()
      ..selection = TextSelection.collapsed(offset: controller.text.length);
    return value;
  }
}
