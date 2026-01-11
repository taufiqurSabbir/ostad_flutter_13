import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/core/enums/api_state.dart';
import 'package:task_manager/providers/network_provider.dart';

import '../widgets/screen_background.dart';

/// Sign Up Screen - Refactored with Provider State Management
/// This screen demonstrates complex form handling with Provider
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Text(
                    'Join with us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  _buildEmailField(),
                  const SizedBox(height: 15),
                  _buildFirstNameField(),
                  const SizedBox(height: 16),
                  _buildLastNameField(),
                  const SizedBox(height: 15),
                  _buildMobileField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 16),
                  _buildSignUpButton(),
                  const SizedBox(height: 35),
                  _buildFooterSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build email field
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(hintText: 'Email'),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }

        final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegExp.hasMatch(value)) {
          return 'Please enter valid email';
        }

        return null;
      },
    );
  }

  /// Build first name field
  Widget _buildFirstNameField() {
    return TextFormField(
      controller: _firstNameController,
      decoration: const InputDecoration(hintText: 'First name'),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your first name';
        }

        if (value.trim().length < 2) {
          return 'First name must be at least 2 characters';
        }

        return null;
      },
    );
  }

  /// Build last name field
  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: const InputDecoration(hintText: 'Last name'),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
        }

        if (value.trim().length < 2) {
          return 'Last name must be at least 2 characters';
        }

        return null;
      },
    );
  }

  /// Build mobile field
  Widget _buildMobileField() {
    return TextFormField(
      controller: _mobileController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(hintText: 'Mobile'),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your mobile number';
        }

        if (value.trim().length != 11) {
          return 'Enter valid phone number (11 digits)';
        }

        return null;
      },
    );
  }

  /// Build password field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(hintText: 'Password'),
      obscureText: true,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }

        if (value.length <= 6) {
          return 'Password must be more than 6 characters';
        }

        return null;
      },
    );
  }

  /// Build sign up button
  Widget _buildSignUpButton() {
    return Consumer<NetworkProvider>(
      builder: (context, networkProvider, child) {
        final bool isLoading =
            networkProvider.registrationState == ApiState.loading;

        return FilledButton(
          onPressed: isLoading ? null : _onTapSignUp,
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
    );
  }

  /// Build footer section
  Widget _buildFooterSection() {
    return Center(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: "Already have an account? ",
              children: const [
                TextSpan(
                  text: 'Sign in',
                  style: TextStyle(color: Colors.green),
                ),
              ],
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle sign up
  Future<void> _onTapSignUp() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get NetworkProvider
    final networkProvider =
        Provider.of<NetworkProvider>(context, listen: false);

    // Perform registration
    final result = await networkProvider.register(
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      mobile: _mobileController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    // Handle result
    if (result != null) {
      _clearTextField();
      _showSnackBar(AppConstants.registrationSuccessMessage, Colors.green);
      
      // Navigate back to login
      Navigator.pop(context);
    } else {
      _showSnackBar(
        networkProvider.errorMessage ?? AppConstants.genericErrorMessage,
        Colors.red,
      );
    }
  }

  /// Show snackbar
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Clear text fields
  void _clearTextField() {
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
