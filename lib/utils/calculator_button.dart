// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../utils/button_color.dart';
import '../data/database.dart';
import 'package:hive/hive.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final CalculatorHistory db;
  final void Function(BuildContext context, int index)? deleteFunction;

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
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Slidable(
                                          key: ValueKey(reverseIndex),
                                          endActionPane: ActionPane(
                                            motion: StretchMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  // Delete the item
                                                  if (reverseIndex >= 0 &&
                                                      reverseIndex <
                                                          db.history.length) {
                                                    db.history.removeAt(
                                                      reverseIndex,
                                                    );
                                                    db.updateData();
                                                    // Update the modal state immediately
                                                    setModalState(() {});
                                                  }
                                                }, // Refresh modal
                                                icon: Icons.delete,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                backgroundColor: Colors.red,
                                                label: 'Delete',
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              db.history[reverseIndex],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
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
