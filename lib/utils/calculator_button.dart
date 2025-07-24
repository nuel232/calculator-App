// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import '../utils/button_color.dart';
import '../data/database.dart';
import 'package:hive/hive.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final _mybox = Hive.box('calculatorHistory');
  final List<String> history;

  // List<String> history = [];
  CalculatorButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == 'calc') {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 300,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Calculation History',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return ListTile(title: Text(history[index]));
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          onTap.call();
        }
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: getButtonColor(label),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: label == 'calc'
              ? Icon(Icons.calculate_outlined, color: Colors.white, size: 65)
              : Text(
                  label,
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
