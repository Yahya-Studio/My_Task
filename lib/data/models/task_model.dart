import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime dateTime;

  @HiveField(4)
  String category; // 'work', 'personal', 'study', 'health', 'shopping'

  @HiveField(5)
  int priority; // 1: عادية, 2: متوسطة, 3: عالية

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  DateTime? reminderTime;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
    this.priority = 1,
    this.isCompleted = false,
    this.reminderTime,
    required this.createdAt,
    this.completedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? category,
    int? priority,
    bool? isCompleted,
    DateTime? reminderTime,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Helper method to check if task is today
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  // Helper method to check if task is overdue
  bool get isOverdue {
    return !isCompleted && dateTime.isBefore(DateTime.now());
  }

  // Helper method to check if task is upcoming
  bool get isUpcoming {
    return dateTime.isAfter(DateTime.now());
  }
}
