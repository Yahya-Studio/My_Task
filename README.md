# 📝 مهامي | My Task

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Hive](https://img.shields.io/badge/Database-Hive%20(Local)-FDB813?style=for-the-badge&logo=apache-hive&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-orange?style=for-the-badge)

**تطبيق حديث ومتكامل لإدارة المهام والإنتاجية اليومية مبني باستخدام Flutter بتصميم عصري ودعم كامل للغتين العربية والإنجليزية.**

*A modern, cross-platform productivity and task management application built with Flutter, featuring full Arabic (RTL) & English localization, offline-first architecture, and smart scheduling.*

[المميزات](#-المميزات-الرئيسية--key-features) •
[التقنيات المستخدمة](#-التقنيات-المستخدمة--tech-stack) •
[طريقة التثبيت والتشغيل](#-طريقة-التثبيت-والتشغيل--getting-started) •
[إعداد متغيرات البيئة](#-إعداد-متغيرات-البيئة--environment-configuration) •
[ربط قاعدة البيانات سحابياً (Supabase)](#-ربط-قاعدة-بيانات-سحابية-مثل-supabase--cloud-database-integration) •
[هيكلية المشروع](#-هيكلية-المشروع--project-structure)

</div>

---

## 🌟 المميزات الرئيسية | Key Features

- 📱 **متعدد المنصات (Cross-Platform):** يعمل بسلاسة على Android, iOS, Web, Windows, macOS, و Linux.
- 🌐 **دعم كامل للغة العربية (Bilingual & RTL):** واجهة ثنائية اللغة (العربية والإنجليزية) مع توجيه حقيقي لكافة العناصر (RTL/LTR).
- ⚡ **أولوية للعمل بدون إنترنت (Offline-First):** تخزين محلي فائق السرعة عبر قاعدة بيانات **Hive NoSQL** لحماية خصوصية بياناتك وضمان العمل دون اتصال بالإنترنت.
- 🎨 **تصميم جذاب وثيمات مخصصة (Material Design 3):** دعم الوضع الداكن (Dark Mode) والوضع الفاتح (Light Mode) مع ألوان مريحة للعين.
- 📅 **تقويم تفاعلي (Interactive Calendar):** استعراض المهام حسب الأيام والشهور مع مؤشرات بصرية لمواعيد الإنجاز.
- ⏰ **تنبيهات وإشعارات ذكية (Smart Notifications):** تنبيهات دقيقة قبل موعد المهمة (قبل 30 دقيقة وفي وقت الاستحقاق) مع إدارة صلاحيات النظام.
- 📊 **إحصائيات الإنجاز (Productivity Tracking):** لوحة معلومات تقدم نسب إنجاز المهام اليومية والإجمالية لتحفيز الاستمرارية.
- 🏷️ **تصنيفات ومستويات أولوية:** تنظيم المهام في فئات (عمل، شخصي، دراسة، صحة، تسوق) وتحديد الأولوية (عادي، متوسط، عالي).

---

## 🛠 التقنيات المستخدمة | Tech Stack

| المجال | التقنية / الحزمة | الوصف |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev/) | بناء واجهات التطبيق متعددة المنصات بكود واحد |
| **Language** | [Dart](https://dart.dev/) | لغة البرمجة الحديثة المعتمدة في Flutter |
| **State Management** | [`provider`](https://pub.dev/packages/provider) | إدارة حالة التطبيق (الثيمات، اللغات، البيانات) |
| **Local Database** | [`hive`](https://pub.dev/packages/hive) & [`hive_flutter`](https://pub.dev/packages/hive_flutter) | قاعدة بيانات NoSQL سريعة وخفيفة للتخزين المحلي |
| **Notifications** | [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications) | جدولة الإشعارات والتنبيهات المحلية |
| **Calendar** | [`table_calendar`](https://pub.dev/packages/table_calendar) | تقويم مرن وتفاعلي لتنظيم المواعيد |
| **Typography & UI** | [`google_fonts`](https://pub.dev/packages/google_fonts), [`flutter_svg`](https://pub.dev/packages/flutter_svg) | خطوط أنيقة وتوافق كامل مع خط Cairo وتنسيق SVG |
| **Storage & Preferences** | [`shared_preferences`](https://pub.dev/packages/shared_preferences), [`path_provider`](https://pub.dev/packages/path_provider) | حفظ الإعدادات المفضلة ومسارات الملفات |

---

## 🚀 طريقة التثبيت والتشغيل | Getting Started

### 📋 المتطلبات المسبقة (Prerequisites)
1. تثبيت بيئة **Flutter SDK** (الإصدار `3.10.0` أو أحدث): [دليل التثبيت الرسمي](https://docs.flutter.dev/get-started/install).
2. تثبيت **Git**.
3. بيئة تطوير مناسبة: **VS Code** أو **Android Studio** مع تثبيت إضافة Flutter/Dart.

### 📥 خطوات التثبيت (Installation Steps)

1. **استنساخ المستودع (Clone the Repository):**
   ```bash
   git clone https://github.com/Yahya-Studio/My_Task.git
   cd My_Task
   ```

2. **تثبيت الحزم والتبعيات (Install Dependencies):**
   ```bash
   flutter pub get
   ```

3. **توليد محولات Hive (إن لزم الأمر):**
   في حال قمت بتعديل نماذج البيانات (`Task` أو `AppNotification`)، يمكنك إعادة إنشاء المحولات عبر:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **تشغيل التطبيق (Run Application):**
   * للتشغيل على جهازك المتصل أو المحاكي:
     ```bash
     flutter run
     ```
   * للتشغيل على المتصفح (Web):
     ```bash
     flutter run -d chrome
     ```

---

## 🔐 إعداد متغيرات البيئة | Environment Configuration

التطبيق مصمم حالياً ليعمل محلياً (Offline-First) بنسبة 100% دون الحاجة لأي مفاتيح خارجية. ومع ذلك، تم تجهيز التطبيق لدعم أي خدمات سحابية مستقبلاً عبر ملف بيئة موحّد:

1. انسخ ملف النموذج `.env.example` إلى ملف جديد باسم `.env`:
   ```bash
   cp .env.example .env
   ```
2. افتح ملف `.env` واملأ المفاتيح المطلوبة وفقاً لاحتياجك (مثل مفاتيح مزامنة السحابة أو الإشعارات السحابية).
3. ⚠️ **ملاحظة أمنية هامة:** ملف `.env` مدرج في `.gitignore` لمنع رفعه تلقائياً وحماية أسرارك من النشر العام.

---

## ☁️ ربط قاعدة بيانات سحابية (مثل Supabase) | Cloud Database Integration

إذا أردت تفعيل المزامنة السحابية (Cloud Sync) ومشاركة المهام بين أجهزة متعددة باستخدام **Supabase**، اتبع الخطوات التالية:

### 1. الحصول على المفاتيح من Supabase
1. توجه إلى [Supabase.com](https://supabase.com/) وقم بإنشاء حساب ومشروع جديد مجاناً.
2. من القائمة الجانبية للمشروع، ادخل إلى **Project Settings** > **API**.
3. ستجد:
   * **Project URL**: رابط المشروع الخاص بك.
   * **Project API Keys** -> انسخ المفتاح العام **`anon` `public`**.
4. ضع هذه القيم في ملف `.env`:
   ```env
   SUPABASE_URL=https://your-project-ref.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6...
   ```

### 2. تثبيت حزمة Supabase في Flutter
أضف الحزمة إلى `pubspec.yaml`:
```bash
flutter pub add supabase_flutter
```

### 3. إنشاء جدول المهام في Supabase SQL Editor
قم بتنفيذ الاستعلام التالي في **SQL Editor** لإنشاء جدول المهام:
```sql
create table tasks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  date_time timestamptz not null,
  category text not null default 'personal',
  priority int default 1,
  is_completed boolean default false,
  created_at timestamptz default now()
);

-- تفعيل أمان مستوى الصف (Row Level Security)
alter table tasks enable row level security;
create policy "Allow all operations for authenticated users" 
  on tasks for all using (auth.uid() is not null);
```

### 4. تهيئة Supabase في `main.dart`
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة Supabase
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );
  
  // بقية عمليات التهيئة المحلية (Hive, Notifications...)
  await HiveService.init();
  runApp(const MyApp());
}
```

---

## 📁 هيكلية المشروع | Project Structure

```text
my_task/
├── android/                    # إعدادات منصة Android
├── ios/                        # إعدادات منصة iOS
├── web/                        # إعدادات وإضافات الويب
├── lib/
│   ├── main.dart               # نقطة انطلاق التطبيق وإعداد المزودات (Providers)
│   ├── core/                   # الثوابت، الثيمات، الترجمة، والخدمات المركزية
│   │   ├── constants/          # الألوان (AppColors)، المسارات (AppRoutes)، والنصوص (AppStrings)
│   │   ├── localization/       # إدارة اللغات وتبديل الاتجاه (LocaleProvider)
│   │   ├── services/           # خدمة الإشعارات المحلية (NotificationService)
│   │   └── theme/              # ثيمات التطبيق والألوان (AppTheme, ThemeProvider)
│   ├── data/                   # إدارة البيانات والنماذج
│   │   ├── local/              # تهيئة وعمليات Hive (HiveService)
│   │   └── models/             # نماذج البيانات والمحولات (TaskModel, NotificationModel)
│   └── screens/                # شاشات التطبيق
│       ├── splash/             # شاشة البداية (Splash)
│       ├── onboarding/         # شاشات الترحيب والتعريف
│       ├── dashboard/          # لوحة التحكم الرئيسية وقائمة مهام اليوم
│       ├── tasks/              # استعراض المهام وإضافة مهمة جديدة
│       ├── calendar/           # تقويم المهام الشهري
│       ├── notifications/      # شاشة الإشعارات وسجل التنبيهات
│       └── profile/            # الملف الشخصي وإحصائيات الإنتاجية والإعدادات
├── .env.example                # نموذج توضيحي لمتغيرات البيئة
├── .gitignore                  # الملفات المستثناة من التتبع وحماية الأسرار
└── pubspec.yaml                # تبعيات وإعدادات مشروع Flutter
```

---

## 🛡 الخصوصية والأمان | Security & Privacy

* **حماية البيانات:** التطبيق يعمل محلياً ولا يرسل مهامك أو بياناتك الشخصية إلى أي خادم خارجي افتراضياً.
* **الحماية من تسريب الأسرار:** تم تحديث ملف `.gitignore` ليشمل حماية شاملة لملفات `.env`، ملفات التوقيع (`keystore`, `key.properties`)، وملفات الإعدادات السحابية (`google-services.json`, `GoogleService-Info.plist`).

---

## 🤝 المساهمة | Contributing

المساهمات مرحب بها دائماً! إذا كان لديك اقتراح لتحسين التطبيق أو إضافة ميزة جديدة:
1. قم بعمل **Fork** للمشروع.
2. أنشئ فرعاً لميزتك (`git checkout -b feature/AmazingFeature`).
3. سجّل التعديلات (`git commit -m 'Add some AmazingFeature'`).
4. ارفع الفرع (`git push origin feature/AmazingFeature`).
5. افتح **Pull Request**.

---

## 📄 الترخيص | License

هذا المشروع متاح تحت رخصة **MIT**. راجع ملف `LICENSE` للمزيد من التفاصيل.

---

<div align="center">

صُنع بـ ❤️ بواسطة **[Yahya-Studio](https://github.com/Yahya-Studio)**

</div>
