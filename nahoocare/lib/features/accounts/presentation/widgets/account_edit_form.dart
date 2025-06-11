import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/account_entity.dart';

class AccountEditForm extends StatefulWidget {
  final AccountEntity initialAccount;

  AccountEditForm({super.key, required this.initialAccount});

  // These getters will be overridden using the state
  GlobalKey<FormState> get formKey => _formKey;
  AccountEntity get updatedAccount =>
      _state?._getUpdatedAccount() ?? initialAccount;
  String? get password => _state?._password;
  File? get selectedImage => _state?._imageFile;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _AccountEditFormState? _state;

  @override
  State<AccountEditForm> createState() {
    _state = _AccountEditFormState();
    return _state!;
  }
}

class _AccountEditFormState extends State<AccountEditForm> {
  String? _fullName;
  String? _phoneNumber;
  String? _secretQuestion;
  String? _secretAnswer;
  String? _gender;
  DateTime? _dateOfBirth;
  String? _password;
  File? _imageFile;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  AccountEntity _getUpdatedAccount() {
    return widget.initialAccount.copyWith(
      fullName: _fullName,
      phoneNumber: _phoneNumber,
      secretQuestion: _secretQuestion,
      secretAnswer: _secretAnswer,
      gender: _gender,
      dateOfBirth: _dateOfBirth?.toIso8601String(),
      photoUrl: widget.initialAccount.photoUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  _imageFile != null
                      ? FileImage(_imageFile!)
                      : widget.initialAccount.photoUrl != null
                      ? NetworkImage(widget.initialAccount.photoUrl!)
                          as ImageProvider
                      : null,
              child:
                  _imageFile == null && widget.initialAccount.photoUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: widget.initialAccount.fullName,
            decoration: const InputDecoration(labelText: 'Full Name'),
            onSaved: (value) => _fullName = value,
            validator:
                (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            initialValue: widget.initialAccount.phoneNumber,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            onSaved: (value) => _phoneNumber = value,
            validator:
                (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onSaved: (value) => _password = value,
            validator:
                (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            initialValue: widget.initialAccount.secretQuestion,
            decoration: const InputDecoration(labelText: 'Secret Question'),
            onSaved: (value) => _secretQuestion = value,
          ),
          TextFormField(
            initialValue: widget.initialAccount.secretAnswer,
            decoration: const InputDecoration(labelText: 'Secret Answer'),
            onSaved: (value) => _secretAnswer = value,
          ),
          DropdownButtonFormField<String>(
            value: widget.initialAccount.gender,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (value) => _gender = value,
            onSaved: (value) => _gender = value,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate:
                    widget.initialAccount.dateOfBirth != null
                        ? DateTime.parse(widget.initialAccount.dateOfBirth!)
                        : DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                setState(() {
                  _dateOfBirth = pickedDate;
                });
              }
            },
            child: Text(
              _dateOfBirth != null
                  ? 'DOB: ${_dateOfBirth!.toLocal()}'.split(' ')[0]
                  : 'Select Date of Birth',
            ),
          ),
        ],
      ),
    );
  }
}
