import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/localization/locale_provider.dart';
import '../../data/local/hive_service.dart';
import '../../data/models/task_model.dart';
import '../../core/services/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task; // null for add, non-null for edit

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedCategory = 'work';
  int _selectedPriority = 1;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.task!.dateTime);
      _selectedCategory = widget.task!.category;
      _selectedPriority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;
    final isEditing = widget.task != null;

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
        title: Column(
          children: [
            Text(
              isEditing
                  ? (isArabic ? AppStrings.editTaskAr : AppStrings.editTaskEn)
                  : (isArabic ? AppStrings.addTaskAr : AppStrings.addTaskEn),
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              isArabic
                  ? 'خطط ليومك بذكاء وتتبع أهدافك'
                  : 'Plan your day smartly',
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[400]),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Field
            _buildSectionTitle(
              isArabic ? AppStrings.taskTitleAr : AppStrings.taskTitleEn,
              isArabic,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _titleController,
              hint: isArabic
                  ? AppStrings.taskTitleHintAr
                  : AppStrings.taskTitleHintEn,
              isArabic: isArabic,
            ),

            const SizedBox(height: 24),

            // Description Field
            _buildSectionTitle(
              isArabic
                  ? AppStrings.taskDescriptionAr
                  : AppStrings.taskDescriptionEn,
              isArabic,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _descriptionController,
              hint: isArabic
                  ? AppStrings.taskDescriptionHintAr
                  : AppStrings.taskDescriptionHintEn,
              isArabic: isArabic,
              maxLines: 4,
            ),

            const SizedBox(height: 24),

            // Smart Reminders Section
            _buildSectionTitle(
              isArabic
                  ? AppStrings.smartRemindersAr
                  : AppStrings.smartRemindersEn,
              isArabic,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDateTimePicker(
                    icon: Icons.calendar_today,
                    label: isArabic ? AppStrings.dateAr : AppStrings.dateEn,
                    value:
                        '${_selectedDate.day} ${_getMonthName(_selectedDate.month, isArabic)}',
                    color: const Color(0xFF2196F3),
                    onTap: () => _selectDate(context),
                    isArabic: isArabic,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateTimePicker(
                    icon: Icons.access_time,
                    label: isArabic ? AppStrings.timeAr : AppStrings.timeEn,
                    value: _selectedTime.format(context),
                    color: const Color(0xFF4FC3F7),
                    onTap: () => _selectTime(context),
                    isArabic: isArabic,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Category Selection
            _buildSectionTitle(
              isArabic ? AppStrings.categoryAr : AppStrings.categoryEn,
              isArabic,
            ),
            const SizedBox(height: 12),
            _buildCategorySelection(isArabic),

            const SizedBox(height: 24),

            // Priority Selection
            _buildSectionTitle(
              isArabic ? AppStrings.priorityAr : AppStrings.priorityEn,
              isArabic,
            ),
            const SizedBox(height: 12),
            _buildPrioritySelection(isArabic),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D7377),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      isEditing
                          ? (isArabic
                                ? AppStrings.updateTaskAr
                                : AppStrings.updateTaskEn)
                          : (isArabic
                                ? AppStrings.saveTaskAr
                                : AppStrings.saveTaskEn),
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isArabic) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: isArabic ? TextAlign.right : TextAlign.left,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isArabic,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        style: GoogleFonts.cairo(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
    required bool isArabic,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B263B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isArabic
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: isArabic
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (!isArabic) ...[
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: GoogleFonts.cairo(fontSize: 12, color: color),
                ),
                if (isArabic) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: color, size: 20),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelection(bool isArabic) {
    final categories = [
      {
        'id': 'work',
        'nameAr': AppStrings.workAr,
        'nameEn': AppStrings.workEn,
        'icon': Icons.work_outline,
      },
      {
        'id': 'personal',
        'nameAr': AppStrings.personalAr,
        'nameEn': AppStrings.personalEn,
        'icon': Icons.person_outline,
      },
      {
        'id': 'health',
        'nameAr': AppStrings.healthAr,
        'nameEn': AppStrings.healthEn,
        'icon': Icons.favorite_outline,
      },
      {
        'id': 'shopping',
        'nameAr': AppStrings.shoppingAr,
        'nameEn': AppStrings.shoppingEn,
        'icon': Icons.shopping_cart_outlined,
      },
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((category) {
        final isSelected = _selectedCategory == category['id'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category['id'] as String;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0D7377)
                  : const Color(0xFF1B263B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  category['icon'] as IconData,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isArabic
                      ? category['nameAr'] as String
                      : category['nameEn'] as String,
                  style: GoogleFonts.cairo(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrioritySelection(bool isArabic) {
    final priorities = [
      {
        'value': 1,
        'nameAr': AppStrings.normalAr,
        'nameEn': AppStrings.normalEn,
      },
      {
        'value': 2,
        'nameAr': AppStrings.mediumAr,
        'nameEn': AppStrings.mediumEn,
      },
      {'value': 3, 'nameAr': AppStrings.highAr, 'nameEn': AppStrings.highEn},
    ];

    return Row(
      children: priorities.map((priority) {
        final isSelected = _selectedPriority == priority['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPriority = priority['value'] as int;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0D7377)
                    : const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isArabic
                    ? priority['nameAr'] as String
                    : priority['nameEn'] as String,
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF0D7377),
              surface: Color(0xFF1B263B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF0D7377),
              surface: Color(0xFF1B263B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _getMonthName(int month, bool isArabic) {
    if (isArabic) {
      const months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];
      return months[month - 1];
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return months[month - 1];
    }
  }

  void _saveTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (widget.task != null) {
      // Update existing task
      widget.task!.title = _titleController.text;
      widget.task!.description = _descriptionController.text;
      widget.task!.dateTime = dateTime;
      widget.task!.category = _selectedCategory;
      widget.task!.priority = _selectedPriority;
      await widget.task!.save();
    } else {
      // Create new task
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        dateTime: dateTime,
        category: _selectedCategory,
        priority: _selectedPriority,
        createdAt: DateTime.now(),
      );
      await HiveService.addTask(task);

      // Schedule notifications
      try {
        await NotificationService.scheduleTaskNotifications(
          taskId: int.parse(task.id),
          title: task.title,
          dueTime: task.dateTime,
        );
      } catch (e) {
        debugPrint('Error scheduling notification: $e');
      }
    }

    if (widget.task != null) {
      // Re-schedule for updated task
      try {
        await NotificationService.scheduleTaskNotifications(
          taskId: int.parse(widget.task!.id),
          title: widget.task!.title,
          dueTime: widget.task!.dateTime,
        );
      } catch (e) {
        debugPrint('Error scheduling notification: $e');
      }
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}
