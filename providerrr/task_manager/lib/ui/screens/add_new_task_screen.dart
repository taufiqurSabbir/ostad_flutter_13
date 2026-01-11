import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/core/enums/api_state.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

/// Add New Task Screen - Refactored with Provider State Management
/// This screen demonstrates form handling with Provider
class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'Add new Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  _buildTitleField(),
                  const SizedBox(height: 20),
                  _buildDescriptionField(),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build title input field
  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(hintText: 'Title'),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter title';
        }
        return null;
      },
    );
  }

  /// Build description input field
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 6,
      decoration: const InputDecoration(hintText: 'Description'),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter description';
        }
        return null;
      },
    );
  }

  /// Build submit button with loading state
  Widget _buildSubmitButton() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final bool isLoading =
            taskProvider.createTaskState == ApiState.loading;

        return FilledButton(
          onPressed: isLoading ? null : _onTapSubmit,
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

  /// Handle form submission
  Future<void> _onTapSubmit() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get TaskProvider
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    // Create task
    final success = await taskProvider.createTask(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    if (!mounted) return;

    // Handle result
    if (success) {
      _clearFields();
      _showSnackBar(AppConstants.taskCreatedMessage, Colors.green);
      
      // Return true to indicate task was created
      Navigator.pop(context, true);
    } else {
      _showSnackBar(
        taskProvider.errorMessage ?? AppConstants.genericErrorMessage,
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

  /// Clear input fields
  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
