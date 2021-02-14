import 'dart:math';
import 'package:Dont_risk_it_flutter_app/src/engine/constant.dart';

// void main() {
//   var engine1 = ClassicEngine(atk: 5, def: 3, tanksLeft: 2);

//   var res = engine1.getResult(2, 3);
//   engine1.writeOutAtkWinChanceTable();
//   print(res);
// }

/*
  Klasicna riziko pravila, old itallian classic?
*/

class ClassicEngine {
  final int atk;
  final int def;
  final int tanksLeft;

  int _maxRow;
  int _maxCol;

  final SingleRollScenario _singleRollChances = SingleRollScenario();

  // atkWinChanceTable table is the chance of atk winning against def with atleast tanksLeft remaining.
  // atkWinChanceTable[ATK-tanksLeft][DEF]
  List<List<double>> _atkWinChanceTable;

  ClassicEngine({this.atk, this.def, this.tanksLeft}) {
    _init();
  }

  void _init() {
    _maxRow = atk - tanksLeft + 1;
    _maxCol = def + 1;

    _atkWinChanceTable = List<List<double>>(_maxRow);
    for (var i = 0; i < _maxRow; i++) {
      _atkWinChanceTable[i] = List<double>.filled(_maxCol, 0);
    }

    _fillOutAtkWinChanceTable();
    writeOutAtkWinChanceTable();
    // print(_singleRollChances.test());
  }

  int _getNumOfDefDice(int def) {
    /*
      It's assumed you always defend with maximum number of dice possible
    */
    if (def >= 3) return 3;
    return def;
  }

  int _getNumOfAtkDice(int atk, int tanksLeft) {
    /*
      TanksLeft is always atleast one because if you lose, one tank has to stay to indicate it's still your territory
      The maximum that TanksLeft can be, is the number of tanks you have on the territory,
      that is the chance that you win without losing any tanks in the fight
    */
    if (atk < 2) return 0;

    if (tanksLeft >= 4) return 3;

    if (tanksLeft == 3 && atk == 3) return 2;
    if (tanksLeft == 3 && atk > 3) return 3;

    if (tanksLeft == 2 && atk == 2) return 1;
    if (tanksLeft == 2 && atk == 3) return 2;
    if (tanksLeft == 2 && atk >= 4) return 3;

    if (tanksLeft == 1 && atk == 2) return 1;
    if (tanksLeft == 1 && atk == 3) return 2;
    if (tanksLeft == 1 && atk >= 4) return 3;

    throw Exception('_numberOfAtkDice gone terribly wrong.');
  }

  int _getNumOfTotalTanksToBeLostInOneDiceRoll(
    int numOfAtkDice,
    int numOfDefDice,
  ) {
    if (numOfAtkDice >= 3 && numOfDefDice >= 3) {
      return 3;
    } else {
      return min(numOfAtkDice, numOfDefDice);
    }
  }

  int _getMaxNumOfAtkTanksToDiePerRollToMaintainTanksLeft(
    int atk,
    int tanksLeft,
  ) {
    if (atk - tanksLeft >= 3) {
      return 3;
    } else {
      return atk - tanksLeft;
    }
  }

  int _getScenario(int numOfAtkDice, int numOfDefDice) {
    if (numOfAtkDice == 1 && numOfDefDice == 1) {
      return 0;
    } else if (numOfAtkDice == 2 && numOfDefDice == 1) {
      return 1;
    } else if (numOfAtkDice == 3 && numOfDefDice == 1) {
      return 2;
    } else if (numOfAtkDice == 1 && numOfDefDice == 2) {
      return 3;
    } else if (numOfAtkDice == 1 && numOfDefDice == 3) {
      return 4;
    } else if (numOfAtkDice == 2 && numOfDefDice == 2) {
      return 5;
    } else if (numOfAtkDice == 3 && numOfDefDice == 2) {
      return 6;
    } else if (numOfAtkDice == 2 && numOfDefDice == 3) {
      return 7;
    } else if (numOfAtkDice == 3 && numOfDefDice == 3) return 8;

    throw Exception('_getScenario gone terribly wrong.');
  }

  void writeOutAtkWinChanceTable() {
    for (var oneRow in _atkWinChanceTable) {
      print(oneRow.toString());
    }
  }

  void _fillOutAtkWinChanceTable() {
    // Calling the algorithm that fills out the atkWinChanceTable

    // upisujemo 1 u nultu kolonu jer je tu uvek def = 0 pa je verovatnoca za pobedu 1 (100%)
    for (var i = 0; i < _maxRow; i++) {
      _atkWinChanceTable[i][0] = 1;
    }

    int numOfAtkDice;
    int numOfDefDice;
    int maxNumOfAtkTanksToDiePerRoll;
    int numOfTotalTanksToBeLostInOneDiceRoll;

    var d = 1;
    while (d < _maxCol) {
      for (var i = 0; i < _maxRow; i++) {
        /*
          Init all state values needed for this scenario
        */
        numOfAtkDice = _getNumOfAtkDice(i + tanksLeft, tanksLeft);
        if (numOfAtkDice == 0) {
          _atkWinChanceTable[i][d] = 0;
          continue;
        }

        numOfDefDice = _getNumOfDefDice(d);

        maxNumOfAtkTanksToDiePerRoll =
            _getMaxNumOfAtkTanksToDiePerRollToMaintainTanksLeft(
          i + tanksLeft,
          tanksLeft,
        );

        numOfTotalTanksToBeLostInOneDiceRoll =
            _getNumOfTotalTanksToBeLostInOneDiceRoll(
          numOfAtkDice,
          numOfDefDice,
        );

        /*
          Construct current table field based on previous ones and the constant probabilites of single roll outcomes that lead to the current one  
        */
        var n = min(
          maxNumOfAtkTanksToDiePerRoll,
          numOfTotalTanksToBeLostInOneDiceRoll,
        );

        for (var j = 0; j <= n; j++) {
          _atkWinChanceTable[i][d] += (_atkWinChanceTable[i - j]
                  [d - numOfTotalTanksToBeLostInOneDiceRoll + j] *
              _singleRollChances.getWinChance(
                scenario: _getScenario(numOfAtkDice, numOfDefDice),
                tanksLost: j,
              ));
        }
        /*
          On to the next one
        */
      }
      d++;
    }
  }

  double getResult(int atk, int def) {
    if (atk < tanksLeft) return 0.0;
    return _atkWinChanceTable[atk - tanksLeft][def] * 100;
  }
}
