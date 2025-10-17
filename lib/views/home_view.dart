import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/onboarding_service.dart';
import '../services/tips_service.dart';
import '../services/tasks_service.dart';
import '../models/task.dart';
import 'permission_view.dart';
import 'library_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<String> _weeklyTips = [];
  bool _isLoadingTips = true;
  List<Task> _weeklyTasks = [];
  List<bool> _tasksCompletionStatus = [];
  bool _isLoadingTasks = true;
  
  // Permissions data
  final List<Map<String, dynamic>> _permissions = [
    {
      'id': 'camera',
      'title': 'الكاميرا',
      'icon': Icons.camera_alt_outlined,
      'color': Colors.blue,
    },
    {
      'id': 'location',
      'title': 'الموقع',
      'icon': Icons.location_on_outlined,
      'color': Colors.green,
    },
    {
      'id': 'photos',
      'title': 'الصور',
      'icon': Icons.photo_library_outlined,
      'color': Colors.purple,
    },
    {
      'id': 'contacts',
      'title': 'جهات الاتصال',
      'icon': Icons.contacts_outlined,
      'color': Colors.orange,
    },
    {
      'id': 'microphone',
      'title': 'الميكروفون',
      'icon': Icons.mic_outlined,
      'color': Colors.red,
    },
    {
      'id': 'local_network',
      'title': 'الشبكة المحلية',
      'icon': Icons.wifi_outlined,
      'color': Colors.blue,
    },
    {
      'id': 'allow',
      'title': 'السماح بالتتبع',
      'icon': Icons.track_changes_outlined,
      'color': Colors.purple,
    },
  ];
  
  List<Map<String, dynamic>> _filteredPermissions = [];

  @override
  void initState() {
    super.initState();
    _loadWeeklyTips();
    _loadWeeklyTasks();
    // Show only first 3 permissions in home view
    _filteredPermissions = List.from(_permissions.take(3));
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadWeeklyTips() async {
    try {
      final tips = await TipsService.getWeeklyTips();
      if (mounted) {
        setState(() {
          _weeklyTips = tips;
          _isLoadingTips = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingTips = false;
        });
      }
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        // Show only first 3 permissions in home view
        _filteredPermissions = List.from(_permissions.take(3));
      } else {
        // Search in all permissions when searching
        _filteredPermissions = _permissions.where((permission) {
          return permission['title'].toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadWeeklyTasks() async {
    try {
      final tasks = await TasksService.getWeeklyTasks();
      final completionStatus = await TasksService.getWeeklyTasksCompletionStatus();
      if (mounted) {
        setState(() {
          _weeklyTasks = tasks;
          _tasksCompletionStatus = completionStatus;
          _isLoadingTasks = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingTasks = false;
        });
      }
    }
  }

  Future<void> _regenerateTasks() async {
    try {
      setState(() {
        _isLoadingTasks = true;
      });
      
      await TasksService.regenerateCurrentWeekTasks();
      await _loadWeeklyTasks();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم تجديد المهام بنجاح',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: const Color(0xFF00A651),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingTasks = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ أثناء تجديد المهام',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToPermission(String permissionType) {
    switch (permissionType) {
      case 'contacts':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PermissionView(
              permissionTitle: 'جهات الاتصال',
              permissionImage: 'assets/images/contacts.jpg',
              steps: [
                'افتح الإعدادات',
                'ابحث عن التطبيق',
                'اختر الصلاحية المرادة "جهات الاتصال"',
              ],
              description: 'تسمح صلاحية جهات الاتصال للتطبيقات بالوصول إلى قائمة جهات الاتصال المحفوظة في جهازك. يمكن للتطبيقات قراءة أسماء جهات الاتصال وأرقام الهواتف والعناوين الإلكترونية والمعلومات الأخرى المحفوظة.',
              awareness: '⚠️ المخاطر المحتملة:\n\n• سرقة معلومات جهات الاتصال: يمكن للتطبيقات الضارة جمع جميع جهات الاتصال المحفوظة في جهازك\n• انتهاك الخصوصية: قد يتم بيع أو مشاركة معلومات جهات الاتصال مع أطراف ثالثة\n• رسائل مزعجة: قد تستخدم التطبيقات أرقام جهات الاتصال لإرسال رسائل تسويقية أو مزعجة\n• استهداف الإعلانات: قد تستخدم الشركات معلومات جهات الاتصال لاستهدافك بإعلانات أكثر دقة',
              bestOption: 'لا شيء (إلغاء الصلاحية)',
              whyBestOption: 'هذا هو الخيار الأكثر أماناً لمعظم التطبيقات. فقط التطبيقات التي تحتاج حقاً إلى جهات الاتصال (مثل تطبيقات المراسلة أو الهاتف) يجب أن تحصل على هذه الصلاحية. معظم التطبيقات لا تحتاج إلى الوصول إلى جهات الاتصال ويمكنها العمل بشكل طبيعي بدونها.',
            ),
          ),
        );
        break;
      case 'camera':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PermissionView(
              permissionTitle: 'الكاميرا',
              permissionImage: 'assets/images/camera.jpg',
              steps: [
                'افتح الإعدادات',
                'ابحث عن التطبيق',
                'اختر الصلاحية المرادة "الكاميرا"',
              ],
              description: 'تسمح صلاحية الكاميرا للتطبيقات بالتقاط الصور وتسجيل الفيديو. يمكن استخدامها لمسح رموز QR، أو إجراء مكالمات فيديو، أو استخدام ميزات الواقع المعزز.',
              awareness: '⚠️ المخاطر المحتملة:\n\n• تسجيل غير مصرح به: قد تقوم التطبيقات بتسجيلك دون علمك\n• انتهاك الخصوصية: يمكن استخدام الصور ومقاطع الفيديو للتعرف عليك أو على بيئتك\n• الوصول إلى البيانات الحساسة: قد تحتوي الصور على معلومات حساسة مثل المستندات أو الوجوه\n• الاستخدام الخبيث: يمكن للمتسللين الوصول إلى الكاميرا عن بعد',
              bestOption: 'أثناء استخدام التطبيق',
              whyBestOption: 'يمنح هذا الخيار التطبيق الوصول إلى الكاميرا فقط عندما يكون قيد الاستخدام النشط، مما يقلل من مخاطر التسجيل غير المصرح به.',
            ),
          ),
        );
        break;
      case 'location':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PermissionView(
              permissionTitle: 'الموقع',
              permissionImage: 'assets/images/location.jpg',
              steps: [
                'افتح الإعدادات',
                'ابحث عن التطبيق',
                'اختر الصلاحية المرادة "الموقع"',
              ],
              description: 'تسمح صلاحية الموقع للتطبيقات بالوصول إلى موقعك الجغرافي. يمكن للتطبيقات معرفة مكانك الحالي أو تتبع تحركاتك. تتوفر خيارات مختلفة للتحكم في مستوى الوصول: "أبداً"، "أثناء استخدام التطبيق"، أو "دائماً".',
              awareness: '⚠️ المخاطر المحتملة:\n\n• تتبع الموقع المستمر: يمكن للتطبيقات تتبع موقعك حتى عند عدم استخدامها\n• انتهاك الخصوصية: قد يتم بيع أو مشاركة بيانات موقعك مع أطراف ثالثة\n• استهداف جغرافي: قد تستخدم الشركات موقعك لاستهدافك بإعلانات محلية\n• استهلاك البطارية: تتبع الموقع المستمر يستهلك طاقة البطارية بسرعة\n• الأمان الشخصي: الكشف عن موقعك قد يعرضك لمخاطر أمنية',
              bestOption: 'أثناء استخدام التطبيق',
              whyBestOption: 'هذا هو الخيار الأكثر توازناً بين الأمان والوظائف. يسمح للتطبيق بالوصول إلى موقعك فقط عندما تستخدمه فعلياً، مما يحميك من التتبع المستمر في الخلفية. معظم التطبيقات تعمل بشكل مثالي مع هذا الإعداد ولا تحتاج إلى الوصول الدائم للموقع.',
            ),
          ),
        );
        break;
      case 'photos':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PermissionView(
              permissionTitle: 'الصور',
              permissionImage: 'assets/images/gallery.jpg',
              steps: [
                'افتح الإعدادات',
                'ابحث عن التطبيق',
                'اختر الصلاحية المرادة "الصور"',
              ],
              description: 'تسمح صلاحية الصور للتطبيقات بالوصول إلى مكتبة الصور في جهازك. يمكن للتطبيقات قراءة الصور والفيديوهات المحفوظة، وأحياناً تعديلها أو حذفها. تتوفر خيارات مختلفة: "لا شيء"، "وصول محدود" (صور محددة فقط)، أو "وصول كامل" (جميع الصور).',
              awareness: '⚠️ المخاطر المحتملة:\n\n• سرقة الصور الشخصية: يمكن للتطبيقات الضارة الوصول إلى جميع صورك الشخصية\n• انتهاك الخصوصية: قد يتم بيع أو مشاركة صورك مع أطراف ثالثة\n• استخراج البيانات: الصور تحتوي على بيانات حساسة مثل الموقع والتوقيت\n• تعديل أو حذف الصور: بعض التطبيقات قد تعدل أو تحذف صورك\n• استهداف الإعلانات: قد تستخدم الشركات صورك لاستهدافك بإعلانات أكثر دقة',
              bestOption: 'وصول محدود (صور محددة)',
              whyBestOption: 'هذا هو الخيار الأكثر أماناً. يسمح لك باختيار الصور المحددة التي تريد مشاركتها مع التطبيق، بدلاً من منحه الوصول إلى جميع صورك. معظم التطبيقات تعمل بشكل مثالي مع هذا الإعداد، ويمكنك إضافة المزيد من الصور لاحقاً حسب الحاجة.',
            ),
          ),
        );
        break;
      case 'local_network':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PermissionView(
              permissionTitle: 'الشبكة المحلية',
              permissionImage: 'assets/images/local network.jpg',
              steps: [
                'افتح الإعدادات',
                'ابحث عن التطبيق',
                'اختر الصلاحية المرادة "الشبكة المحلية"',
              ],
              description: 'تسمح صلاحية الشبكة المحلية للتطبيقات بالبحث عن الأجهزة الأخرى المتصلة بنفس الشبكة المحلية والتواصل معها. هذا ضروري لميزات مثل البث إلى أجهزة التلفزيون الذكية، أو التحكم في الأجهزة المنزلية الذكية، أو اللعب متعدد اللاعبين محلياً.',
              awareness: '⚠️ المخاطر المحتملة:\n\n• اكتشاف الأجهزة: يمكن للتطبيقات رؤية جميع الأجهزة المتصلة بشبكتك المحلية\n• الوصول إلى البيانات: قد تتمكن التطبيقات من الوصول إلى البيانات المشتركة على الأجهزة الأخرى في شبكتك\n• هجمات الشبكة: يمكن للتطبيقات الخبيثة استغلال هذه الصلاحية لشن هجمات على أجهزة أخرى\n• تتبع النشاط: قد يتم تتبع نشاطك على الشبكة المحلية',
              bestOption: 'إيقاف التشغيل',
              whyBestOption: 'يجب منح هذه الصلاحية فقط للتطبيقات الموثوقة التي تحتاجها لوظائف محددة، وإلا فمن الأفضل إبقاؤها معطلة لتعزيز الخصوصية والأمان.',
            ),
          ),
        );
        break;
      case 'microphone':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PermissionView(
              permissionTitle: 'الميكروفون',
              permissionImage: 'assets/images/microphone.jpg',
              steps: [
                'افتح الإعدادات',
                'ابحث عن التطبيق',
                'اختر الصلاحية المرادة "الميكروفون"',
              ],
              description: 'تسمح صلاحية الميكروفون للتطبيقات بتسجيل الصوت من جهازك. هذا ضروري لميزات مثل المكالمات الصوتية، أو التسجيلات الصوتية، أو الأوامر الصوتية، أو تطبيقات التعرف على الموسيقى.',
              awareness: '⚠️ المخاطر المحتملة:\n\n• التنصت: قد تقوم التطبيقات بتسجيل محادثاتك دون علمك\n• انتهاك الخصوصية: يمكن استخدام التسجيلات الصوتية للتعرف عليك أو على بيئتك\n• الوصول إلى البيانات الحساسة: قد تحتوي التسجيلات على معلومات شخصية أو سرية\n• الاستخدام الخبيث: يمكن للمتسللين الوصول إلى الميكروفون عن بعد',
              bestOption: 'أثناء استخدام التطبيق',
              whyBestOption: 'يمنح هذا الخيار التطبيق الوصول إلى الميكروفون فقط عندما يكون قيد الاستخدام النشط، مما يقلل من مخاطر التسجيل غير المصرح به.',
            ),
          ),
        );
        break;
      case 'allow':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PermissionView(
              permissionTitle: 'السماح بالتتبع',
              permissionImage: 'assets/images/allow.jpg',
              steps: [
                'افتح الإعدادات',
                'ابحث عن التطبيق',
                'اختر الصلاحية المرادة "السماح بالتتبع"',
              ],
              description: 'تسمح صلاحية "السماح بالتتبع" للتطبيقات بتتبع نشاطك عبر التطبيقات والمواقع الأخرى. هذا يسمح للتطبيقات بجمع بيانات حول عاداتك في التصفح والاستخدام لتخصيص الإعلانات والمحتوى.',
              awareness: '⚠️ المخاطر المحتملة:\n\n• تتبع شامل: يمكن للتطبيقات تتبع جميع أنشطتك عبر الإنترنت\n• انتهاك الخصوصية: جمع بيانات مفصلة عن عاداتك واهتماماتك\n• إعلانات مستهدفة: استخدام بياناتك لاستهدافك بإعلانات مخصصة\n• بيع البيانات: قد يتم بيع أو مشاركة بياناتك مع أطراف ثالثة\n• ملف تعريف رقمي: إنشاء ملف تعريف شامل عنك',
              bestOption: 'إيقاف التشغيل (طلب عدم التتبع)',
              whyBestOption: 'هذا هو الخيار الأكثر أماناً لخصوصيتك. يمنع التطبيقات من تتبعك عبر التطبيقات والمواقع الأخرى، مما يحمي خصوصيتك ويقلل من الإعلانات المستهدفة. معظم التطبيقات تعمل بشكل طبيعي بدون هذه الصلاحية.',
            ),
          ),
        );
        break;
    }
  }

  Future<void> _toggleTaskCompletion(int taskIndex) async {
    final task = _weeklyTasks[taskIndex];
    final isCompleted = _tasksCompletionStatus[taskIndex];
    
    if (isCompleted) {
      // Task is completed, unmark it
      await TasksService.unmarkTaskCompleted(task.id);
      
      // Update local state
      setState(() {
        _tasksCompletionStatus[taskIndex] = false;
      });
    } else {
      // Mark task as completed
      await TasksService.markTaskCompleted(task.id);
      
      // Update local state
      setState(() {
        _tasksCompletionStatus[taskIndex] = true;
      });
      
      // Check if all tasks are completed
      final allCompleted = await TasksService.areAllWeeklyTasksCompleted();
      if (allCompleted) {
        _showCompletionDialog();
      }
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A651).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.celebration,
                    color: Color(0xFF00A651),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'تهانينا! 🎉',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'لقد أكملت جميع مهام هذا الأسبوع بنجاح!',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: const Color(0xFF374151),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'ستحصل على مهام جديدة الأسبوع القادم.',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A651),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'ممتاز!',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A651).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.task_alt,
                    color: Color(0xFF00A651),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.title,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Task details
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التفاصيل:',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.details,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: const Color(0xFF374151),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF00A651).withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.help_outline,
                              color: Color(0xFF00A651),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'كيفية التنفيذ:',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00A651),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task.instructions,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: const Color(0xFF1F2937),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Task info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A651).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.category,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00A651),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A651),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'فهمت',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // 👈 Forces full RTL layout
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFF8F9FA)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 20),
                  _buildBeginnerGuideCard(),
                  // Debug: Long press to reset onboarding (remove in production)
                  GestureDetector(
                    onLongPress: () async {
                      await OnboardingService.resetOnboardingState();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم إعادة تعيين حالة التعريف',
                              style: GoogleFonts.cairo(),
                            ),
                            backgroundColor: const Color(0xFF00A651),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'AuraGuard',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  // Debug: Double tap to reset tips rotation
                  GestureDetector(
                    onDoubleTap: () async {
                      await TipsService.resetTipsRotation();
                      await _loadWeeklyTips();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم إعادة تعيين نصائح الأسبوع',
                              style: GoogleFonts.cairo(),
                            ),
                            backgroundColor: const Color(0xFF00A651),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Tips',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPermissionsSection(),
                  const SizedBox(height: 24),
                  _buildTipsSection(),
                  const SizedBox(height: 24),
                  _buildDeviceSettingsSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // ----------- Widgets -------------

  Widget _buildBeginnerGuideCard() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/video-player');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF00A651).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'دليل المبتدئين: كيف تراجع أذونات تطبيقاتك',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'في دقيقتين ',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF00A651),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'دليل تفاعلي بسيط يريك أسرع طريقة لمراجعة أهم الأذونات.',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: const Color(0xFF6B7280),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A651).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_circle_filled,
                    color: Color(0xFF00A651),
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF00A651).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'اضغط للمشاهدة',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF00A651),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.yellow.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'افهم أذوناتك',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Search bar
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'ابحث عن إذن...',
              hintStyle: GoogleFonts.cairo(
                color: const Color(0xFF9CA3AF),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF6B7280)),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : const Icon(Icons.search, color: Color(0xFF6B7280)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Permission cards
        if (_filteredPermissions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  color: const Color(0xFF6B7280),
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'لم يتم العثور على نتائج',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'جرب البحث بكلمات مختلفة',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          )
        else
          ...List.generate(_filteredPermissions.length, (index) {
            final permission = _filteredPermissions[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPermissionCard(
                icon: permission['icon'],
                title: permission['title'],
                color: permission['color'],
                onTap: () => _navigateToPermission(permission['id']),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
            Icon(
              Icons.arrow_back_ios,
              color: const Color(0xFF6B7280),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start ,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.yellow.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'نصائح هذا الأسبوع',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 120,
          child: _isLoadingTips
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00A651),
                  ),
                )
              : ListView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  children: [
                    for (int i = 0; i < _weeklyTips.length; i++) ...[
                      _buildTipCard(_weeklyTips[i]),
                      if (i < _weeklyTips.length - 1) const SizedBox(width: 12),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTipCard(String text) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: GoogleFonts.cairo(
          fontSize: 14,
          color: const Color(0xFF374151),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildDeviceSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Regenerate button on the left
            GestureDetector(
              onTap: _regenerateTasks,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A651).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF00A651).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Color(0xFF00A651),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.yellow.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'مهام هذا الأسبوع',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Tasks List
        if (_isLoadingTasks)
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00A651),
            ),
          )
        else
          ...List.generate(_weeklyTasks.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTaskItem(_weeklyTasks[index], index),
            );
          }),
      ],
    );
  }

  Widget _buildTaskItem(Task task, int index) {
    final isCompleted = _tasksCompletionStatus[index];
    
    return GestureDetector(
      onTap: () => _showTaskDetails(task),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted 
                ? const Color(0xFF00A651) 
                : const Color(0xFFE5E7EB),
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: isCompleted ? [
            BoxShadow(
              color: const Color(0xFF00A651).withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _toggleTaskCompletion(index),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? const Color(0xFF00A651) 
                      : Colors.transparent,
                  border: Border.all(
                    color: isCompleted 
                        ? const Color(0xFF00A651) 
                        : const Color(0xFF6B7280), 
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isCompleted 
                          ? const Color(0xFF00A651) 
                          : const Color(0xFF1F2937),
                      decoration: isCompleted 
                          ? TextDecoration.lineThrough 
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A651).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.category,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00A651),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.info_outline,
              color: isCompleted 
                  ? const Color(0xFF00A651) 
                  : const Color(0xFF6B7280),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            // Navigate to library view
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LibraryView(),
              ),
            );
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF00A651),
        unselectedItemColor: const Color(0xFF6B7280),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
            label: 'المكتبة',
          ),
        ],
      ),
    );
  }
}
