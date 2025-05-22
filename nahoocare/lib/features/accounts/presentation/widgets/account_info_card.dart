import 'package:flutter/material.dart';

import '../../domain/entities/account_entity.dart';

class AccountInfoCard extends StatelessWidget {
  final AccountEntity account;

  const AccountInfoCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Full Name', account.fullName),
            const Divider(),
            _buildInfoRow('Phone Number', account.phoneNumber),
            const Divider(),
            _buildInfoRow('Security Question', account.secretQuestion),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
