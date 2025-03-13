import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.0 * textScale),
      child: Row(
        children: [
          Icon(icon, size: 20 * textScale, color: Colors.blueAccent),
          SizedBox(width: 8 * textScale),
          Text(label + ': ',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14 * textScale)),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 14 * textScale)),
          ),
        ],
      ),
    );
  }
}