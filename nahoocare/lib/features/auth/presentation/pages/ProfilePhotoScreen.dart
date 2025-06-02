import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/custom_button.dart';
import '../blocs/register_blocs/registration_flow_bloc.dart';

class ProfilePhotoScreen extends StatefulWidget {
  final String phoneNumber;

  const ProfilePhotoScreen({super.key, required this.phoneNumber});

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  File? _selectedImage;
  final TextEditingController _dobController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 13);
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 120),
      lastDate: initialDate,
    );
    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
        _dobController.text = DateFormat('yyyy-MM-dd').format(newDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: BlocConsumer<RegistrationFlowBloc, RegistrationFlowState>(
        listener: (context, state) {
          if (state is RegistrationError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is RegistrationSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/landing',
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Complete Your Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : const AssetImage(
                                    'assets/images/profile-placeholder.png',
                                  )
                                  as ImageProvider,
                      child:
                          _selectedImage == null
                              ? const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey,
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedImage == null
                      ? 'Tap to add profile photo'
                      : 'Photo selected',
                  style: TextStyle(
                    color: _selectedImage == null ? Colors.grey : Colors.green,
                  ),
                ),
                const SizedBox(height: 32),
                const SizedBox(height: 24),

                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                  ],
                  onChanged: (value) => setState(() => _selectedGender = value),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _pickDateOfBirth,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: 'Complete Registration',
                  isLoading: state is RegistrationLoading,
                  onPressed: _submitForm,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_selectedImage == null) {
      _showMessage('Please select a profile photo');
      return;
    }

    if (_selectedGender == null) {
      _showMessage('Please select your gender');
      return;
    }

    if (_selectedDate == null || _calculateAge(_selectedDate!) < 13) {
      _showMessage('You must be at least 13 years old');
      return;
    }

    context.read<RegistrationFlowBloc>().add(
      SubmitProfilePhotoEvent(
        photo: _selectedImage!,
        gender: _selectedGender!,
        dataOfBirth: DateFormat('yyyy-MM-dd').format(_selectedDate!),
      ),
    );
  }

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }
}
