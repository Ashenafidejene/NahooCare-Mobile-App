import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('History Page'.tr(), style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
