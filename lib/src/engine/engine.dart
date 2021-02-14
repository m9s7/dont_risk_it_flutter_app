import 'dart:math' show min;
import 'constant.dart';

// void main() {
//   var engineClassic = ClassicEngine(atk: 3, def: 1, sur: 1);
//   var engineWithSur = ClassicEngine(atk: 3, def: 1, sur: 3);

//   print('------start------');
//   engineClassic.writeOutAtkWinChanceTable();
//   print(engineClassic.getResult(3, 1));

//   engineWithSur.writeOutAtkWinChanceTable();
//   print(engineWithSur.getResult(3, 1));
//   print('-------end-------');
// }

/*
  Klasicna riziko pravila, old itallian classic?
*/

class ClassicEngine {
  /* 
    atk is the number of tanks on the territory that is attacking
    def is the number of tanks on the territory that is defending
    sur is the number of tanks that the attacker wishes to have after the attack
      the minimum number for it is 1 because win or lose 1 tank has to stay on the attacking territory
      if you are going to win it's acctualy 2, one tank to move to a new territory and one to stay on the old
  */
  final int atk;
  final int def;
  final int sur;

  int _maxRow;
  int _maxCol;

  // atkWinChanceTable table is the chance of atk winning against def with atleast sur remaining.
  // atkWinChanceTable[ATK-sur][DEF]
  List<List<double>> _atkWinChanceTable;

  ClassicEngine({this.atk, this.def, this.sur}) {
    _init();
  }

  void _init() {
    if (atk < sur) return;

    _maxRow = atk - sur + 1;
    _maxCol = def + 1;

    _atkWinChanceTable = List<List<double>>(_maxRow);
    for (var i = 0; i < _maxRow; i++) {
      _atkWinChanceTable[i] = List<double>.filled(_maxCol, 0);
    }

    _fillOutAtkWinChanceTable();
  }

  /*
    These are the variables that the algorithm uses, they will be updated every time we change the number of defenders
    Declared outside because I can't pass them by ref in dart and i want to because of readability
  */
  int numOfAtkDice;
  int numOfDefDice;
  int maxAtkTanksToDiePerRoll;
  int numOfTotalTanksToBeLostInOneDiceRoll;

  void _fillOutAtkWinChanceTable() {
    // At the first column the number of defenders is zero so the probability for atk to win is 1
    for (var i = 0; i < _maxRow; i++) {
      _atkWinChanceTable[i][0] = 1;
    }

    for (var currDef = 1; currDef < _maxCol; currDef++) {
      for (var currAtk = 0; currAtk < _maxRow; currAtk++) {
        // Update numOfAtkDice, numOfDefDice, maxAtkTanksToDiePerRoll, numOfTotalTanksToBeLostInOneDiceRoll
        updateAlgorithmVars(currAtk, currDef);

        // If the numOfAtkDice is 0 the atk can't win in this scenario
        if (numOfAtkDice == 0) {
          _atkWinChanceTable[currAtk][currDef] = 0;
          continue;
        }

        /*
          Construct current table field based on previous ones and the constant probabilites of single roll outcomes that lead to the current one  
        */
        var n = min(
          maxAtkTanksToDiePerRoll,
          numOfTotalTanksToBeLostInOneDiceRoll,
        );

        for (var j = 0; j <= n; j++) {
          _atkWinChanceTable[currAtk]
              [currDef] += (_atkWinChanceTable[currAtk - j]
                  [currDef - numOfTotalTanksToBeLostInOneDiceRoll + j] *
              SingleRoll.getWinChance(
                scenario: SingleRoll.getScenario(numOfAtkDice, numOfDefDice),
                tanksLost: j,
              ));
        }
      }
    }
  }

  /*
    Can't pass by reference in dart
  */
  void updateAlgorithmVars(int i, int d) {
    numOfAtkDice = SingleRoll.getNumOfAtkDice(i + sur, sur);

    numOfDefDice = SingleRoll.getNumOfDefDice(d);

    maxAtkTanksToDiePerRoll =
        SingleRoll.getMaxAtkTanksToDiePerRollToMaintainSur(
      i + sur,
      sur,
    );

    numOfTotalTanksToBeLostInOneDiceRoll =
        SingleRoll.getNumOfTotalTanksToBeLostInOneDiceRoll(
      numOfAtkDice,
      numOfDefDice,
    );
  }

  void writeOutAtkWinChanceTable() {
    for (var oneRow in _atkWinChanceTable) print(oneRow.toString());
  }

  double getResult(int atk, int def) {
    if (atk < sur) return 0.0;
    return _atkWinChanceTable[atk - sur][def] * 100;
  }
}
