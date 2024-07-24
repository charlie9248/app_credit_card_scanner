import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle? style;

  const BodyText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}