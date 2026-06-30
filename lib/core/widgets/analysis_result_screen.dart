import 'package:flutter/material.dart';
import 'package:investigator/features/analysis/model/analysis_response.dart';

class AnalysisResultScreen extends StatelessWidget {
  final AnalysisResponse data;
  final FileType fileType;

  const AnalysisResultScreen({
    super.key,
    required this.data,
    required this.fileType,
  });

  // دالة مساعدة للحصول على اسم نوع الملف باللغة العربية
  String _getFileTypeString() {
    switch (fileType) {
      case FileType.image:
        return "صورة";
      case FileType.video:
        return "فيديو";
      case FileType.audio:
        return "ملف صوتي";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isReal = data.result == 'Real';
    // تحديد الألوان بناءً على حالة الملف (حقيقي أم مزيف/مولد)
    final Color primaryThemeColor = isReal
        ? const Color(0xFF7A1FA2)
        : const Color(0xFF1976D2); // لون الدائرة (بنفسجي أو أزرق حسب الصورة)
    final Color statusColor = isReal
        ? const Color(0xFF2E7D32)
        : const Color(0xFFD32F2F); // أخضر للحقيقي، أحمر للمولد
    final Color statusBgColor =
        isReal ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);

    return Scaffold(
      backgroundColor: const Color(
        0xFFF4F7FF,
      ), // الخلفية البيضاء المائلة للزرقة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "نتيجة التحليل",
          style: TextStyle(
            color: Color(0xFF0F2B61),
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F2B61)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ------ الكارت الأول: النتيجة الإجمالية والنسبة ------
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // 1. مؤشر النسبة الدائري
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 130,
                                  height: 130,
                                  child: CircularProgressIndicator(
                                    value: data.confidence / 100,
                                    strokeWidth: 12,
                                    backgroundColor: primaryThemeColor
                                        .withValues(alpha: 0.1),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      primaryThemeColor,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${data.confidence}%",
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: primaryThemeColor,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    const Text(
                                      "الثقة",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            // 2. كبسولة الحالة (حقيقي / مولد)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: statusBgColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: statusColor.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isReal
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.error_outline_rounded,
                                    color: statusColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    data.result,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 3. الوصف والتنصيص التفصيلي
                            Text(
                              data.disclaimer,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey[700],
                                height: 1.6,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ------ الكارت الثاني: تفاصيل التحليل ------
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "تفاصيل التحليل",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F2B61),
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildDetailsRow("نوع الملف", _getFileTypeString()),
                            _buildDetailsRow(
                              "نسبة الدقة",
                              "${data.confidence}%",
                            ),
                            _buildDetailsRow(
                              "النتيجة",
                              data.result,
                              valueColor: statusColor,
                            ),
                            _buildDetailsRow(
                              "المعالجة",
                              "مؤقتة — لم يُحفظ الملف",
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ------ الزر السفلي للعودة للرئيسية ------
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF1A52C5,
                    ), // اللون الأزرق للزر
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    // العودة إلى الشاشة الرئيسية HomeScreen وتفريغ شاشات النتائج من الـ Stack
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    "تحليل ملف آخر",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت مساعدة لبناء صفوف التفاصيل بتنسيق محاذي للغة العربية
  Widget _buildDetailsRow(
    String title,
    String value, {
    Color? valueColor,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? const Color(0xFF0F2B61),
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey[400],
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
