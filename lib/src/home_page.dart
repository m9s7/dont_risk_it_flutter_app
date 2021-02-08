import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// That's it for now, things I plan to do
//  - make a background image of little tanks at 45 degrees with different soft colors
//  - wrap this bitch up in a stack but I think that will fuck up the keyboard interaction and what not, fucking flutter lots of work
//  - remove the app bar, add the sandwitch, clasic shit looks great
//  - fix the button to look better
//  - change the theme

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int atkVal;
  int defVal;
  int surVal;

  //TODO: maybe add instead of a submit button there is a -> to go to the next field in the form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              // child: Container(
              //HACK: I want my column to expand as much as it can
              // height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildAtkField(),
                  SizedBox(height: 30),
                  _buildSurField(),
                  SizedBox(height: 30),
                  _buildDefField(),
                  SizedBox(height: 100),
                  ElevatedButton(
                    child: Text("Action!"),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();
                      //TODO: send data to the next page
                      print("\n-------");
                      print(atkVal);
                      print(defVal);
                      print(surVal);
                      print(MediaQuery.of(context).size.height);
                      print("-------\n");
                    },
                  ),
                ],
              ),
            ),
            // ),
          ),
        ),
      ),
    );
  }

  // TODO: limit atk tanks number (maxLength: 3) or change the algorithm or add simulations (I don't even know how that's done)
  Widget _buildAtkField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: "Attack tanks",
      ),
      validator: (String value) {
        int intVal = int.tryParse(value);
        if (intVal == null) return 'Number of attack tanks is required';
        if (intVal < 2) return 'You must have at least 2 tanks to attack';
        return null;
      },
      onSaved: (String value) {
        atkVal = int.parse(value);
      },
    );
  }

  Widget _buildDefField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: "Defence tanks",
      ),
      validator: (String value) {
        int intVal = int.tryParse(value);
        if (intVal == null) return 'Number of defence tanks is required';
        if (intVal < 1) return 'You must have at least 1 tank to defend';
        return null;
      },
      onSaved: (String value) {
        defVal = int.parse(value);
      },
    );
  }

  // TODO: kad posaljes podatke ako je sur > atk samo stavi da je sansa za to 0, mozda to nekako proveriti ovde
  Widget _buildSurField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: "Tanks you would like to have left after the battle",
      ),
      validator: (String value) {
        int intVal = int.tryParse(value);
        if (intVal == null || intVal < 1)
          return 'You must have at least 1 tank after an attack';
        return null;
      },
      onSaved: (String value) {
        surVal = int.parse(value);
      },
    );
  }
}
