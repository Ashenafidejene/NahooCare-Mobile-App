import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FirstAidPage extends StatelessWidget {
  const FirstAidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text('First Aid Page'.tr())));
  }
}
