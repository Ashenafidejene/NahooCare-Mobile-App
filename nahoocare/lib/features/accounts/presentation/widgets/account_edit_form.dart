import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/account_entity.dart';
import 'package:easy_localization/easy_localization.dart';

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
  String? _confirmPassword;
  File? _imageFile;

  // For password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Controller for Date of Birth field
  final TextEditingController _dobController = TextEditingController();

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize DOB controller with initial value if it exists
    if (widget.initialAccount.dateOfBirth != null) {
      _dateOfBirth = DateTime.parse(widget.initialAccount.dateOfBirth!);
      _dobController.text = _formatDate(_dateOfBirth!);
    }
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDateOfBirth() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dateOfBirth = pickedDate;
        _dobController.text = _formatDate(pickedDate);
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password'.tr();
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters'.tr();
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _password) {
      return 'Passwords do not match'.tr();
    }
    return null;
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
            decoration: InputDecoration(
              labelText: 'Full Name'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            onSaved: (value) => _fullName = value,
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Please enter your full name'.tr()
                        : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: widget.initialAccount.phoneNumber,
            decoration: InputDecoration(
              labelText: 'Phone Number'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            onSaved: (value) => _phoneNumber = value,
            validator:
                (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            onSaved: (value) => _password = value,
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            obscureText: _obscureConfirmPassword,
            onSaved: (value) => _confirmPassword = value,
            validator: _validateConfirmPassword,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: widget.initialAccount.secretQuestion,
            decoration: InputDecoration(
              labelText: 'Secret Question'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            onSaved: (value) => _secretQuestion = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: widget.initialAccount.secretAnswer,
            decoration: InputDecoration(
              labelText: 'Secret Answer'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            onSaved: (value) => _secretAnswer = value,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: widget.initialAccount.gender,
            decoration: InputDecoration(
              labelText: 'Gender'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
            ],
            onChanged: (value) => _gender = value,
            onSaved: (value) => _gender = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dobController,
            readOnly: true,
            onTap: _pickDateOfBirth,
            decoration: InputDecoration(
              labelText: 'Date of Birth'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
          ),
        ],
      ),
    );
  }
}
