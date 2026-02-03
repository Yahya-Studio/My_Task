import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/localization/locale_provider.dart';
import '../../data/local/hive_service.dart';
import '../../data/models/notification_model.dart';
import '../tasks/add_task_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;
    
    final notifications = HiveService.getAllNotifications();
    final todayNotifications = notifications.where((n) => n.isToday).toList();
    final yesterdayNotifications = notifications.where((n) => n.isYesterday).toList();
    final olderNotifications = notifications.where((n) => !n.isToday && !n.isYesterday).toList();
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isArabic ? Icons.arrow_forward : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isArabic ? AppStrings.notificationsAr : AppStrings.notificationsEn,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              HiveService.markAllNotificationsAsRead();
              setState(() {});
            },
            child: Text(
              isArabic ? AppStrings.markAllReadAr : AppStrings.markAllReadEn,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: const Color(0xFF4FC3F7),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Today Section
          if (todayNotifications.isNotEmpty) ...[
            _buildSectionHeader(isArabic ? AppStrings.todayAr : AppStrings.todayEn, isArabic),
            const SizedBox(height: 12),
            ...todayNotifications.map((n) => _buildNotificationCard(isArabic, n)).toList(),
            const SizedBox(height: 24),
          ],
          
          // Yesterday Section
          if (yesterdayNotifications.isNotEmpty) ...[
            _buildSectionHeader(isArabic ? AppStrings.yesterdayAr : AppStrings.yesterdayEn, isArabic),
            const SizedBox(height: 12),
            ...yesterdayNotifications.map((n) => _buildNotificationCard(isArabic, n)).toList(),
            const SizedBox(height: 24),
          ],
          
          // Older Section
          if (olderNotifications.isNotEmpty) ...[
            ...olderNotifications.map((n) => _buildNotificationCard(isArabic, n)).toList(),
          ],
          
          // Load More Button
          if (notifications.length > 10)
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.expand_more, color: Color(0xFF4FC3F7)),
                label: Text(
                  isArabic ? AppStrings.olderNotificationsAr : AppStrings.olderNotificationsEn,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: const Color(0xFF4FC3F7),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          ).then((_) => setState(() {}));
        },
        backgroundColor: const Color(0xFF0D7377),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isArabic) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[400],
      ),
      textAlign: isArabic ? TextAlign.right : TextAlign.left,
    );
  }

  Widget _buildNotificationCard(bool isArabic, AppNotification notification) {
    final notificationColor = _getNotificationColor(notification.type);
    final notificationIcon = _getNotificationIcon(notification.type);
    final timeStr = _formatTime(notification.timestamp, isArabic);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          notification.isRead = true;
          HiveService.updateNotification(notification);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B263B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead 
                ? Colors.transparent 
                : notificationColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isArabic) ...[
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: notificationColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notificationIcon,
                  color: notificationColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
            ],
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isArabic && !notification.isRead)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: notificationColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isArabic ? AppStrings.newAr : AppStrings.newEn,
                            style: GoogleFonts.cairo(
                              fontSize: 10,
                              color: notificationColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        ),
                      ),
                      if (isArabic && !notification.isRead)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: notificationColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isArabic ? AppStrings.newAr : AppStrings.newEn,
                            style: GoogleFonts.cairo(
                              fontSize: 10,
                              color: notificationColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.description,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isArabic) ...[
                        Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        timeStr,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (isArabic) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            if (isArabic) ...[
              const SizedBox(width: 12),
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: notificationColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notificationIcon,
                  color: notificationColor,
                  size: 24,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'reminder':
        return const Color(0xFF2196F3);
      case 'team':
        return const Color(0xFF9C27B0);
      case 'completion':
        return const Color(0xFF4CAF50);
      case 'feature':
        return const Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'reminder':
        return Icons.notifications_active;
      case 'team':
        return Icons.people;
      case 'completion':
        return Icons.check_circle;
      case 'feature':
        return Icons.rocket_launch;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime timestamp, bool isArabic) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return isArabic ? 'منذ $minutes دقيقة' : '$minutes min ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return isArabic ? 'منذ $hours ساعة' : '$hours hours ago';
    } else {
      final timeStr = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
      return isArabic ? 'أمس $timeStr' : 'Yesterday $timeStr';
    }
  }
}
