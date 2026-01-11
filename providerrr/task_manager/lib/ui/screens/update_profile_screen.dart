import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/enums/api_state.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/network_provider.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bae.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../widgets/photo_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.userModel;
      
      if (user != null) {
        emailController.text = user.email ?? '';
        firstNameController.text = user.firstName ?? '';
        lastNameController.text = user.lastName ?? '';
        mobileController.text = user.mobile ?? '';
      }
    });
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if(image != null){
      _selectedImage = image;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Update Profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                photo_picker(
                  onTap: _pickImage,
                  selectedPhoto: _selectedImage,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(hintText: 'First name'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(hintText: 'Last name'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: mobileController,
                  decoration: InputDecoration(hintText: 'Mobile'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your mobile';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                  validator: (String? value) {
                    if ((value != null && value.isNotEmpty) && value.length < 6) {
                      return 'Enter a password more than 6 letters';
                    }
            
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Consumer<NetworkProvider>(
                  builder: (context, networkProvider, child) {
                    final isLoading = networkProvider.profileUpdateState == ApiState.loading;
                    
                    return FilledButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                updateProfile();
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.arrow_circle_right_outlined),
                    );
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> updateProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    final currentUser = authProvider.userModel;
    
    if (currentUser == null) {
      if (mounted) {
        showSnackBarMessage(context, 'User not logged in');
      }
      return;
    }

    String? encodedPhoto;

    if (_selectedImage != null) {
      List<int> bytes = await _selectedImage!.readAsBytes();
      encodedPhoto = base64Encode(bytes);
    }

    final result = await networkProvider.updateProfile(
      email: emailController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      mobile: mobileController.text.trim(),
      password: passwordController.text.isNotEmpty ? passwordController.text : null,
      photo: encodedPhoto,
    );

    if (!mounted) return;

    if (result != null) {
      // Update user data in AuthProvider with the returned model
      await authProvider.updateUserData(result);

      showSnackBarMessage(context, 'Profile updated successfully!');
      
      // Navigate back
      Navigator.pop(context);
    } else {
      showSnackBarMessage(
        context,
        networkProvider.errorMessage ?? 'Failed to update profile',
      );
    }
  }
}
