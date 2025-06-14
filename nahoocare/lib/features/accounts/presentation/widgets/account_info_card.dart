import 'package:flutter/material.dart';
import '../../domain/entities/account_entity.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountInfoCard extends StatelessWidget {
  final AccountEntity account;

  const AccountInfoCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Centered profile image
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  account.photoUrl.isNotEmpty
                      ? NetworkImage(account.photoUrl)
                      : const AssetImage(
                            'assets/images/profile-placeholder.png',
                          )
                          as ImageProvider,
            ),
          ),
          const SizedBox(height: 16),

          // Full Name
          Text(
            account.fullName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),
          Divider(thickness: 1, color: Colors.grey[300]),
          const SizedBox(height: 16),

          // Info Items
          _buildInfoRow(
            context,
            Icons.phone,
            'Phone Number'.tr(),
            account.phoneNumber,
          ),
          _buildInfoRow(
            context,
            Icons.calendar_month,
            'Date of Birth'.tr(),
            account.dateOfBirth,
          ),
          _buildInfoRow(context, Icons.person, 'Gender'.tr(), account.gender),
          _buildInfoRow(
            context,
            Icons.lock,
            'Secret Question'.tr(),
            account.secretQuestion,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
