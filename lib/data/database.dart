import 'package:hive/hive.dart';
import 'package:calculator_app/utils/calculator.dart';

class CalculatorHistory {
  final _mybox = Hive.box('calculatorHistory');

  List history = [
    // This will store the history of calculations
  ];
  void createInitialData() {
    history = [];
    updateData();
  }

  // Method to load data from Hive box
  void loadData() {
    history = _mybox.get('HISTORY') ?? [];
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
