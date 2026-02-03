import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 2)
class AppNotification {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String type; // 'reminder', 'team', 'completion', 'feature'

  @HiveField(5)
  bool isRead;

  @HiveField(6)
  final String? relatedTaskId;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.relatedTaskId,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? timestamp,
    String? type,
    bool? isRead,
    String? relatedTaskId,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      relatedTaskId: relatedTaskId ?? this.relatedTaskId,
    );
  }

  // Helper method to check if notification is today
  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }

  // Helper method to check if notification is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return timestamp.year == yesterday.year &&
        timestamp.month == yesterday.month &&
        timestamp.day == yesterday.day;
  }
}
