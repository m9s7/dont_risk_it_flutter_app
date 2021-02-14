import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text("Your chances to win"),
                Text("56.3%"),
                //TODO: tank if sur = 1
                Text("Your chances to win with 10 tanks left"),
                Text("56.3%"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("45"),
                Text("vs"),
                Text("23"),
              ],
            ),
            Column(
              children: [
                Text("Update your chances!"),
                Text("How many tanks did you lose on this dice roll?"),
                ButtonBar(
                  buttonPadding: EdgeInsets.all(0.0),
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("0")),
                    ElevatedButton(onPressed: () {}, child: Text("1")),
                    ElevatedButton(onPressed: () {}, child: Text("2")),
                    ElevatedButton(onPressed: () {}, child: Text("3")),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Reset"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
