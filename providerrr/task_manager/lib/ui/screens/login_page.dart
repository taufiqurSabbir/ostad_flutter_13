import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/core/enums/api_state.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/network_provider.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/data/services/api_caller.dart';

import '../widgets/screen_background.dart';
import 'forget_password_email_verify.dart';
import 'main_nav_bar_holder_screen.dart';

/// Login Page - Refactored with Provider State Management
/// This screen demonstrates professional state management using Provider
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Text(
                    'Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 25),
                  _buildEmailField(),
                  const SizedBox(height: 10),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  _buildSignInButton(),
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

  /// Build email input field with validation
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
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

  /// Build password input field with validation
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      obscureText: true,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }

        if (value.length <= 6) {
          return 'Enter password more than 6 characters';
        }

        return null;
      },
    );
  }

  /// Build sign in button with loading state using Consumer
  Widget _buildSignInButton() {
    return Consumer<NetworkProvider>(
      builder: (context, networkProvider, child) {
        final bool isLoading = networkProvider.loginState == ApiState.loading;

        return FilledButton(
          onPressed: isLoading ? null : _onTapSignIn,
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

  /// Build footer section with navigation options
  Widget _buildFooterSection() {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: _onTapForgetPassword,
            child: const Text('Forget password'),
          ),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              children: [
                TextSpan(
                  text: 'Sign Up',
                  style: const TextStyle(color: Colors.green),
                  recognizer: TapGestureRecognizer()..onTap = _onTapSignUp,
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

  /// Navigate to Sign Up screen
  void _onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  /// Navigate to Forget Password screen
  void _onTapForgetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgetPasswordEmailVerify()),
    );
  }

  /// Handle Sign In - Using Provider
  Future<void> _onTapSignIn() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get providers
    final networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Perform login
    final result = await networkProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    // Handle login result
    if (result != null) {
      // Save user data
      await authProvider.saveUserData(result['user'], result['token']);
      
      // Update ApiCaller token
      ApiCaller.accessToken = result['token'];

      // Clear text fields
      _clearTextField();

      // Show success message
      if (!mounted) return;
      _showSnackBar(AppConstants.loginSuccessMessage, Colors.green);

      // Navigate to main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavBarHolderScreen()),
      );
    } else {
      // Show error message
      _showSnackBar(
        networkProvider.errorMessage ?? AppConstants.genericErrorMessage,
        Colors.red,
      );
    }
  }

  /// Show snackbar message
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
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
