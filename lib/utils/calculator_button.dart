// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import '../utils/button_color.dart';
import '../data/database.dart';
import 'package:hive/hive.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final CalculatorHistory db;
  final Function(BuildContext context, int index)? deleteFunction;

  // List<String> history = [];
  CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.db,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == 'calc') {
          // Show the history in a modal bottom sheet
          db.loadData(); // Load the history from the database
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
                      child: db.history.isEmpty
                          ? Center(
                              child: Text(
                                'No calculations yet',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: db.history.length,
                              itemBuilder: (context, index) {
                                // Show most recent calculations first
                                int reverseIndex =
                                    db.history.length - 1 - index;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        db.history[reverseIndex],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () {
                                          db.history.removeAt(reverseIndex);
                                          db.updateData();
                                          Navigator.pop(
                                            context,
                                          ); // Close bottom sheet to reflect changes
                                        },
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                      ),
                                      child: const Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                );
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
