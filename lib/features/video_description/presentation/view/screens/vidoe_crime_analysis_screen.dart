import 'dart:async';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/features/video_description/presentation/view/screens/video_crime_report.dart';
import 'package:investigator/features/video_description/presentation/view_model/cubit/video_describe_cubit.dart';
import 'package:investigator/features/video_description/presentation/view_model/cubit/video_describe_states.dart';

class CrimeAnalysisScreen extends StatelessWidget {
  const CrimeAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoDescriptionCubit>(
      // جلب الـ Cubit محقوناً بالكامل وجاهزاً عبر Get It
      create: (_) => GetIt.instance<VideoDescriptionCubit>(),
      child: const _CrimeAnalysisBody(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _CrimeAnalysisBody extends StatefulWidget {
  const _CrimeAnalysisBody();

  @override
  State<_CrimeAnalysisBody> createState() => _CrimeAnalysisBodyState();
}

class _CrimeAnalysisBodyState extends State<_CrimeAnalysisBody> {
  // متغيرات خاصة بمحاكاة التحميل والتسلية بالتزامن مع الـ Polling الدوري
  Timer? _loadingTimer;
  int _currentStep =
      0; // 0: لم يبدأ، 1: جاري الرفع، 2: استخراج ووصف، 3: اكتمال التحليل القانوني
  int _funPhraseIndex = 0;

  // جمل مسلية للمستخدم أثناء انتظار معالجة الفيديو بالذكاء الاصطناعي (تتغير كل 4 ثوانٍ تلقائياً)
  final List<String> _funPhrases = [
    "جاري قراءة أحداث الفيديو بدقة جنائية... 🔍",
    "المساعد الذكي يقوم بفحص تفاصيل مسرح الجريمة... 🧠",
    "يتم الآن مطابقة الأفعال بمواد القانون الجنائي المصري... ⚖️",
    "ثوانٍ معدودة.. نجمع الأدلة ونصيغ التقرير القانوني... 📝",
    "شبه انتهينا! نضع اللمسات الأخيرة على الوصف والتحليل الجنائي... 🚀"
  ];

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  // دالة لبدء الأنيميشن التفاعلي للمراحل والجمل أثناء التحميل الدوري
  void _startLoadingAnimation() {
    setState(() {
      _currentStep = 1; // تبدأ فوراً بمرحلة الرفع الأولية
      _funPhraseIndex = 0;
    });
    _loadingTimer?.cancel();

    _loadingTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        // تنوير الأيقونات والخطوات بالترتيب تدريجياً لمحاكاة مراحل الـ Polling
        if (_currentStep < 2) {
          _currentStep =
              2; // الانتقال التلقائي لمرحلة استخراج الوصف والـ Processing
        }

        // تغيير الجملة المسلية بالتزامن بشكل دوري عشوائي أو متتالي
        if (_funPhraseIndex < _funPhrases.length - 1) {
          _funPhraseIndex++;
        } else {
          _funPhraseIndex = 0; // إعادة التدوير
        }
      });
    });
  }

  // إيقاف التايمر وتثبيت الحالة النهائية عند النجاح أو تصفيرها عند الخطأ
  void _stopLoadingAnimation({required bool isSuccess}) {
    _loadingTimer?.cancel();
    setState(() {
      if (isSuccess) {
        _currentStep = 3; // تنوير جميع الخطوات كعلامة نجاح واكتمال المعالجة
      } else {
        _currentStep = 0; // إعادة التهيئة في حال حدوث خطأ
      }
      _funPhraseIndex = 0;
    });
  }

  Future<void> _pickCrimeVideo(Function(XFile?) onFileSelected) async {
    try {
      const XTypeGroup videoTypes = XTypeGroup(
        label: 'videos',
        extensions: ['mp4', 'mov', 'mkv', 'avi'],
      );
      final XFile? file = await openFile(acceptedTypeGroups: [videoTypes]);
      onFileSelected(file);
    } catch (e) {
      debugPrint("Error picking crime video: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing(context);
    const Color primaryRed = Color(0xFFDC2626);
    const Color darkNavy = Color(0xFF1E255E);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'تحليل الجرائم من الفيديو',
          style: TextStyle(
            color: darkNavy,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<VideoDescriptionCubit, VideoDescriptionState>(
        listener: (context, state) {
          if (state is VideoDescriptionLoading) {
            _startLoadingAnimation();
          } else if (state is VideoDescriptionSuccess) {
            _stopLoadingAnimation(isSuccess: true);

            // 1. إظهار رسالة النجاح (اختياري)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم التحليل بنجاح! واكتمل التقرير القانوني',
                    textAlign: TextAlign.right),
                backgroundColor: Colors.green,
              ),
            );

            // 2. الانتقال التلقائي للشاشة التالية وتمرير الـ response بالكامل
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VideoCriminalReportScreen(
                  entity: state
                      .response, // هنا نقوم بتمرير الـ response الكامل القادم من الـ state
                ),
              ),
            );
          } else if (state is VideoDescriptionError) {
            _stopLoadingAnimation(isSuccess: false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('حدث خطأ: ${state.message}',
                    textAlign: TextAlign.right),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoadingState = state is VideoDescriptionLoading;
          final bool isSuccessState = state is VideoDescriptionSuccess;

          return SingleChildScrollView(
            child: Padding(
              padding: spacing.paddingHorizontal.copyWith(
                top: spacing.heightSm,
                bottom: spacing.heightSm,
              ),
              child: Column(
                children: [
                  // 1. الكارد العلوي الأحمر الإرشادي
                  Container(
                    width: double.infinity,
                    padding: spacing.paddingAllMedium,
                    decoration: BoxDecoration(
                      color: primaryRed,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'تحليل متقدم بخطوتين',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: spacing.widthXs),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0x33FFFFFF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing.heightXs),
                        const Text(
                          'ارفع فيديو جريمة وسيقوم نموذج الذكاء الاصطناعي باستخراج وصف تفصيلي للأحداث ثم إرساله تلقائياً للمساعد القانوني للحصول على التحليل القانوني وفق القانون الجنائي المصري.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white, // لون ناعم ومريح للقراءة
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing.heightSm),

                  // 2. كارد مراحل التحليل التفاعلي
                  Container(
                    width: double.infinity,
                    padding: spacing.paddingAllMedium,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'مراحل التحليل',
                          style: TextStyle(
                            color: darkNavy,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: spacing.heightSm),

                        // المرحلة 1: رفع الفيديو
                        _buildTimelineStep(
                          title: 'رفع الفيديو وتوليد المعرّف',
                          subtitle: _currentStep == 1
                              ? 'جاري رفع الملف وحفظ الـ ID...'
                              : (_currentStep > 1
                                  ? 'تم الرفع وتأكيد العملية بنجاح'
                                  : 'يتم رفع الفيديو بشكل مؤقت'),
                          icon: Icons.file_upload_outlined,
                          isActive: _currentStep >= 1,
                          activeColor: const Color(0xFF2563EB),
                          showLine: true,
                        ),
                        // المرحلة 2: استخراج وصف الجريمة
                        _buildTimelineStep(
                          title: 'استخراج وصف الجريمة (Polling)',
                          subtitle: _currentStep == 2
                              ? 'الذكاء الاصطناعي يحلل اللقطات والـ status...'
                              : (_currentStep > 2
                                  ? 'اكتمل إنشاء التقرير وصياغة الأحداث'
                                  : 'نموذج الذكاء الاصطناعي يحلل الأحداث'),
                          icon: Icons.memory_outlined,
                          isActive: _currentStep >= 2,
                          activeColor: const Color(0xFF7C3AED),
                          showLine: true,
                        ),
                        // المرحلة 3: التحليل القانوني والمطابقة
                        _buildTimelineStep(
                          title: 'التحليل القانوني النهائي',
                          subtitle: _currentStep == 3
                              ? 'اكتملت معالجة الفيديو بنجاح!'
                              : 'المساعد القانوني يراجع الوصف ويطابق المواد الجنائية',
                          icon: Icons.gavel_outlined,
                          isActive: _currentStep >= 3,
                          activeColor: const Color(0xFFDC2626),
                          showLine: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing.heightSm),

                  // عرض الجمل التسلية التفاعلية فقط أثناء حالة التحميل الدوري
                  if (isLoadingState) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          _funPhrases[_funPhraseIndex],
                          key: ValueKey<int>(_funPhraseIndex),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: primaryRed,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing.heightSm),
                  ],

                  // 3. كارد النتائج والتقارير القانونية (يظهر فقط في حالة الـ Success)
                  if (isSuccessState) ...[
                    _buildResultsSection(
                        state.response, spacing, darkNavy, primaryRed),
                    SizedBox(height: spacing.heightSm),
                  ],

                  // 4. زر رفع الملف المنقط أو مؤشر التحميل الدوري
                  isLoadingState
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(color: primaryRed),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => _pickCrimeVideo((file) {
                            if (file != null) {
                              context
                                  .read<VideoDescriptionCubit>()
                                  .analyzeVideo(File(file.path));
                            }
                          }),
                          child: CustomPaint(
                            painter: DashedRectPainter(
                              color: primaryRed,
                              strokeWidth: 1.5,
                              gap: 4.0,
                              dashLength: 6.0,
                              radius: 16.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: spacing.heightMd),
                              decoration: BoxDecoration(
                                color: primaryRed.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: const [
                                  Icon(
                                    Icons.videocam_outlined,
                                    size: 40,
                                    color: primaryRed,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "اضغط لرفع فيديو الجريمة وبدء التحليل الدوري",
                                    style: TextStyle(
                                        color: primaryRed,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ويدجت التايم لاين لعرض تفاعل مراحل المعالجة
  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required bool showLine,
  }) {
    final Color currentIconColor = isActive ? activeColor : Colors.grey[400]!;
    final Color currentBgColor =
        isActive ? activeColor.withOpacity(0.12) : Colors.grey[100]!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color:
                        isActive ? const Color(0xFF1E255E) : Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: isActive ? Colors.grey[700] : Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                if (showLine)
                  const SizedBox(height: 24)
                else
                  const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: currentBgColor, shape: BoxShape.circle),
              child: Icon(icon, size: 20, color: currentIconColor),
            ),
            if (showLine)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 2,
                height: 38,
                color: isActive
                    ? activeColor.withOpacity(0.4)
                    : const Color(0xFFE2E8F0),
              ),
          ],
        ),
      ],
    );
  }

  // ويدجت احترافي لعرض النتائج المستخرجة والتحليل الدستوري الجنائي بعد النجاح الكامل
  Widget _buildResultsSection(
      dynamic response, Spacing spacing, Color darkNavy, Color primaryRed) {
    // جلب البيانات المؤمنة مباشرة من الـ Entity
    final result = response.result;

    return Container(
      width: double.infinity,
      padding: spacing.paddingAllMedium,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('التقرير والتحليل الجنائي الصادر',
                  style: TextStyle(
                      color: darkNavy,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Icon(Icons.assignment_turned_in_outlined,
                  color: Colors.green, size: 18),
            ],
          ),
          const Divider(height: 24, thickness: 1),

          // 1. وصف الأحداث المستخرجة من الفيديو بالذكاء الاصطناعي
          _buildResultField(
              'الوصف التفصيلي المستخرج للواقعة:', result.videoDescription),
          SizedBox(height: spacing.heightXs),

          // 2. تقرير وملخص الجريمة وأركانها
          _buildResultField(
              'تقرير أركان الجريمة والتكييف القانوني:', result.crimeReport),
          SizedBox(height: spacing.heightXs),

          // 3. الملخص القانوني والرد المستندي
          _buildResultField(
              'الخلاصة والمطابقة الدستورية:', result.legalSummary),
          SizedBox(height: spacing.heightXs),

          // 4. الإجابة والتوصية القانونية
          _buildResultField(
              'رأي المساعد الذكي والتوجيه الجنائي:', result.answer),

          if (result.disclaimer.isNotEmpty) ...[
            const Divider(height: 20),
            Text(
              result.disclaimer,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.amber[900],
                  fontSize: 11,
                  fontStyle: FontStyle.italic),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildResultField(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF1E40AF))),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12)),
          child: Text(content,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 12, height: 1.5, color: Color(0xFF1E255E))),
        ),
      ],
    );
  }
}

// الرسام المخصص للحواف المنقطة
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double radius;

  DashedRectPainter({
    this.color = Colors.blue,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
    this.dashLength = 6.0,
    this.radius = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = (distance + dashLength < metric.length)
            ? dashLength
            : metric.length - distance;

        final Path extractPath = metric.extractPath(
          distance,
          distance + length,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashLength + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
