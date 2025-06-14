import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/account_entity.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountEditForm extends StatefulWidget {
  final AccountEntity initialAccount;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? fullName;
  String? phoneNumber;
  String? secretQuestion;
  String? secretAnswer;
  String? gender;
  String? dateOfBirth;
  String? password;

  AccountEditForm({super.key, required this.initialAccount});

  get updatedAccount => null;

  get selectedImage => null;

  @override
  State<AccountEditForm> createState() => _AccountEditFormState();
}

class _AccountEditFormState extends State<AccountEditForm> {
  File? _imageFile;

  final List<String> _genders = ['Male'.tr(), 'Female'.tr()];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    widget.fullName = widget.initialAccount.fullName;
    widget.phoneNumber = widget.initialAccount.phoneNumber;
    widget.secretQuestion = widget.initialAccount.secretQuestion;
    widget.secretAnswer = widget.initialAccount.secretAnswer;
    widget.gender = widget.initialAccount.gender;
    widget.dateOfBirth = widget.initialAccount.dateOfBirth;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 13),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        widget.dateOfBirth = picked.toIso8601String();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  _imageFile != null
                      ? FileImage(_imageFile!)
                      : widget.initialAccount.photoUrl.isNotEmpty
                      ? NetworkImage(widget.initialAccount.photoUrl)
                      : const AssetImage(
                            'assets/images/profile-placeholder.png',
                          )
                          as ImageProvider,
              child:
                  _imageFile == null && widget.initialAccount.photoUrl.isEmpty
                      ? const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                        size: 32,
                      )
                      : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap to change photo'.tr(),
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          _buildTextField(
            label: 'Full Name'.tr(),
            initialValue: widget.initialAccount.fullName,
            onSaved: (val) => widget.fullName = val,
            validatorMsg: 'Please enter your name'.tr(),
          ),
          const SizedBox(height: 16),

          _buildTextField(
            label: 'Phone Number'.tr(),
            initialValue: widget.initialAccount.phoneNumber,
            keyboardType: TextInputType.phone,
            onSaved: (val) => widget.phoneNumber = val,
            validatorMsg: 'Please enter phone number'.tr(),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: widget.gender,
            items:
                _genders
                    .map(
                      (gender) =>
                          DropdownMenuItem(value: gender, child: Text(gender)),
                    )
                    .toList(),
            onChanged: (value) => setState(() => widget.gender = value),
            onSaved: (value) => widget.gender = value,
            decoration: InputDecoration(
              labelText: 'Gender'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            validator:
                (value) =>
                    value == null ? 'Please select your gender'.tr() : null,
          ),
          const SizedBox(height: 16),

          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date of Birth'.tr(),
                  hintText: 'Select your date of birth'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                controller: TextEditingController(
                  text:
                      _selectedDate == null
                          ? ''
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please select your date of birth'.tr()
                            : null,
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildTextField(
            label: 'Security Question',
            initialValue: widget.initialAccount.secretQuestion,
            onSaved: (val) => widget.secretQuestion = val,
            validatorMsg: 'Please enter security question'.tr(),
          ),
          const SizedBox(height: 16),

          _buildTextField(
            label: 'Security Answer'.tr(),
            initialValue: widget.initialAccount.secretAnswer,
            onSaved: (val) => widget.secretAnswer = val,
            validatorMsg: 'Please enter security answer'.tr(),
          ),
          const SizedBox(height: 16),

          _buildTextField(
            label: 'Current Password'.tr(),
            obscureText: true,
            onSaved: (val) => widget.password = val,
            validatorMsg: 'Please enter your password'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String?) onSaved,
    required String validatorMsg,
  }) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator:
          (value) => (value == null || value.isEmpty) ? validatorMsg : null,
      onSaved: onSaved,
    );
  }
}
