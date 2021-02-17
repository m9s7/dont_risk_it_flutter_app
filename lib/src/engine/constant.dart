import 'dart:math' show min;

class SingleRoll {
  /*
    Table holds the probability that in a given single roll scenario (1v1, 1v2, 2v1.. 3v3) you lose 0, 1, 2 or 3 tanks 
    USAGE: _singleRoll[scenario][tanks_lost] = probability
  */
  static const List<List<double>> _singleRoll = [
    [
      15.0 / 36,
      21.0 / 36,
    ], // 1v1
    [
      125.0 / 216,
      91.0 / 216,
    ], // 2v1
    [
      855.0 / 1296,
      441.0 / 1296,
    ], // 3v1
    [
      55.0 / 216,
      161.0 / 216,
    ], // 1v2
    [
      225.0 / 1296,
      1071.0 / 1296,
    ], // 1v3
    [
      295.0 / 1296,
      420.0 / 1296,
      581.0 / 1296,
    ], // 2v2
    [
      2890.0 / 7776,
      2611.0 / 7776,
      2275.0 / 7776,
    ], // 3v2
    [
      979.0 / 7776,
      1981.0 / 7776,
      4816.0 / 7776,
    ], // 2v3
    [
      6420.0 / 46656,
      10017.0 / 46656,
      12348.0 / 46656,
      17871.0 / 46656,
    ] // 3v3
  ];

  static double getWinChance({int scenario, int tanksLost}) {
    return _singleRoll[scenario][tanksLost];
  }

  static int getScenario(int numOfAtkDice, int numOfDefDice) {
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

  static int getNumOfAtkDice(int atk, int sur) {
    if (atk < 2) return 0;

    if (sur >= 4) return 3;

    if (sur == 3 && atk == 3) return 2;
    if (sur == 3 && atk > 3) return 3;

    if (sur == 2 && atk == 2) return 1;
    if (sur == 2 && atk == 3) return 2;
    if (sur == 2 && atk >= 4) return 3;

    if (sur == 1 && atk == 2) return 1;
    if (sur == 1 && atk == 3) return 2;
    if (sur == 1 && atk >= 4) return 3;

    throw Exception('_numberOfAtkDice gone wrong \n atk: $atk \n sur: $sur');
  }

  static int getNumOfDefDice(int def) {
    /*
      It's assumed you always defend with maximum number of dice possible
    */
    if (def >= 3) return 3;
    return def;
  }

  static int getMaxAtkTanksToDiePerRollToMaintainSur(int atk, int sur) {
    if (atk - sur >= 3) {
      return 3;
    } else {
      return atk - sur;
    }
  }

  static int getNumOfTotalTanksToBeLostInOneDiceRoll(
    int numOfAtkDice,
    int numOfDefDice,
  ) {
    if (numOfAtkDice >= 3 && numOfDefDice >= 3) {
      return 3;
    } else {
      return min(numOfAtkDice, numOfDefDice);
    }
  }

  bool test() {
    for (var row in _singleRoll)
      if (row.fold(0, (prev, curr) => prev + curr) != 1) return false;
    return true;
  }
}
