import 'package:flutter/material.dart';

import '../../domain/entities/account_entity.dart';

class AccountEditForm extends StatefulWidget {
  final AccountEntity initialAccount;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? fullName;
  String? phoneNumber;
  String? secretQuestion;
  String? secretAnswer;
  String? password;

  AccountEditForm({super.key, required this.initialAccount});

  @override
  State<AccountEditForm> createState() => _AccountEditFormState();
}

class _AccountEditFormState extends State<AccountEditForm> {
  @override
  void initState() {
    super.initState();
    widget.fullName = widget.initialAccount.fullName;
    widget.phoneNumber = widget.initialAccount.phoneNumber;
    widget.secretQuestion = widget.initialAccount.secretQuestion;
    widget.secretAnswer = widget.initialAccount.secretAnswer;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: widget.initialAccount.fullName,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter your name' : null,
            onSaved: (value) => widget.fullName = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            initialValue: widget.initialAccount.phoneNumber,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter phone number' : null,
            onSaved: (value) => widget.phoneNumber = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            initialValue: widget.initialAccount.secretQuestion,
            decoration: const InputDecoration(labelText: 'Security Question'),
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter security question'
                        : null,
            onSaved: (value) => widget.secretQuestion = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            initialValue: widget.initialAccount.secretAnswer,
            decoration: const InputDecoration(labelText: 'Security Answer'),
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter security answer'
                        : null,
            onSaved: (value) => widget.secretAnswer = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Current Password'),
            obscureText: true,
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter your password'
                        : null,
            onSaved: (value) => widget.password = value,
          ),
        ],
      ),
    );
  }
}
