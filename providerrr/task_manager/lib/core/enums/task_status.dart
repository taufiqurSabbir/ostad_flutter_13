/// Enum representing the different statuses a task can have
/// This helps maintain consistency and prevents typos in status strings
enum TaskStatus {
  newTask('New'),
  progress('Progress'),
  completed('Completed'),
  cancelled('Cancelled');

  final String value;
  const TaskStatus(this.value);

  /// Convert from string to enum
  static TaskStatus fromString(String status) {
    switch (status) {
      case 'New':
        return TaskStatus.newTask;
      case 'Progress':
        return TaskStatus.progress;
      case 'Completed':
        return TaskStatus.completed;
      case 'Cancelled':
        return TaskStatus.cancelled;
      default:
        return TaskStatus.newTask;
    }
  }
}
