import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/localization/locale_provider.dart';
import '../../data/local/hive_service.dart';
import '../../data/models/task_model.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _selectedCategory = 'all';
  
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        title: Text(
          isArabic ? AppStrings.taskListAr : AppStrings.taskListEn,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            isArabic ? Icons.arrow_forward : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Category Filters
          _buildCategoryFilters(isArabic),
          
          // Task List
          Expanded(
            child: _buildTaskList(isArabic),
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

  Widget _buildCategoryFilters(bool isArabic) {
    final categories = [
      {'id': 'all', 'nameAr': AppStrings.allAr, 'nameEn': AppStrings.allEn},
      {'id': 'work', 'nameAr': AppStrings.workAr, 'nameEn': AppStrings.workEn},
      {'id': 'personal', 'nameAr': AppStrings.personalAr, 'nameEn': AppStrings.personalEn},
      {'id': 'study', 'nameAr': AppStrings.studyAr, 'nameEn': AppStrings.studyEn},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: categories.map((category) {
            final isSelected = _selectedCategory == category['id'];
            final taskCount = _getTaskCountForCategory(category['id']!);
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category['id']!;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0D7377) : const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      isArabic ? category['nameAr']! : category['nameEn']!,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[400],
                      ),
                    ),
                    if (taskCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withOpacity(0.2)
                              : const Color(0xFF0D7377).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          taskCount.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTaskList(bool isArabic) {
    final tasks = _getFilteredTasks();
    
    if (tasks.isEmpty) {
      return _buildEmptyState(isArabic);
    }
    
    // Group tasks by category
    final groupedTasks = <String, List<Task>>{};
    for (var task in tasks) {
      if (!groupedTasks.containsKey(task.category)) {
        groupedTasks[task.category] = [];
      }
      groupedTasks[task.category]!.add(task);
    }
    
    return ListView(
      padding: const EdgeInsets.all(20),
      children: groupedTasks.entries.map((entry) {
        return _buildCategorySection(isArabic, entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildCategorySection(bool isArabic, String category, List<Task> tasks) {
    final categoryName = _getCategoryName(category, isArabic);
    final categoryColor = _getCategoryColor(category);
    final categoryIcon = _getCategoryIcon(category);
    
    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Category Header
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              if (!isArabic) ...[
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
              ],
              Expanded(
                child: Text(
                  categoryName,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
              ),
              if (isArabic) ...[
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(categoryIcon, color: categoryColor, size: 20),
                ),
              ],
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${tasks.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Tasks
        ...tasks.map((task) => _buildTaskCard(isArabic, task)).toList(),
        
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTaskCard(bool isArabic, Task task) {
    final categoryColor = _getCategoryColor(task.category);
    final timeStr = '${task.dateTime.hour.toString().padLeft(2, '0')}:${task.dateTime.minute.toString().padLeft(2, '0')}';
    final dateStr = '${task.dateTime.day}/${task.dateTime.month}';
    
    // Determine status badge
    String? statusText;
    Color? statusColor;
    
    if (task.isCompleted) {
      statusText = isArabic ? 'مكتملة' : 'Completed';
      statusColor = const Color(0xFF4CAF50);
    } else if (task.isToday) {
      if (task.priority == 3) {
        statusText = isArabic ? AppStrings.urgentAr : AppStrings.urgentEn;
        statusColor = Colors.orange;
      }
    } else if (task.isUpcoming) {
      statusText = isArabic ? AppStrings.tomorrowAr : AppStrings.tomorrowEn;
      statusColor = const Color(0xFF2196F3);
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted 
              ? const Color(0xFF4CAF50).withOpacity(0.3)
              : categoryColor.withOpacity(0.3),
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
                        '$timeStr • $dateStr',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                    if (isArabic) ...[
                      Text(
                        '$timeStr • $dateStr',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                    ],
                    if (statusText != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor!.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusText,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task_alt,
              size: 60,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isArabic ? AppStrings.allDoneAr : AppStrings.allDoneEn,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic ? AppStrings.noTasksAr : AppStrings.noTasksEn,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              // Navigate to add task
            },
            child: Text(
              isArabic ? AppStrings.addNewTaskAr : AppStrings.addNewTaskEn,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: const Color(0xFF4FC3F7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Task> _getFilteredTasks() {
    if (_selectedCategory == 'all') {
      return HiveService.getAllTasks();
    } else {
      return HiveService.getTasksByCategory(_selectedCategory);
    }
  }

  int _getTaskCountForCategory(String category) {
    if (category == 'all') {
      return HiveService.getAllTasks().length;
    } else {
      return HiveService.getTasksByCategory(category).length;
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
