import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../models/notification_model.dart';

class HiveService {
  static const String tasksBoxName = 'tasks';
  static const String notificationsBoxName = 'notifications';
  static const String settingsBoxName = 'settings';

  // Initialize Hive and register adapters
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AppNotificationAdapter());
    }
    
    // Open boxes
    await Hive.openBox<Task>(tasksBoxName);
    await Hive.openBox<AppNotification>(notificationsBoxName);
    await Hive.openBox(settingsBoxName);
  }

  // Task operations
  static Box<Task> get tasksBox => Hive.box<Task>(tasksBoxName);

  static Future<void> addTask(Task task) async {
    await tasksBox.put(task.id, task);
  }

  static Future<void> updateTask(Task task) async {
    await tasksBox.put(task.id, task);
  }

  static Future<void> deleteTask(String taskId) async {
    await tasksBox.delete(taskId);
  }

  static Task? getTask(String taskId) {
    return tasksBox.get(taskId);
  }

  static List<Task> getAllTasks() {
    return tasksBox.values.toList();
  }

  static List<Task> getTasksByDate(DateTime date) {
    return tasksBox.values.where((task) {
      return task.dateTime.year == date.year &&
          task.dateTime.month == date.month &&
          task.dateTime.day == date.day;
    }).toList();
  }

  static List<Task> getTasksByCategory(String category) {
    return tasksBox.values.where((task) => task.category == category).toList();
  }

  static List<Task> getTodayTasks() {
    final now = DateTime.now();
    return getTasksByDate(now);
  }

  static List<Task> getCompletedTasks() {
    return tasksBox.values.where((task) => task.isCompleted).toList();
  }

  static List<Task> getPendingTasks() {
    return tasksBox.values.where((task) => !task.isCompleted).toList();
  }

  // Notification operations
  static Box<AppNotification> get notificationsBox =>
      Hive.box<AppNotification>(notificationsBoxName);

  static Future<void> addNotification(AppNotification notification) async {
    await notificationsBox.put(notification.id, notification);
  }

  static Future<void> updateNotification(AppNotification notification) async {
    await notificationsBox.put(notification.id, notification);
  }

  static Future<void> deleteNotification(String notificationId) async {
    await notificationsBox.delete(notificationId);
  }

  static List<AppNotification> getAllNotifications() {
    return notificationsBox.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static List<AppNotification> getUnreadNotifications() {
    return notificationsBox.values.where((n) => !n.isRead).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static Future<void> markAllNotificationsAsRead() async {
    for (var notification in notificationsBox.values) {
      if (!notification.isRead) {
        notification.isRead = true;
        await updateNotification(notification);
      }
    }
  }

  // Statistics
  static int getTotalTasksCount() {
    return tasksBox.length;
  }

  static int getCompletedTasksCount() {
    return getCompletedTasks().length;
  }

  static int getPendingTasksCount() {
    return getPendingTasks().length;
  }

  static double getCompletionPercentage() {
    final total = getTotalTasksCount();
    if (total == 0) return 0.0;
    final completed = getCompletedTasksCount();
    return (completed / total) * 100;
  }

  static double getTodayCompletionPercentage() {
    final todayTasks = getTodayTasks();
    if (todayTasks.isEmpty) return 0.0;
    final completed = todayTasks.where((t) => t.isCompleted).length;
    return (completed / todayTasks.length) * 100;
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await tasksBox.clear();
    await notificationsBox.clear();
  }

  // Close all boxes
  static Future<void> close() async {
    await Hive.close();
  }
  // User Profile
  static Box get settingsBox => Hive.box(settingsBoxName);

  static String getUserName() {
    return settingsBox.get('userName', defaultValue: 'أحمد محمد');
  }

  static Future<void> setUserName(String name) async {
    await settingsBox.put('userName', name);
  }

  static String getUserPhotoUrl() {
    return settingsBox.get('userPhotoUrl', defaultValue: 'https://i.pravatar.cc/200?img=12');
  }

  static Future<void> setUserPhotoUrl(String url) async {
    await settingsBox.put('userPhotoUrl', url);
  }
}
