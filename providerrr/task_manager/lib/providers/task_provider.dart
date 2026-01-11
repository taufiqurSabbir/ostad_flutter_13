import 'package:flutter/foundation.dart';
import '../core/enums/api_state.dart';
import '../core/enums/task_status.dart';
import '../data/models/task_model.dart';
import '../data/models/task_status_count_model.dart';
import '../data/services/api_caller.dart';
import '../data/utils/urls.dart';

/// TaskProvider manages all task-related state and operations
/// This includes fetching tasks, creating, updating, and deleting tasks
class TaskProvider extends ChangeNotifier {
  // Task lists by status
  List<TaskModel> _newTasks = [];
  List<TaskModel> _progressTasks = [];
  List<TaskModel> _completedTasks = [];
  List<TaskModel> _cancelledTasks = [];
  
  // Task status counts
  List<TaskStatusCountModel> _taskStatusCounts = [];
  
  // API states for different operations
  ApiState _taskListState = ApiState.initial;
  ApiState _taskCountState = ApiState.initial;
  ApiState _createTaskState = ApiState.initial;
  ApiState _updateTaskState = ApiState.initial;
  ApiState _deleteTaskState = ApiState.initial;
  
  String? _errorMessage;

  // Public getters
  List<TaskModel> get newTasks => _newTasks;
  List<TaskModel> get progressTasks => _progressTasks;
  List<TaskModel> get completedTasks => _completedTasks;
  List<TaskModel> get cancelledTasks => _cancelledTasks;
  List<TaskStatusCountModel> get taskStatusCounts => _taskStatusCounts;
  
  ApiState get taskListState => _taskListState;
  ApiState get taskCountState => _taskCountState;
  ApiState get createTaskState => _createTaskState;
  ApiState get updateTaskState => _updateTaskState;
  ApiState get deleteTaskState => _deleteTaskState;
  
  String? get errorMessage => _errorMessage;

  /// Fetch task status counts
  Future<void> fetchTaskStatusCounts() async {
    _taskCountState = ApiState.loading;
    notifyListeners();

    try {
      final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.taskCountUrl,
      );

      if (response.isSuccess) {
        _taskStatusCounts = [];
        for (Map<String, dynamic> jsonData in response.responseData['data']) {
          _taskStatusCounts.add(TaskStatusCountModel.formJson(jsonData));
        }
        _taskCountState = ApiState.success;
        _errorMessage = null;
      } else {
        _taskCountState = ApiState.error;
        _errorMessage = response.errorMessage ?? 'Failed to fetch task counts';
      }
    } catch (e) {
      _taskCountState = ApiState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Fetch tasks by status
  Future<void> fetchTasksByStatus(TaskStatus status) async {
    _taskListState = ApiState.loading;
    notifyListeners();

    try {
      String url;
      switch (status) {
        case TaskStatus.newTask:
          url = Urls.newTaskUrl;
          break;
        case TaskStatus.progress:
          url = Urls.progressTaskUrl;
          break;
        case TaskStatus.completed:
          url = Urls.completedTaskUrl;
          break;
        case TaskStatus.cancelled:
          url = Urls.cancelledTaskUrl;
          break;
      }

      final ApiResponse response = await ApiCaller.getRequest(url: url);

      if (response.isSuccess) {
        List<TaskModel> tasks = [];
        for (Map<String, dynamic> jsonData in response.responseData['data']) {
          tasks.add(TaskModel.fromJson(jsonData));
        }

        // Update the appropriate list
        switch (status) {
          case TaskStatus.newTask:
            _newTasks = tasks;
            break;
          case TaskStatus.progress:
            _progressTasks = tasks;
            break;
          case TaskStatus.completed:
            _completedTasks = tasks;
            break;
          case TaskStatus.cancelled:
            _cancelledTasks = tasks;
            break;
        }

        _taskListState = ApiState.success;
        _errorMessage = null;
      } else {
        _taskListState = ApiState.error;
        _errorMessage = response.errorMessage ?? 'Failed to fetch tasks';
      }
    } catch (e) {
      _taskListState = ApiState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Create a new task
  Future<bool> createTask({
    required String title,
    required String description,
  }) async {
    _createTaskState = ApiState.loading;
    notifyListeners();

    try {
      final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.createTaskUrl,
        body: {
          'title': title,
          'description': description,
          'status': TaskStatus.newTask.value,
        },
      );

      if (response.isSuccess) {
        _createTaskState = ApiState.success;
        _errorMessage = null;
        notifyListeners();
        
        // Refresh task lists
        await fetchTasksByStatus(TaskStatus.newTask);
        await fetchTaskStatusCounts();
        
        return true;
      } else {
        _createTaskState = ApiState.error;
        _errorMessage = response.errorMessage ?? 'Failed to create task';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _createTaskState = ApiState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update task status
  Future<bool> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    _updateTaskState = ApiState.loading;
    notifyListeners();

    try {
      final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.changeStatus(taskId, newStatus.value),
      );

      if (response.isSuccess) {
        _updateTaskState = ApiState.success;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _updateTaskState = ApiState.error;
        _errorMessage = response.errorMessage ?? 'Failed to update task';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _updateTaskState = ApiState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete a task
  Future<bool> deleteTask(String taskId) async {
    _deleteTaskState = ApiState.loading;
    notifyListeners();

    try {
      final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.deleteTaskUrl(taskId),
      );

      if (response.isSuccess) {
        _deleteTaskState = ApiState.success;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _deleteTaskState = ApiState.error;
        _errorMessage = response.errorMessage ?? 'Failed to delete task';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _deleteTaskState = ApiState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Reset task states
  void resetCreateTaskState() {
    _createTaskState = ApiState.initial;
    notifyListeners();
  }

  void resetUpdateTaskState() {
    _updateTaskState = ApiState.initial;
    notifyListeners();
  }

  void resetDeleteTaskState() {
    _deleteTaskState = ApiState.initial;
    notifyListeners();
  }
}
