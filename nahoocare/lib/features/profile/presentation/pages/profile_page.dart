import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Profile Page'.tr(), style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
