import 'package:shared_preferences/shared_preferences.dart';

class TipsService {
  static const String _lastWeekKey = 'tips_last_week';
  static const String _currentTipIndexKey = 'tips_current_index';
  
  // Comprehensive list of iOS permission tips
  static const List<String> _tips = [
    // Camera & Photos
    'يمكنك منح تطبيق صلاحية الوصول إلى صورة واحدة فقط بدلاً من جميع الصور',
    'راجع أذونات الكاميرا بانتظام وألغِ الأذونات غير الضرورية',
    'تطبيقات التصوير قد تطلب الوصول إلى الصور حتى لو لم تكن بحاجة إليها',
    'يمكنك تغيير إذن الصور من "جميع الصور" إلى "صور محددة" في أي وقت',
    
    // Location Services
    'يمكنك تحديد متى تريد مشاركة موقعك: دائماً، أثناء استخدام التطبيق، أو أبداً',
    'تطبيقات الطقس لا تحتاج إلى موقعك الدقيق، يمكنك استخدام الموقع التقريبي',
    'راجع تطبيقات الموقع في الإعدادات وألغِ الأذونات للتطبيقات التي لا تحتاجها',
    'يمكنك إيقاف خدمات الموقع مؤقتاً من مركز التحكم',
    
    // Microphone & Audio
    'تطبيقات المراسلة قد تطلب إذن الميكروفون حتى لو كنت تستخدم الكتابة فقط',
    'راجع أذونات الميكروفون وألغِ الأذونات للتطبيقات التي لا تحتاجها',
    'يمكنك منع التطبيقات من الوصول إلى الميكروفون أثناء المكالمات',
    
    // Contacts & Calendar
    'تطبيقات الألعاب لا تحتاج إلى الوصول إلى جهات الاتصال الخاصة بك',
    'راجع أذونات التقويم وألغِ الأذونات للتطبيقات غير الضرورية',
    'يمكنك منع التطبيقات من إضافة أحداث إلى تقويمك تلقائياً',
    
    // Notifications
    'يمكنك تخصيص الإشعارات لكل تطبيق على حدة',
    'ألغِ الإشعارات للتطبيقات التي ترسل إشعارات مزعجة',
    'استخدم "الوقت الهادئ" لتجنب الإشعارات في أوقات معينة',
    
    // Bluetooth & WiFi
    'تطبيقات الألعاب قد تطلب إذن البلوتوث حتى لو لم تكن بحاجة إليه',
    'راجع أذونات البلوتوث وألغِ الأذونات للتطبيقات غير الضرورية',
    'يمكنك منع التطبيقات من الوصول إلى شبكة الواي فاي',
    
    // Health & Fitness
    'تطبيقات اللياقة البدنية قد تطلب الوصول إلى بيانات صحية حساسة',
    'راجع أذونات الصحة وألغِ الأذونات للتطبيقات التي لا تثق بها',
    'يمكنك تحديد البيانات الصحية التي تريد مشاركتها مع كل تطبيق',
    
    // Files & Documents
    'تطبيقات الملفات قد تطلب الوصول إلى جميع ملفاتك',
    'راجع أذونات الملفات وألغِ الأذونات للتطبيقات غير الضرورية',
    'يمكنك منع التطبيقات من الوصول إلى مجلدات معينة',
    
    // App Tracking
    'يمكنك منع التطبيقات من تتبعك عبر التطبيقات الأخرى',
    'استخدم "طلب عدم التتبع" لتجنب الإعلانات المستهدفة',
    'راجع إعدادات الخصوصية والتتبع بانتظام',
    
    // General Privacy Tips
    'راجع أذونات التطبيقات بانتظام لضمان أمان بياناتك',
    'يمكنك بسهولة إدارة أذونات التطبيقات من إعدادات الخصوصية',
    'لا تمنح أذونات غير ضرورية للتطبيقات الجديدة',
    'اقرأ سياسة الخصوصية قبل منح الأذونات للتطبيقات',
    'استخدم المصادقة الثنائية لحماية حساباتك',
    'تحديث التطبيقات بانتظام للحصول على آخر إصلاحات الأمان',
  ];

  // Get current week number
  static int _getCurrentWeek() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final daysSinceStart = now.difference(startOfYear).inDays;
    return (daysSinceStart / 7).floor();
  }

  // Get tips for current week
  static Future<List<String>> getWeeklyTips() async {
    final prefs = await SharedPreferences.getInstance();
    final currentWeek = _getCurrentWeek();
    final lastWeek = prefs.getInt(_lastWeekKey) ?? -1;
    int currentIndex = prefs.getInt(_currentTipIndexKey) ?? 0;

    // If it's a new week, move to next set of tips
    if (currentWeek != lastWeek) {
      currentIndex += 3; // Show 3 tips per week
      
      // If we've shown all tips, start over
      if (currentIndex >= _tips.length) {
        currentIndex = 0;
      }
      
      // Save the new week and index
      await prefs.setInt(_lastWeekKey, currentWeek);
      await prefs.setInt(_currentTipIndexKey, currentIndex);
    }

    // Get 3 tips starting from current index
    final tips = <String>[];
    for (int i = 0; i < 3; i++) {
      final tipIndex = (currentIndex + i) % _tips.length;
      tips.add(_tips[tipIndex]);
    }

    return tips;
  }

  // Get all tips (for admin purposes)
  static List<String> getAllTips() {
    return List.from(_tips);
  }

  // Add new tip to the list
  static Future<void> addTip(String newTip) async {
    // This would require modifying the static list, which isn't ideal
    // In a real app, you'd store tips in a database or remote config
    // For now, we'll keep it simple with the static list
    throw UnimplementedError('Adding tips dynamically requires database implementation');
  }

  // Get tip count
  static int getTipCount() {
    return _tips.length;
  }

  // Reset tips rotation (for testing)
  static Future<void> resetTipsRotation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastWeekKey);
    await prefs.remove(_currentTipIndexKey);
  }

  // Get current tip index (for debugging)
  static Future<int> getCurrentTipIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentTipIndexKey) ?? 0;
  }

  // Get current week number (for debugging)
  static int getCurrentWeekNumber() {
    return _getCurrentWeek();
  }
}
