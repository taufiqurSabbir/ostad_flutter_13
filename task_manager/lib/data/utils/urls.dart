class Urls {
  static String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static String registrationUrl = '$_baseUrl/registration';
  static String loginUrl = '$_baseUrl/login';
  static String createTaskUrl = '$_baseUrl/createTask';
  static String taskCountUrl = '$_baseUrl/taskStatusCount';
  static String newTaskUrl = '$_baseUrl/listTaskByStatus/New';
  static String progressTaskUrl = '$_baseUrl/listTaskByStatus/Progress';
  static String completedTaskUrl = '$_baseUrl/listTaskByStatus/Completed';
  static String CancelledTaskUrl = '$_baseUrl/listTaskByStatus/Cancelled';
  static String updateProfileUrl = '$_baseUrl/profileUpdate';
  static String deleteTaskUrl(String taskId) => '$_baseUrl/deleteTask/$taskId';
  static String changeStatus(String taskId,String status) => '$_baseUrl/updateTaskStatus/$taskId/$status';
}
