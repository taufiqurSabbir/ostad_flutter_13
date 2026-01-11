import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/enums/api_state.dart';
import 'package:task_manager/core/enums/task_status.dart';
import 'package:task_manager/providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_by_status.dart';
import '../widgets/tm_app_bar.dart';
import 'add_new_task_screen.dart';

/// New Task Screen - Refactored with Provider State Management
/// This screen demonstrates how to consume Provider state in a professional way
class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  /// Load task data using Provider
  Future<void> _loadData() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await Future.wait([
      taskProvider.fetchTaskStatusCounts(),
      taskProvider.fetchTasksByStatus(TaskStatus.newTask),
    ]);
  }

  /// Refresh data - called when returning from add task screen
  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: const TMAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 15),
          _buildTaskStatusCountSection(),
          Expanded(child: _buildTaskListSection()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build task status count horizontal list
  Widget _buildTaskStatusCountSection() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        height: 90,
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            // Show loading indicator
            if (taskProvider.taskCountState == ApiState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show error message
            if (taskProvider.taskCountState == ApiState.error) {
              return Center(
                child: Text(
                  taskProvider.errorMessage ?? 'Error loading counts',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            // Show task counts
            final counts = taskProvider.taskStatusCounts;
            if (counts.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: counts.length,
              itemBuilder: (context, index) {
                return TaskCountByStatus(
                  title: counts[index].status,
                  count: counts[index].count,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 4),
            );
          },
        ),
      ),
    );
  }

  /// Build task list section
  Widget _buildTaskListSection() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        // Show loading indicator
        if (taskProvider.taskListState == ApiState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message
        if (taskProvider.taskListState == ApiState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  taskProvider.errorMessage ?? 'Error loading tasks',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Show task list
        final tasks = taskProvider.newTasks;
        if (tasks.isEmpty) {
          return const Center(
            child: Text(
              'No new tasks available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.separated(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: tasks[index],
                cardColor: Colors.blue,
                refreshParent: _refreshData,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 4),
          ),
        );
      },
    );
  }

  /// Navigate to Add Task screen
  Future<void> _onTapAddButton() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewTaskScreen()),
    );

    // Refresh data if task was added
    if (result == true) {
      _refreshData();
    }
  }
}
