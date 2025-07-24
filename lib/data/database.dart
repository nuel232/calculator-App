import 'package:hive/hive.dart';

class CalculatorHistory {
  final _mybox = Hive.box('calculatorHistory');

  List<String> history = [
    // This will store the history of calculations
  ];
  void createInitialData() {
    history = [];
    updateData();
  }

  // Method to load data from Hive box
  void loadData() {
    var data = _mybox.get('HISTORY');
    if (data != null) {
      history = List<String>.from(data);
    } else {
      history = [];
    }
  }

  // Method to update the Hive box with the current history
  void updateData() {
    _mybox.put('HISTORY', history);
  }

  void addToHistory(String entry) {
    history.add(entry);
    updateData();
  }

  // Method to save user input to history
}
