import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/tips_service.dart';

class TipsAdminView extends StatefulWidget {
  const TipsAdminView({super.key});

  @override
  State<TipsAdminView> createState() => _TipsAdminViewState();
}

class _TipsAdminViewState extends State<TipsAdminView> {
  List<String> _allTips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllTips();
  }

  void _loadAllTips() {
    setState(() {
      _allTips = TipsService.getAllTips();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'إدارة النصائح',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF00A651),
          foregroundColor: Colors.white,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00A651),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'إحصائيات النصائح',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'إجمالي النصائح: ${_allTips.length}',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          Text(
                            'النصائح المعروضة أسبوعياً: 3',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          Text(
                            'عدد الأسابيع المطلوبة لعرض جميع النصائح: ${(_allTips.length / 3).ceil()}',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Tips List
                    Text(
                      'قائمة النصائح',
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Tips List
                    ...List.generate(_allTips.length, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00A651).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF00A651),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _allTips[index],
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  color: const Color(0xFF1F2937),
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }
}
