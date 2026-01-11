import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/data/services/api_caller.dart';

import '../utils/asset_paths.dart';
import '../widgets/screen_background.dart';
import 'login_page.dart';

/// Splash Screen - Refactored with Provider State Management
/// This screen loads user data and navigates based on authentication status
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initialize app - Load user data and navigate
  Future<void> _initializeApp() async {
    // Wait for splash screen display
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Get AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Load saved user data
    await authProvider.loadUserData();

    // Update ApiCaller token if user is logged in
    if (authProvider.isLoggedIn) {
      ApiCaller.accessToken = authProvider.accessToken;
    }

    if (!mounted) return;

    // Navigate based on login status
    if (authProvider.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/NavBar');
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SvgPicture.asset(
            AssetPaths.logoSVG,
            height: 50,
          ),
        ),
      ),
    );
  }
}
