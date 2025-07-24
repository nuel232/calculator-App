import 'package:flutter/material.dart';

Color getButtonColor(String label) {
  if (label == 'AC' || label == 'DEL' || label == '%') {
    return Colors.grey[600]!;
  } else if (label == '/' ||
      label == 'x' ||
      label == '-' ||
      label == '+' ||
      label == '=') {
    return Colors.orange[300]!;
  } else {
    return Colors.grey[900]!;
  }
}

Color getTextColor(String label) {
  if (label == 'AC' || label == 'DEL') return Colors.white;
  return Colors.white;
}
