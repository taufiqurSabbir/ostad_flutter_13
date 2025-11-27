import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';

class MainNavBarHolderScreen extends StatefulWidget {
  const MainNavBarHolderScreen({super.key});

  @override
  State<MainNavBarHolderScreen> createState() => _MainNavBarHolderScreenState();
}

class _MainNavBarHolderScreenState extends State<MainNavBarHolderScreen> {
  int _selectedIndex = 0;

  List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    ProgressTaskScreen(),
    ProgressTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            _selectedIndex = index;
            setState(() {});
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.refresh), label: 'New Task'),
            NavigationDestination(
                icon: Icon(Icons.done_all), label: 'Completed'),
            NavigationDestination(icon: Icon(Icons.close), label: 'Cancelled'),
            NavigationDestination(icon: Icon(Icons.refresh), label: 'Progress'),
          ]),
    );
  }
}
