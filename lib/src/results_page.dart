import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  Widget _getText(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.5),
      child: AutoSizeText(
        text,
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }

  Widget _getNumberText(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: AutoSizeText(
        text,
        style: TextStyle(fontSize: 30),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 10.0),
                  _getText("Your chances to win"),
                  _getNumberText("56.3%"),
                  SizedBox(height: 20.0),
                  //TODO: tank if sur = 1
                  _getText("Your chances to win with 10 tanks left"),
                  _getNumberText("56.3%"),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            Container(
              decoration: new BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0))),
              margin: EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0.0),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _getNumberText("45"),
                      _getNumberText("vs"),
                      _getNumberText("23"),
                    ],
                  ),
                  _getText("Update your chances!"),
                  _getText("How many tanks did you lose on this dice roll?"),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.5),
                    child: ButtonBar(
                      buttonPadding: EdgeInsets.all(0.0),
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(onPressed: () {}, child: Text("0")),
                        ElevatedButton(onPressed: () {}, child: Text("1")),
                        ElevatedButton(onPressed: () {}, child: Text("2")),
                        ElevatedButton(onPressed: () {}, child: Text("3")),
                      ],
                    ),
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
            )
          ],
        ),
      ),
    );
  }
}
