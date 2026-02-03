import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/constants/app_strings.dart';
import '../../core/localization/locale_provider.dart';
import '../../data/local/hive_service.dart';
import '../../data/models/task_model.dart';
import '../tasks/add_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;
    
    final selectedDayTasks = HiveService.getTasksByDate(_selectedDay);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        title: Text(
          isArabic ? AppStrings.calendarAr : AppStrings.calendarEn,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
            child: Text(
              isArabic ? AppStrings.todayAr : AppStrings.todayEn,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: const Color(0xFF4FC3F7),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
                weekendStyle: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: GoogleFonts.poppins(color: Colors.white),
                weekendTextStyle: GoogleFonts.poppins(color: Colors.white),
                outsideTextStyle: GoogleFonts.poppins(color: Colors.grey[700]),
                todayDecoration: BoxDecoration(
                  color: const Color(0xFF0D7377).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Color(0xFF0D7377),
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Color(0xFF4FC3F7),
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: (day) {
                final tasks = HiveService.getTasksByDate(day);
                return tasks;
              },
            ),
          ),
          
          // Selected Date Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isArabic)
                  Text(
                    _formatSelectedDate(_selectedDay, isArabic),
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (isArabic)
                  Text(
                    '${selectedDayTasks.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4FC3F7),
                    ),
                  ),
                if (!isArabic)
                  Text(
                    '${selectedDayTasks.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4FC3F7),
                    ),
                  ),
                if (isArabic)
                  Text(
                    _formatSelectedDate(_selectedDay, isArabic),
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tasks List
          Expanded(
            child: selectedDayTasks.isEmpty
                ? _buildEmptyState(isArabic)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: selectedDayTasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskCard(isArabic, selectedDayTasks[index]);
                    },
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

  Widget _buildTaskCard(bool isArabic, Task task) {
    final categoryColor = _getCategoryColor(task.category);
    final categoryIcon = _getCategoryIcon(task.category);
    final timeStr = '${task.dateTime.hour.toString().padLeft(2, '0')}:${task.dateTime.minute.toString().padLeft(2, '0')}';
    final categoryName = _getCategoryName(task.category, isArabic);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: categoryColor.withOpacity(0.3),
          width: 1,
        ),
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
                  color: task.isCompleted ? const Color(0xFF4CAF50) : categoryColor,
                  width: 2,
                ),
                color: task.isCompleted ? const Color(0xFF4CAF50) : Colors.transparent,
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Task Info
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isArabic) ...[
                      Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        timeStr,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          categoryName,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: categoryColor,
                          ),
                        ),
                      ),
                    ],
                    if (isArabic) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          categoryName,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeStr,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                    ],
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
            icon: Icon(Icons.more_vert, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'لا توجد مهام في هذا اليوم' : 'No tasks for this day',
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSelectedDate(DateTime date, bool isArabic) {
    final weekdays = isArabic
        ? ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت']
        : ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    
    final months = isArabic
        ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
        : ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    final weekday = weekdays[date.weekday % 7];
    final month = months[date.month - 1];
    
    if (isArabic) {
      return '$weekday، ${date.day} $month';
    } else {
      return '$weekday, $month ${date.day}';
    }
  }

  String _getCategoryName(String category, bool isArabic) {
    switch (category) {
      case 'work':
        return isArabic ? AppStrings.workAr : AppStrings.workEn;
      case 'personal':
        return isArabic ? AppStrings.personalAr : AppStrings.personalEn;
      case 'study':
        return isArabic ? AppStrings.studyAr : AppStrings.studyEn;
      case 'health':
        return isArabic ? AppStrings.healthAr : AppStrings.healthEn;
      case 'shopping':
        return isArabic ? AppStrings.shoppingAr : AppStrings.shoppingEn;
      default:
        return category;
    }
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
    final isArabic = Provider.of<LocaleProvider>(context, listen: false).isArabic;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B263B),
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
                leading: const Icon(Icons.edit, color: Colors.white),
                title: Text(
                  isArabic ? AppStrings.editTaskAr : AppStrings.editTaskEn,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit task
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  isArabic ? 'حذف المهمة' : 'Delete Task',
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
}
