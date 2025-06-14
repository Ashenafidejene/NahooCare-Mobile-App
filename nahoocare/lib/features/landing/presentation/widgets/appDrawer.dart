import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.teal),
            child: Text(
              'Nahoocare Menu'.tr(),
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text('History'.tr()),
            onTap: () {}, // Add functionality
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text('Account'.tr()),
            onTap: () {}, // Add functionality
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('Logout'.tr()),
            onTap: () {}, // Add functionality
          ),
        ],
      ),
    );
  }
}
