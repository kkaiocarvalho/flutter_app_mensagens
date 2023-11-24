import 'package:flutter/cupertino.dart';

class MyTextFormat extends StatelessWidget {
  final String message;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const MyTextFormat({super.key, required this.message, this.fontSize, this.fontWeight, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
      child: Text(
          message,
          style: TextStyle(color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          )
      ),
    );
  }
}