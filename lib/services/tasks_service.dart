import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TasksService {
  static const String _lastWeekKey = 'tasks_last_week';
  static const String _currentTaskIndexKey = 'tasks_current_index';
  static const String _completedTasksKey = 'tasks_completed';
  
  // Comprehensive list of iOS privacy tasks
  static const List<Task> _tasks = [
    // Camera & Photos Tasks
    Task(
      id: 'camera_1',
      title: 'مراجعة أذونات الكاميرا',
      details: 'فحص التطبيقات التي تطلب الوصول إلى الكاميرا',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > الكاميرا. راجع كل تطبيق وحدد ما إذا كان يحتاج حقاً إلى الوصول إلى الكاميرا. ألغِ الأذونات للتطبيقات التي لا تحتاجها.',
      category: 'الكاميرا والصور',
    ),
    Task(
      id: 'photos_1',
      title: 'تغيير إذن الصور إلى صور محددة',
      details: 'تحديد التطبيقات التي يمكنها الوصول إلى صور محددة فقط',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > الصور. اختر التطبيقات التي تريد تعديل أذوناتها. اختر "صور محددة" بدلاً من "جميع الصور" وحدد الصور التي تريد مشاركتها.',
      category: 'الكاميرا والصور',
    ),
    Task(
      id: 'photos_2',
      title: 'إلغاء أذونات الصور غير الضرورية',
      details: 'إزالة الوصول إلى الصور للتطبيقات التي لا تحتاجها',
      instructions: 'في الإعدادات > الخصوصية والأمان > الصور، ابحث عن التطبيقات التي لا تحتاج إلى الصور (مثل تطبيقات الألعاب أو الأدوات). اضغط على التطبيق واختر "لا شيء" لإلغاء الإذن.',
      category: 'الكاميرا والصور',
    ),

    // Location Services Tasks
    Task(
      id: 'location_1',
      title: 'مراجعة خدمات الموقع',
      details: 'فحص التطبيقات التي تطلب الوصول إلى الموقع',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > خدمات الموقع. راجع كل تطبيق وحدد مستوى الوصول المناسب: "دائماً"، "أثناء استخدام التطبيق"، أو "أبداً".',
      category: 'خدمات الموقع',
    ),
    Task(
      id: 'location_2',
      title: 'تغيير دقة الموقع للتطبيقات',
      details: 'استخدام الموقع التقريبي بدلاً من الدقيق',
      instructions: 'في الإعدادات > الخصوصية والأمان > خدمات الموقع، اختر التطبيقات التي لا تحتاج إلى موقع دقيق (مثل تطبيقات الطقس). اضغط على التطبيق واختر "موقع تقريبي" بدلاً من "موقع دقيق".',
      category: 'خدمات الموقع',
    ),
    Task(
      id: 'location_3',
      title: 'إيقاف خدمات الموقع مؤقتاً',
      details: 'تعلم كيفية إيقاف خدمات الموقع عند عدم الحاجة',
      instructions: 'اسحب من أعلى الشاشة لفتح مركز التحكم. اضغط على أيقونة الموقع لإيقاف خدمات الموقع مؤقتاً. يمكنك أيضاً الذهاب إلى الإعدادات > الخصوصية والأمان > خدمات الموقع وإيقاف المفتاح الرئيسي.',
      category: 'خدمات الموقع',
    ),

    // Microphone Tasks
    Task(
      id: 'microphone_1',
      title: 'مراجعة أذونات الميكروفون',
      details: 'فحص التطبيقات التي تطلب الوصول إلى الميكروفون',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > الميكروفون. راجع كل تطبيق وحدد ما إذا كان يحتاج حقاً إلى الميكروفون. ألغِ الأذونات للتطبيقات التي تستخدم الكتابة فقط.',
      category: 'الميكروفون والصوت',
    ),
    Task(
      id: 'microphone_2',
      title: 'إلغاء أذونات الميكروفون غير الضرورية',
      details: 'إزالة الوصول إلى الميكروفون للتطبيقات غير الضرورية',
      instructions: 'في الإعدادات > الخصوصية والأمان > الميكروفون، ابحث عن التطبيقات التي لا تحتاج إلى الميكروفون (مثل تطبيقات القراءة أو الأدوات). اضغط على التطبيق وألغِ الإذن.',
      category: 'الميكروفون والصوت',
    ),

    // Contacts & Calendar Tasks
    Task(
      id: 'contacts_1',
      title: 'مراجعة أذونات جهات الاتصال',
      details: 'فحص التطبيقات التي تطلب الوصول إلى جهات الاتصال',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > جهات الاتصال. راجع كل تطبيق وحدد ما إذا كان يحتاج حقاً إلى جهات الاتصال. ألغِ الأذونات للتطبيقات التي لا تحتاجها (مثل تطبيقات الألعاب).',
      category: 'جهات الاتصال والتقويم',
    ),
    Task(
      id: 'calendar_1',
      title: 'مراجعة أذونات التقويم',
      details: 'فحص التطبيقات التي تطلب الوصول إلى التقويم',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > التقويم. راجع كل تطبيق وحدد ما إذا كان يحتاج حقاً إلى التقويم. ألغِ الأذونات للتطبيقات التي لا تحتاجها.',
      category: 'جهات الاتصال والتقويم',
    ),

    // Notifications Tasks
    Task(
      id: 'notifications_1',
      title: 'تخصيص الإشعارات',
      details: 'تخصيص الإشعارات لكل تطبيق على حدة',
      instructions: 'اذهب إلى الإعدادات > الإشعارات. اختر التطبيق الذي تريد تخصيص إشعاراته. يمكنك إيقاف الإشعارات، تغيير الصوت، أو تخصيص وقت الإشعارات.',
      category: 'الإشعارات',
    ),
    Task(
      id: 'notifications_2',
      title: 'إلغاء الإشعارات المزعجة',
      details: 'إيقاف الإشعارات للتطبيقات التي ترسل إشعارات مزعجة',
      instructions: 'في الإعدادات > الإشعارات، ابحث عن التطبيقات التي ترسل إشعارات مزعجة أو غير مفيدة. اضغط على التطبيق وأوقف الإشعارات أو قلل من تكرارها.',
      category: 'الإشعارات',
    ),

    // Bluetooth & WiFi Tasks
    Task(
      id: 'bluetooth_1',
      title: 'مراجعة أذونات البلوتوث',
      details: 'فحص التطبيقات التي تطلب الوصول إلى البلوتوث',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > البلوتوث. راجع كل تطبيق وحدد ما إذا كان يحتاج حقاً إلى البلوتوث. ألغِ الأذونات للتطبيقات التي لا تحتاجها.',
      category: 'البلوتوث والواي فاي',
    ),
    Task(
      id: 'wifi_1',
      title: 'مراجعة أذونات الشبكة',
      details: 'فحص التطبيقات التي تطلب الوصول إلى الشبكة',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > الشبكة المحلية. راجع كل تطبيق وحدد ما إذا كان يحتاج حقاً إلى الوصول إلى الشبكة المحلية. ألغِ الأذونات للتطبيقات التي لا تحتاجها.',
      category: 'البلوتوث والواي فاي',
    ),

    // Health & Fitness Tasks
    Task(
      id: 'health_1',
      title: 'مراجعة أذونات الصحة',
      details: 'فحص التطبيقات التي تطلب الوصول إلى بيانات الصحة',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > الصحة. راجع كل تطبيق وحدد البيانات الصحية التي تريد مشاركتها. ألغِ الأذونات للتطبيقات التي لا تثق بها.',
      category: 'الصحة واللياقة',
    ),
    Task(
      id: 'health_2',
      title: 'تخصيص بيانات الصحة المشتركة',
      details: 'تحديد البيانات الصحية التي تريد مشاركتها مع كل تطبيق',
      instructions: 'في الإعدادات > الخصوصية والأمان > الصحة، اختر التطبيق الذي تريد تخصيص بياناته. حدد البيانات الصحية التي تريد مشاركتها وألغِ الباقي.',
      category: 'الصحة واللياقة',
    ),

    // Files & Documents Tasks
    Task(
      id: 'files_1',
      title: 'مراجعة أذونات الملفات',
      details: 'فحص التطبيقات التي تطلب الوصول إلى الملفات',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > الملفات والمجلدات. راجع كل تطبيق وحدد المجلدات التي يمكنه الوصول إليها. ألغِ الأذونات للمجلدات غير الضرورية.',
      category: 'الملفات والمستندات',
    ),
    Task(
      id: 'files_2',
      title: 'تقييد الوصول إلى المجلدات',
      details: 'منع التطبيقات من الوصول إلى مجلدات معينة',
      instructions: 'في الإعدادات > الخصوصية والأمان > الملفات والمجلدات، اختر التطبيق الذي تريد تقييد وصوله. ألغِ الأذونات للمجلدات الحساسة مثل الصور أو المستندات.',
      category: 'الملفات والمستندات',
    ),

    // App Tracking Tasks
    Task(
      id: 'tracking_1',
      title: 'مراجعة تتبع التطبيقات',
      details: 'فحص التطبيقات التي تطلب تتبعك عبر التطبيقات الأخرى',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان > تتبع التطبيقات. راجع كل تطبيق وحدد ما إذا كنت تريد السماح له بتتبعك. اختر "طلب عدم التتبع" للتطبيقات التي لا تثق بها.',
      category: 'تتبع التطبيقات',
    ),
    Task(
      id: 'tracking_2',
      title: 'تفعيل طلب عدم التتبع',
      details: 'منع التطبيقات من تتبعك عبر التطبيقات الأخرى',
      instructions: 'في الإعدادات > الخصوصية والأمان > تتبع التطبيقات، فعّل "طلب عدم التتبع". هذا سيمنع التطبيقات من تتبعك عبر التطبيقات الأخرى ويقلل من الإعلانات المستهدفة.',
      category: 'تتبع التطبيقات',
    ),

    // General Privacy Tasks
    Task(
      id: 'general_1',
      title: 'مراجعة شاملة للأذونات',
      details: 'مراجعة جميع أذونات التطبيقات في جهازك',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان. راجع كل قسم (الكاميرا، الميكروفون، الموقع، إلخ) وحدد التطبيقات التي لا تحتاج إلى هذه الأذونات. ألغِ الأذونات غير الضرورية.',
      category: 'الخصوصية العامة',
    ),
    Task(
      id: 'general_2',
      title: 'تحديث التطبيقات',
      details: 'تحديث جميع التطبيقات للحصول على آخر إصلاحات الأمان',
      instructions: 'اذهب إلى App Store > الملف الشخصي. اضغط على "تحديث الكل" لتحديث جميع التطبيقات. أو راجع التطبيقات يدوياً وتحديث المهم منها أولاً.',
      category: 'الخصوصية العامة',
    ),
    Task(
      id: 'general_3',
      title: 'تفعيل المصادقة الثنائية',
      details: 'تفعيل المصادقة الثنائية لحماية حساباتك',
      instructions: 'اذهب إلى الإعدادات > [اسمك] > تسجيل الدخول والأمان. فعّل "المصادقة الثنائية" واتبع التعليمات لإعدادها. هذا سيحمي حساباتك من الوصول غير المصرح به.',
      category: 'الخصوصية العامة',
    ),
    Task(
      id: 'general_4',
      title: 'مراجعة إعدادات الخصوصية',
      details: 'مراجعة جميع إعدادات الخصوصية في جهازك',
      instructions: 'اذهب إلى الإعدادات > الخصوصية والأمان. راجع كل قسم وتأكد من أن الإعدادات تناسب احتياجاتك. فعّل الميزات التي تحسن الخصوصية وأوقف الميزات التي لا تحتاجها.',
      category: 'الخصوصية العامة',
    ),
    Task(
      id: 'general_5',
      title: 'حذف التطبيقات غير المستخدمة',
      details: 'حذف التطبيقات التي لا تستخدمها لتقليل المخاطر',
      instructions: 'اضغط مطولاً على أيقونة التطبيق واختر "حذف التطبيق". راجع جميع التطبيقات في جهازك واحذف التي لا تستخدمها. هذا سيقلل من المخاطر الأمنية ويوفر مساحة التخزين.',
      category: 'الخصوصية العامة',
    ),
    Task(
      id: 'general_6',
      title: 'مراجعة سياسات الخصوصية',
      details: 'قراءة سياسات الخصوصية للتطبيقات المهمة',
      instructions: 'اذهب إلى App Store وابحث عن التطبيقات المهمة. اقرأ سياسة الخصوصية لكل تطبيق لفهم كيفية استخدام بياناتك. تجنب التطبيقات التي تجمع بيانات أكثر من اللازم.',
      category: 'الخصوصية العامة',
    ),
  ];

  // Get current week number
  static int _getCurrentWeek() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final daysSinceStart = now.difference(startOfYear).inDays;
    return (daysSinceStart / 7).floor();
  }

  // Get tasks for current week
  static Future<List<Task>> getWeeklyTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final currentWeek = _getCurrentWeek();
    final lastWeek = prefs.getInt(_lastWeekKey) ?? -1;
    int currentIndex = prefs.getInt(_currentTaskIndexKey) ?? 0;

    // If it's a new week, move to next set of tasks
    if (currentWeek != lastWeek) {
      currentIndex += 3; // Show 3 tasks per week
      
      // If we've shown all tasks, start over
      if (currentIndex >= _tasks.length) {
        currentIndex = 0;
      }
      
      // Save the new week and index
      await prefs.setInt(_lastWeekKey, currentWeek);
      await prefs.setInt(_currentTaskIndexKey, currentIndex);
    }

    // Get 3 tasks starting from current index
    final tasks = <Task>[];
    for (int i = 0; i < 3; i++) {
      final taskIndex = (currentIndex + i) % _tasks.length;
      tasks.add(_tasks[taskIndex]);
    }

    return tasks;
  }

  // Mark task as completed
  static Future<void> markTaskCompleted(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final completedTasks = prefs.getStringList(_completedTasksKey) ?? [];
    if (!completedTasks.contains(taskId)) {
      completedTasks.add(taskId);
      await prefs.setStringList(_completedTasksKey, completedTasks);
    }
  }

  // Unmark task as completed
  static Future<void> unmarkTaskCompleted(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final completedTasks = prefs.getStringList(_completedTasksKey) ?? [];
    completedTasks.remove(taskId);
    await prefs.setStringList(_completedTasksKey, completedTasks);
  }

  // Check if task is completed
  static Future<bool> isTaskCompleted(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final completedTasks = prefs.getStringList(_completedTasksKey) ?? [];
    return completedTasks.contains(taskId);
  }

  // Check if all current week tasks are completed
  static Future<bool> areAllWeeklyTasksCompleted() async {
    final weeklyTasks = await getWeeklyTasks();
    for (final task in weeklyTasks) {
      if (!await isTaskCompleted(task.id)) {
        return false;
      }
    }
    return true;
  }

  // Get completion status for current week tasks
  static Future<List<bool>> getWeeklyTasksCompletionStatus() async {
    final weeklyTasks = await getWeeklyTasks();
    final status = <bool>[];
    for (final task in weeklyTasks) {
      status.add(await isTaskCompleted(task.id));
    }
    return status;
  }

  // Get all tasks (for admin purposes)
  static List<Task> getAllTasks() {
    return List.from(_tasks);
  }

  // Get completed tasks count
  static Future<int> getCompletedTasksCount() async {
    final prefs = await SharedPreferences.getInstance();
    final completedTasks = prefs.getStringList(_completedTasksKey) ?? [];
    return completedTasks.length;
  }

  // Reset tasks rotation (for testing)
  static Future<void> resetTasksRotation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastWeekKey);
    await prefs.remove(_currentTaskIndexKey);
  }

  // Reset all completed tasks (for testing)
  static Future<void> resetCompletedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedTasksKey);
  }

  // Get current task index (for debugging)
  static Future<int> getCurrentTaskIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentTaskIndexKey) ?? 0;
  }

  // Get current week number (for debugging)
  static int getCurrentWeekNumber() {
    return _getCurrentWeek();
  }

  // Regenerate current week tasks (reset to next set of tasks)
  static Future<void> regenerateCurrentWeekTasks() async {
    final prefs = await SharedPreferences.getInstance();
    int currentIndex = prefs.getInt(_currentTaskIndexKey) ?? 0;
    
    // Move to next set of tasks
    currentIndex += 3;
    
    // If we've shown all tasks, start over
    if (currentIndex >= _tasks.length) {
      currentIndex = 0;
    }
    
    // Save the new index
    await prefs.setInt(_currentTaskIndexKey, currentIndex);
    
    // Clear completed tasks for the new set
    final weeklyTasks = await getWeeklyTasks();
    for (final task in weeklyTasks) {
      await unmarkTaskCompleted(task.id);
    }
  }
}
