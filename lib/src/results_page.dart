import 'package:Dont_risk_it_flutter_app/src/engine/engine.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ResultsPage extends StatefulWidget {
  final int atk, def, sur;
  const ResultsPage({Key key, this.atk, this.def, this.sur}) : super(key: key);
  final int decimalPoint = 2;

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

// Yeah, I don't like this

class _ResultsPageState extends State<ResultsPage> {
  static const double minExtent = 0.38;
  static const double maxExtent = 1;

  bool isExpanded = false;
  double initialExtent = minExtent;
  BuildContext draggableSheetContext;
  String endGameText = "Game over, you won!";

  ClassicEngine standardEngine;
  ClassicEngine tanksLeftEngine;

  int atk, def;
  double winChance, winChanceWithSur;

  int maxTanksToDieInDiceRoll;
  int maxTanksToDieInDiceRollWithSur;

  @override
  void initState() {
    super.initState();

    atk = widget.atk;
    def = widget.def;

    if (widget.sur == 1) {
      standardEngine = ClassicEngine(atk: atk, def: def, sur: 1);
      tanksLeftEngine = standardEngine;
    } else {
      standardEngine = ClassicEngine(atk: atk, def: def, sur: 1);
      tanksLeftEngine = ClassicEngine(atk: atk, def: def, sur: widget.sur);
    }

    winChance = standardEngine.getResult();
    winChanceWithSur = tanksLeftEngine.getResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.undo_rounded),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(),
      body: Center(
        child: Container(
          child: Stack(
            children: [
              Positioned(
                left: 0.0,
                right: 0.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 10.0),
                    _getText("Your chances to win"),
                    _getNumberText(
                        winChance.toStringAsFixed(widget.decimalPoint) + "%"),
                    SizedBox(height: 20.0),
                    _getText("Your chances to win with ${widget.sur} left"),
                    _getNumberText(
                        winChanceWithSur.toStringAsFixed(widget.decimalPoint) +
                            "%"),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              DraggableScrollableActuator(
                child: DraggableScrollableSheet(
                  key: Key(initialExtent.toString()),
                  minChildSize: minExtent,
                  maxChildSize: maxExtent,
                  initialChildSize: initialExtent,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    draggableSheetContext = context;
                    return SingleChildScrollView(
                      controller: scrollController,
                      physics: NeverScrollableScrollPhysics(),
                      child: Container(
                        decoration: new BoxDecoration(
                            color: Colors.cyan[100],
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(40.0),
                                topRight: const Radius.circular(40.0))),
                        margin: EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0.0),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _getNumberText("$atk"),
                                _getNumberText("vs"),
                                _getNumberText("$def"),
                              ],
                            ),
                            Text("Update your chances!"),
                            Text(
                                "How many tanks did you lose on this dice roll?"),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.5),
                              child: ButtonBar(
                                buttonPadding: EdgeInsets.all(0.0),
                                alignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: standardEngine.isValidUpdate(0)
                                          ? () => btnUpdateFunction(0)
                                          : null,
                                      child: Text("0")),
                                  ElevatedButton(
                                      onPressed: standardEngine.isValidUpdate(1)
                                          ? () => btnUpdateFunction(1)
                                          : null,
                                      child: Text("1")),
                                  ElevatedButton(
                                      onPressed: standardEngine.isValidUpdate(2)
                                          ? () => btnUpdateFunction(2)
                                          : null,
                                      child: Text("2")),
                                  ElevatedButton(
                                      onPressed: standardEngine.isValidUpdate(3)
                                          ? () => btnUpdateFunction(3)
                                          : null,
                                      child: Text("3")),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Reset"),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 4,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height,
                              child: _getText(endGameText),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  void updateDisplayValues() {
    setState(() {
      atk = standardEngine.getAtk();
      def = standardEngine.getDef();
      winChance = standardEngine.getResult();
      winChanceWithSur = tanksLeftEngine.getResult();
      if (atk == 1) {
        endGameText = "Game over, you lose.";
        _toggleDraggableScrollableSheet();
      } else if (def == 0) {
        endGameText = "Game over, you won!";
        _toggleDraggableScrollableSheet();
      }
    });
  }

  void btnUpdateFunction(int btnVal) {
    standardEngine.updateValues(btnVal);
    tanksLeftEngine.updateValues(btnVal);
    updateDisplayValues();
  }

  void _toggleDraggableScrollableSheet() {
    if (draggableSheetContext != null) {
      setState(() {
        initialExtent = isExpanded ? minExtent : maxExtent;
        isExpanded = !isExpanded;
      });
      DraggableScrollableActuator.reset(draggableSheetContext);
    }
  }
}
