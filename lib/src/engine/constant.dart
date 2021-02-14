class SingleRollScenario {
  const SingleRollScenario();

  // _singleRollScenarioWithTanksLostChances[scenario][tanks_lost] = chance
  static const List<List<double>> _singleRollScenarioWithTanksLostChances = [
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

  double getWinChance({int scenario, int tanksLost}) {
    return _singleRollScenarioWithTanksLostChances[scenario][tanksLost];
  }

  bool test() {
    for (var row in _singleRollScenarioWithTanksLostChances) {
      if (sum(row) != 1) {
        return false;
      }
    }
    return true;
  }

  double sum(List<double> row) {
    var rowSum = 0.0;
    for (var element in row) {
      rowSum += element;
    }
    return rowSum;
  }
}
