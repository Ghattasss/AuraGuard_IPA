import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'permission_view.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  // All permissions data
  final List<Map<String, dynamic>> _permissions = const [
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'المكتبة',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.yellow.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'جميع الأذونات',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Permissions Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: _permissions.length,
                itemBuilder: (context, index) {
                  final permission = _permissions[index];
                  return _buildPermissionCard(context, permission);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard(BuildContext context, Map<String, dynamic> permission) {
    return GestureDetector(
      onTap: () => _navigateToPermission(context, permission['id']),
      child: Container(
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
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: permission['color'].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                permission['icon'],
                color: permission['color'],
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                permission['title'],
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            
            // Arrow indicator
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

  void _navigateToPermission(BuildContext context, String permissionType) {
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
}
