import 'package:calculator_app/utils/calculator.dart';
import 'package:calculator_app/utils/calculator_button.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:calculator_app/data/database.dart';
// import 'package:math_expressions/math_expressions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userInput = "";
  String previousInput = "";
  final _mybox = Hive.box('calculatorHistory');
  // List<String> history = [];
  CalculatorHistory db = CalculatorHistory();

  final List<String> buttons = [
    'AC',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    'calc',
    '0',
    '.',
    '=',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the database and load history
    // TODO: implement initState
    if (_mybox.get('HISTORY') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  void handleTap(String label) {
    setState(() {
      if (label == 'AC') {
        userInput = '';
      } else if (label == 'DEL') {
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
      } else if (label == '=') {
        if (userInput.isNotEmpty) {
          // Store the original expression
          String originalExpression = userInput;
          // Calculate the result
          String result = calculateResult(userInput);

          if (result != 'Error') {
            // Add to history with original expression and result
            db.addToHistory('$originalExpression = $result');
            // Update userInput with the result
            db.loadData();
            userInput = result;
          }
        }
      } else if (label == '.') {
        if (isDecimalAllowed(userInput)) {
          userInput += label;
        }
      } else if (isOperator(label)) {
        if (userInput.isNotEmpty &&
            !isOperator(userInput[userInput.length - 1])) {
          userInput += ' $label ';
        }
      } else {
        userInput += label;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Calculator'), elevation: 0),
      body: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.centerRight,
            child: Text(
              userInput,
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                final label = buttons[index];
                return CalculatorButton(
                  label: label,
                  onTap: () => handleTap(label),
                  db: db, // Pass the database instance instead of history list
                  deleteFunction: null, // Pass the delete function
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
