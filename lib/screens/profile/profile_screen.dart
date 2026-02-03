import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_strings.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/local/hive_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _userPhotoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    setState(() {
      _userName = HiveService.getUserName();
      _userPhotoUrl = HiveService.getUserPhotoUrl();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isArabic = localeProvider.isArabic;
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final totalTasks = HiveService.getTotalTasksCount();
    final completedTasks = HiveService.getCompletedTasksCount();
    final completionPercentage = totalTasks > 0
        ? ((completedTasks / totalTasks) * 100).toInt()
        : 0;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0D1B2A)
          : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF0D1B2A) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Auto-mirrors in RTL
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isArabic ? AppStrings.profileAr : AppStrings.profileEn,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileSection(isArabic, isDarkMode),
            const SizedBox(height: 24),
            _buildStatisticsSection(
              isArabic,
              isDarkMode,
              completionPercentage,
              completedTasks,
              totalTasks,
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              isArabic,
              isDarkMode,
              themeProvider,
              localeProvider,
            ),
            const SizedBox(height: 24),
            _buildAccountSection(isArabic, isDarkMode),
            const SizedBox(height: 24),
            _buildLogoutButton(isArabic, isDarkMode),
            const SizedBox(height: 32),
            Text(
              isArabic ? 'الإصدار 2.4.0' : 'Version 2.4.0',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(bool isArabic, bool isDarkMode) {
    ImageProvider imageProvider;
    if (!_userPhotoUrl.startsWith('http') && _userPhotoUrl.isNotEmpty) {
      imageProvider = FileImage(File(_userPhotoUrl));
    } else {
      imageProvider = NetworkImage(
        _userPhotoUrl.isEmpty
            ? ''
            : _userPhotoUrl,
      );
    }

    return GestureDetector(
      onTap: () => _showEditProfileDialog(isArabic, isDarkMode),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1B263B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D7377),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDarkMode
                            ? const Color(0xFF1B263B)
                            : Colors.white,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _userName.isEmpty
                  ? (isArabic ? 'أضف أسمك' : 'Add your name')
                  : _userName,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(
    bool isArabic,
    bool isDarkMode,
    int percentage,
    int completed,
    int total,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1B263B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  isArabic ? 'معدل الإكمال' : 'Completion Rate',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: percentage / 100,
                        strokeWidth: 8,
                        backgroundColor: isDarkMode
                            ? Colors.grey[800]
                            : Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF0D7377),
                        ),
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(width: 1, height: 80, color: Colors.grey[300]),
          Expanded(
            child: Column(
              children: [
                Text(
                  isArabic ? 'المهام المنجزة' : 'Tasks Completed',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completed',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '+12%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    bool isArabic,
    bool isDarkMode,
    ThemeProvider themeProvider,
    LocaleProvider localeProvider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1B263B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // RTL handled by Directionality
        children: [
          Text(
            isArabic ? 'التفضيلات' : 'Preferences',
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.dark_mode,
            iconColor: const Color(0xFF7C4DFF),
            title: isArabic ? 'الوضع الداكن' : 'Dark Mode',
            isArabic: isArabic,
            isDarkMode: isDarkMode,
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
              activeColor: const Color(0xFF0D7377),
            ),
          ),
          const Divider(height: 32),
          _buildSettingItem(
            icon: Icons.language,
            iconColor: const Color(0xFF2196F3),
            title: isArabic ? 'اللغة' : 'Language',
            isArabic: isArabic,
            isDarkMode: isDarkMode,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isArabic ? 'العربية' : 'English',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ), // Auto mirrors? ChevronRight -> Left in RTL? Yes usually.
              ],
            ),
            onTap: () =>
                _showLanguageDialog(isArabic, isDarkMode, localeProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(bool isArabic, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1B263B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // RTL handled by Directionality
        children: [
          Text(
            isArabic ? 'الحساب' : 'Account',
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.person,
            iconColor: const Color(0xFF4FC3F7),
            title: isArabic ? 'المعلومات الشخصية' : 'Personal Information',
            isArabic: isArabic,
            isDarkMode: isDarkMode,
            trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isArabic,
    required bool isDarkMode,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(bool isArabic, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(isArabic, isDarkMode),
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text(
          isArabic ? 'تسجيل الخروج' : 'Logout',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? const Color(0xFF1B263B) : Colors.white,
          foregroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.red.withOpacity(0.3)),
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
    );
  }

  void _showLanguageDialog(
    bool isArabic,
    bool isDarkMode,
    LocaleProvider localeProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1B263B) : Colors.white,
          title: Text(
            isArabic ? 'اختر اللغة' : 'Choose Language',
            style: GoogleFonts.cairo(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'العربية',
                  style: GoogleFonts.cairo(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                leading: Radio<String>(
                  value: 'ar',
                  groupValue: isArabic ? 'ar' : 'en',
                  onChanged: (value) {
                    localeProvider.setLocale(const Locale('ar'));
                    Navigator.pop(context);
                  },
                  activeColor: const Color(0xFF0D7377),
                ),
              ),
              ListTile(
                title: Text(
                  'English',
                  style: GoogleFonts.cairo(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                leading: Radio<String>(
                  value: 'en',
                  groupValue: isArabic ? 'ar' : 'en',
                  onChanged: (value) {
                    localeProvider.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                  activeColor: const Color(0xFF0D7377),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(bool isArabic, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1B263B) : Colors.white,
          title: Text(
            isArabic ? 'تسجيل الخروج' : 'Logout',
            style: GoogleFonts.cairo(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            isArabic
                ? 'هل أنت متأكد من تسجيل الخروج؟'
                : 'Are you sure you want to logout?',
            style: GoogleFonts.cairo(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic ? 'إلغاء' : 'Cancel',
                style: GoogleFonts.cairo(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic ? 'تسجيل الخروج' : 'Logout',
                style: GoogleFonts.cairo(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(bool isArabic, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1B263B) : Colors.white,
          title: Text(
            isArabic ? AppStrings.editProfileAr : AppStrings.editProfileEn,
            style: GoogleFonts.cairo(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: Color(0xFF0D7377),
                ),
                title: Text(
                  isArabic
                      ? AppStrings.changePhotoAr
                      : AppStrings.changePhotoEn,
                  style: GoogleFonts.cairo(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showChangePhotoDialog(isArabic, isDarkMode);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF0D7377)),
                title: Text(
                  isArabic ? AppStrings.editNameAr : AppStrings.editNameEn,
                  style: GoogleFonts.cairo(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showEditNameDialog(isArabic, isDarkMode);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic ? AppStrings.cancelAr : AppStrings.cancelEn,
                style: GoogleFonts.cairo(color: const Color(0xFF0D7377)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditNameDialog(bool isArabic, bool isDarkMode) {
    final nameController = TextEditingController(text: _userName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1B263B) : Colors.white,
          title: Text(
            isArabic ? AppStrings.editNameAr : AppStrings.editNameEn,
            style: GoogleFonts.cairo(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: TextField(
            controller: nameController,
            style: GoogleFonts.cairo(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: isArabic
                  ? AppStrings.enterNameAr
                  : AppStrings.enterNameEn,
              hintStyle: GoogleFonts.cairo(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0D7377)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic ? AppStrings.cancelAr : AppStrings.cancelEn,
                style: GoogleFonts.cairo(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await HiveService.setUserName(nameController.text);
                  _loadUserProfile();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? 'تم حفظ الاسم بنجاح'
                            : 'Name saved successfully',
                        style: GoogleFonts.cairo(),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                isArabic ? AppStrings.saveAr : AppStrings.saveEn,
                style: GoogleFonts.cairo(color: const Color(0xFF0D7377)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangePhotoDialog(bool isArabic, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1B263B) : Colors.white,
          title: Text(
            isArabic ? AppStrings.changePhotoAr : AppStrings.changePhotoEn,
            style: GoogleFonts.cairo(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image, color: Color(0xFF0D7377)),
                title: Text(
                  isArabic ? 'اختر من المعرض' : 'Choose from Gallery',
                  style: GoogleFonts.cairo(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  // Request permissions (Mobile only)
                  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
                    Map<Permission, PermissionStatus> statuses = await [
                      Permission.camera,
                      Permission.storage,
                    ].request();

                    if (!statuses[Permission.camera]!.isGranted &&
                        !statuses[Permission.storage]!.isGranted) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isArabic
                                  ? 'يجب منح صلاحية الوصول للكاميرا والتخزين'
                                  : 'Permission required to access camera/storage',
                              style: GoogleFonts.cairo(),
                            ),
                          ),
                        );
                      }
                      return; // Stop execution if permissions denied
                    }
                  }

                  try {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );

                    if (image != null) {
                      String savedPath = image.path;

                      // On Mobile/Desktop: Copy to app directory
                      if (!kIsWeb) {
                        final appDir = await getApplicationDocumentsDirectory();
                        final fileName =
                            'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
                        final savedImage = await File(
                          image.path,
                        ).copy('${appDir.path}/$fileName');
                        savedPath = savedImage.path;
                      }

                      await HiveService.setUserPhotoUrl(savedPath);
                      _loadUserProfile();

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isArabic
                                  ? 'تم تغيير الصورة بنجاح'
                                  : 'Photo changed successfully',
                              style: GoogleFonts.cairo(),
                            ),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isArabic
                                ? 'حدث خطأ أثناء اختيار الصورة: $e'
                                : 'Error picking image: $e',
                            style: GoogleFonts.cairo(),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic ? AppStrings.cancelAr : AppStrings.cancelEn,
                style: GoogleFonts.cairo(color: const Color(0xFF0D7377)),
              ),
            ),
          ],
        );
      },
    );
  }
}
