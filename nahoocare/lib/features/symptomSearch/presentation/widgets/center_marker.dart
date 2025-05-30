import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  final String imagePath;

  const CustomMarker({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(imagePath, width: 40, height: 40);
  }
}
