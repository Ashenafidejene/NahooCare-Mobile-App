import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.blueAccent,
          ), // Larger back icon
          onPressed: () => Navigator.maybePop(context), // Safer pop
        ),
        title: const Text('Complete Profile'),
        centerTitle: true,
      ),
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        GestureDetector(
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
                        const SizedBox(height: 16),
                        Text(
                          _selectedImage == null
                              ? 'Tap to add profile photo'
                              : 'Photo selected',
                          style: TextStyle(
                            color:
                                _selectedImage == null
                                    ? Colors.grey
                                    : Colors.green,
                          ),
                        ),
                        const SizedBox(height: 32),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
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
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                          ],
                          onChanged:
                              (value) =>
                                  setState(() => _selectedGender = value),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          onTap: _pickDateOfBirth,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
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
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                (state is RegistrationLoading)
                                    ? null
                                    : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: Colors.blueAccent
                                  .withOpacity(0.7),
                            ),
                            child:
                                (state is RegistrationLoading)
                                    ? LoadingAnimationWidget.dotsTriangle(
                                      color: Colors.white,
                                      size: 30,
                                    )
                                    : const Text(
                                      'Complete Registration',
                                      style: TextStyle(fontSize: 16),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
