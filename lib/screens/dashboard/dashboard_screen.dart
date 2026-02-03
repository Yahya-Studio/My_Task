import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/local/hive_service.dart';
import '../../data/models/task_model.dart';
import '../tasks/add_task_screen.dart';
import '../tasks/task_list_screen.dart';
import '../calendar/calendar_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedDayIndex = 1; // Monday selected by default
  int _selectedBottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isArabic = localeProvider.isArabic;
    final isDarkMode = themeProvider.isDarkMode;

    // Theme Colors
    final backgroundColor = isDarkMode
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFF5F7FA);
    final cardColor = isDarkMode ? const Color(0xFF1B263B) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3436);
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    final todayTasks = HiveService.getTodayTasks();
    final completedToday = todayTasks.where((t) => t.isCompleted).length;
    final totalToday = todayTasks.length;
    final progressPercentage = totalToday > 0
        ? (completedToday / totalToday) * 100
        : 0.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(isArabic, isDarkMode, textColor, subTextColor),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Progress Card
                    _buildProgressCard(
                      isArabic,
                      progressPercentage,
                      completedToday,
                      totalToday,
                    ),

                    const SizedBox(height: 24),

                    // Week Days Selector
                    _buildWeekDaysSection(
                      isArabic,
                      isDarkMode,
                      cardColor,
                      textColor,
                      subTextColor,
                    ),

                    const SizedBox(height: 24),

                    // Today's Tasks
                    _buildTodayTasksSection(
                      isArabic,
                      todayTasks,
                      isDarkMode,
                      cardColor,
                      textColor,
                      subTextColor,
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          // Refresh the dashboard after adding a task
          setState(() {});
        },
        backgroundColor: const Color(0xFF0D7377),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigation(
        isArabic,
        isDarkMode,
        cardColor,
        subTextColor,
      ),
    );
  }

  String _getGreeting(bool isArabic) {
    final hour = DateTime.now().hour;
    if (isArabic) {
      if (hour < 12) return 'صباح الخير';
      if (hour < 18) return 'مساء الخير';
      return 'مساء الخير';
    } else {
      if (hour < 12) return 'Good Morning';
      if (hour < 18) return 'Good Afternoon';
      return 'Good Evening';
    }
  }

  Widget _buildHeader(
    bool isArabic,
    bool isDarkMode,
    Color textColor,
    Color subTextColor,
  ) {
    final userName = HiveService.getUserName();
    final userPhoto = HiveService.getUserPhotoUrl();
    final isLocalImage = !userPhoto.startsWith('http');

    ImageProvider imageProvider;
    if (isLocalImage && userPhoto.isNotEmpty && !kIsWeb) {
      imageProvider = FileImage(File(userPhoto));
    } else {
      imageProvider = NetworkImage(
        userPhoto.isEmpty ? '' : userPhoto,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (!isArabic) ...[
            // Profile Picture
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[700],
                border: Border.all(color: Colors.grey[300]!, width: 1),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(isArabic),
                  style: GoogleFonts.cairo(fontSize: 12, color: subTextColor),
                ),
                Row(
                  mainAxisAlignment: isArabic
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isArabic)
                      const Text('👋', style: TextStyle(fontSize: 20)),
                    if (!isArabic) const SizedBox(width: 6),
                    Text(
                      isArabic ? 'أهلاً بك، $userName' : 'Hello, $userName',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    if (isArabic) const SizedBox(width: 6),
                    if (isArabic)
                      const Text('👋', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
          ),

          if (isArabic) ...[
            const SizedBox(width: 12),
            // Profile Picture
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[700],
                border: Border.all(color: Colors.grey[300]!, width: 1),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          ],

          const SizedBox(width: 12),

          // Notification Bell
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.notifications_outlined, color: textColor),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          // Search Icon
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(isArabic),
              );
            },
            icon: Icon(Icons.search, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    bool isArabic,
    double percentage,
    int completed,
    int total,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D7377), Color(0xFF14919B)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Circular Progress
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                Text(
                  '${percentage.toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? AppStrings.todayProgressAr
                      : AppStrings.todayProgressEn,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                      ? 'لقد أكملت $completed من $total مهام، استمر في التقدم!'
                      : 'You completed $completed of $total tasks, keep going!',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isArabic ? '8/12 من الأمس' : '8/12 from yesterday',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaysSection(
    bool isArabic,
    bool isDarkMode,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    final weekDays = isArabic
        ? [
            'السبت',
            'الأحد',
            'الاثنين',
            'الثلاثاء',
            'الأربعاء',
            'الخميس',
            'الجمعة',
          ]
        : ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    final dayNumbers = ['14', '15', '16', '17', '18', '19', '20'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isArabic)
              Text(
                AppStrings.weekDaysEn,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            if (isArabic)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaskListScreen(),
                    ),
                  ).then((_) => setState(() {}));
                },
                child: Text(
                  AppStrings.viewAllAr,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: const Color(0xFF4FC3F7),
                  ),
                ),
              ),
            if (!isArabic)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaskListScreen(),
                    ),
                  ).then((_) => setState(() {}));
                },
                child: Text(
                  AppStrings.viewAllEn,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: const Color(0xFF4FC3F7),
                  ),
                ),
              ),
            if (isArabic)
              Text(
                AppStrings.weekDaysAr,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (index) {
              final isSelected = index == _selectedDayIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDayIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0D7377) : cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        weekDays[index],
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: isSelected ? Colors.white : subTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dayNumbers[index],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : textColor,
                        ),
                      ),
                      if (index == 1)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF0D7377),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayTasksSection(
    bool isArabic,
    List<Task> tasks,
    bool isDarkMode,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Column(
      crossAxisAlignment: isArabic
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? AppStrings.todayTasksAr : AppStrings.todayTasksEn,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        ...tasks
            .map(
              (task) => _buildTaskCard(
                isArabic,
                task,
                isDarkMode,
                cardColor,
                textColor,
                subTextColor,
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildTaskCard(
    bool isArabic,
    Task task,
    bool isDarkMode,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    final categoryColor = _getCategoryColor(task.category);
    final categoryIcon = _getCategoryIcon(task.category);
    final timeStr =
        '${task.dateTime.hour.toString().padLeft(2, '0')}:${task.dateTime.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.priority == 3 ? Colors.orange : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () {
              setState(() {
                task.isCompleted = !task.isCompleted;
                if (task.isCompleted) {
                  task.completedAt = DateTime.now();
                } else {
                  task.completedAt = null;
                }
                HiveService.updateTask(task);
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted
                      ? const Color(0xFF0D7377)
                      : subTextColor,
                  width: 2,
                ),
                color: task.isCompleted
                    ? const Color(0xFF0D7377)
                    : Colors.transparent,
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          // Category Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(categoryIcon, color: categoryColor, size: 20),
          ),

          const SizedBox(width: 12),

          // Task Info
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: subTextColor),
                    const SizedBox(width: 4),
                    Text(
                      timeStr,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: subTextColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (task.priority == 3)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isArabic ? AppStrings.urgentAr : AppStrings.urgentEn,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // More Menu
          IconButton(
            onPressed: () {
              _showTaskMenu(context, task);
            },
            icon: Icon(Icons.more_vert, color: subTextColor),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'work':
        return const Color(0xFF2196F3);
      case 'personal':
        return const Color(0xFFFF9800);
      case 'study':
        return const Color(0xFF1976D2);
      case 'health':
        return const Color(0xFF4CAF50);
      case 'shopping':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'work':
        return Icons.work_outline;
      case 'personal':
        return Icons.person_outline;
      case 'study':
        return Icons.school_outlined;
      case 'health':
        return Icons.favorite_outline;
      case 'shopping':
        return Icons.shopping_cart_outlined;
      default:
        return Icons.task_outlined;
    }
  }

  void _showTaskMenu(BuildContext context, Task task) {
    final isArabic = Provider.of<LocaleProvider>(
      context,
      listen: false,
    ).isArabic;
    final isDarkMode = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;
    final bgColor = isDarkMode ? const Color(0xFF1B263B) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: textColor),
                title: Text(
                  isArabic ? AppStrings.editTaskAr : AppStrings.editTaskEn,
                  style: TextStyle(color: textColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(task: task),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  isArabic ? AppStrings.deleteTaskAr : AppStrings.deleteTaskEn,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  HiveService.deleteTask(task.id);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation(
    bool isArabic,
    bool isDarkMode,
    Color cardColor,
    Color subTextColor,
  ) {
    return BottomAppBar(
      color: cardColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              Icons.home,
              isArabic ? AppStrings.homeAr : AppStrings.homeEn,
              0,
              isArabic,
              subTextColor,
            ),
            _buildNavItem(
              Icons.calendar_today,
              isArabic ? AppStrings.calendarAr : AppStrings.calendarEn,
              1,
              isArabic,
              subTextColor,
            ),
            const SizedBox(width: 40), // Space for FAB
            _buildNavItem(
              Icons.bar_chart,
              isArabic ? AppStrings.statisticsAr : AppStrings.statisticsEn,
              2,
              isArabic,
              subTextColor,
            ),
            _buildNavItem(
              Icons.settings,
              isArabic ? AppStrings.settingsAr : AppStrings.settingsEn,
              3,
              isArabic,
              subTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    bool isArabic,
    Color subTextColor,
  ) {
    final isSelected = _selectedBottomIndex == index;
    return GestureDetector(
      onTap: () {
        // Don't navigate if already on home (index 0)
        if (index == 0) {
          setState(() {
            _selectedBottomIndex = 0;
          });
          return;
        }

        setState(() {
          _selectedBottomIndex = index;
        });

        // Navigate based on index
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CalendarScreen()),
          ).then((_) {
            setState(() {
              _selectedBottomIndex = 0; // Reset to home when returning
            });
          });
        } else if (index == 2) {
          // Statistics - show simple dialog for now
          _showStatisticsDialog();
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          ).then((_) {
            setState(() {
              _selectedBottomIndex = 0; // Reset to home when returning
            });
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF0D7377) : subTextColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 10,
              color: isSelected ? const Color(0xFF0D7377) : subTextColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog() {
    final total = HiveService.getTotalTasksCount();
    final completed = HiveService.getCompletedTasksCount();
    final pending = HiveService.getPendingTasksCount();
    final percentage = total > 0 ? ((completed / total) * 100).toInt() : 0;

    final isDarkMode = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;
    final bgColor = isDarkMode ? const Color(0xFF1B263B) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        title: Text('الإحصائيات', style: GoogleFonts.cairo(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatItem(
              'إجمالي المهام',
              total.toString(),
              textColor,
              subTextColor,
            ),
            _buildStatItem(
              'المهام المكتملة',
              completed.toString(),
              textColor,
              subTextColor,
            ),
            _buildStatItem(
              'المهام المعلقة',
              pending.toString(),
              textColor,
              subTextColor,
            ),
            _buildStatItem(
              'نسبة الإنجاز',
              '$percentage%',
              textColor,
              subTextColor,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إغلاق',
              style: GoogleFonts.cairo(color: const Color(0xFF0D7377)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    Color textColor,
    Color? subTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.cairo(color: subTextColor)),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskSearchDelegate extends SearchDelegate {
  final bool isArabic;

  TaskSearchDelegate(this.isArabic);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final allTasks = HiveService.getAllTasks();
    final results = allTasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          isArabic ? 'لا توجد نتائج' : 'No results found',
          style: GoogleFonts.cairo(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final task = results[index];
        return ListTile(
          title: Text(task.title, style: GoogleFonts.cairo()),
          subtitle: Text(
            '${task.dateTime.hour}:${task.dateTime.minute.toString().padLeft(2, '0')}',
            style: GoogleFonts.poppins(),
          ),
          leading: const Icon(Icons.task_alt),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(task: task),
              ),
            );
          },
        );
      },
    );
  }
}
