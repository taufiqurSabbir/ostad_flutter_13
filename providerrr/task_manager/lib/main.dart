import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/network_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'app.dart';

/// Main entry point of the application
/// Sets up all providers using MultiProvider for state management
void main() {
  runApp(
    MultiProvider(
      providers: [
        // AuthProvider: Manages authentication state and user data
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // NetworkProvider: Handles all API network calls
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        
        // TaskProvider: Manages task-related state and operations
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const TaskManagerApp(),
    ),
  );
}