// import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:hive/hive.dart';
import 'package:calculator_app/data/database.dart';

final _mybox = Hive.box('calculatorHistory');
final List<String> history = [];
CalculatorHistory db = CalculatorHistory();

bool isOperator(String x) {
  return ['+', '-', 'x', '/', '%'].contains(x);
}

bool isDecimalAllowed(String userInput) {
  final parts = userInput.split(RegExp(r'[+\-x/%]'));
  return parts.isEmpty || !parts.last.contains('.');
}

String calculateResult(String userInput) {
  try {
    String expression = userInput.replaceAll('x', '*');
    Parser p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    String result = eval.toString();
    if (result.endsWith('.0')) {
      result = result.replaceAll('.0', '');
    }
    // Add the calculation to history
    String entry = '$userInput = $result';
    db.addToHistory(entry);

    return result;
  } catch (e) {
    return 'Error';
  }
}
