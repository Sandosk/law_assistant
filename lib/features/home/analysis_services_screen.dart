import 'package:flutter/material.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/features/analysis/audio_analysis/presentation/view/screens/audio_analysis_screen.dart';
import 'package:investigator/features/analysis/image_analyses/presentation/view/screens/image_analysis_screen.dart';
import 'package:investigator/features/analysis/video_analysis/presentation/view/screens/video_analysis_screen.dart';
import 'package:investigator/features/video_description/presentation/view/screens/vidoe_crime_analysis_screen.dart';

class AnalysisServicesScreen extends StatefulWidget {
  const AnalysisServicesScreen({super.key});

  @override
  State<AnalysisServicesScreen> createState() => _AnalysisServicesScreenState();
}

class _AnalysisServicesScreenState extends State<AnalysisServicesScreen> {
  // تفعيل التبويب الثاني (التحليلات) بناءً على تصميم شاشة image_bb2edd.png

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        top: false, // لجعل الهيدر المتدرج يمتد لأعلى الشاشة بالكامل
        child: Column(
          children: [
            // 1. الهيدر العلوي الأزرق المتدرج (خدمات التحليل)
            _buildHeader(spacing),

            // 2. قائمة خدمات التحليل الطولية
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: spacing.paddingHorizontal.copyWith(
                    top: spacing.heightSm,
                    bottom: spacing.heightMd,
                  ),
                  child: Column(
                    children: [
                      // كرت تحليل الصور (أزرق)
                      _buildServiceRowCard(
                        title: 'تحليل الصور',
                        description:
                            'تحقق من صحة الصور واكتشف ما إذا كانت حقيقية أو معدّلة بالذكاء الاصطناعي أو مفبركة.',
                        icon: Icons.image_outlined,
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ImageAnalysisScreen(),
                          ),
                        ),
                      ),
                      SizedBox(height: spacing.heightSm),

                      // كرت تحليل الفيديوهات (بنفسجي)
                      _buildServiceRowCard(
                        title: 'تحليل الفيديوهات',
                        description:
                            'كشف فيديوهات الديب فيك والتلاعب البصري في مقاطع الفيديو.',
                        icon: Icons.videocam_outlined,
                        iconColor: const Color(0xFF8B5CF6),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const VideoAnalysisScreen(),
                          ),
                        ),
                      ),
                      SizedBox(height: spacing.heightSm),

                      // كرت تحليل الصوت (فيروزي)
                      _buildServiceRowCard(
                        title: 'تحليل الصوت',
                        description:
                            'تمييز الأصوات الحقيقية من الموَلّدة بالذكاء الاصطناعي أو المعدّلة.',
                        icon: Icons.mic_none_outlined,
                        iconColor: const Color(0xFF118EA6),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AudioAnalysisScreen(),
                          ),
                        ),
                      ),
                      SizedBox(height: spacing.heightSm),

                      // كرت تحليل الجرائم المميز (الأحمر البارز)
                      _buildFeaturedCrimeCard(
                        title: 'تحليل الجرائم',
                        description:
                            'ارفع فيديو جريمة واحصل على وصف تفصيلي وتحليل قانوني مدعوم بالذكاء الاصطناعي.',
                        icon: Icons.gavel_outlined,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CrimeAnalysisScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // الهيدر العلوي المتدرج المتناسق مع الشاشة المرفقة
  Widget _buildHeader(Spacing spacing) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: spacing.heightMd * 1.5,
        bottom: spacing.heightSm * 1.2,
        left: spacing.widthMd,
        right: spacing.widthMd,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'خدمات التحليل',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'تحليل الأدلة الرقمية بالذكاء الاصطناعي',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ويدجت بناء الكروت القياسية البيضاء (صور، فيديو، صوت)
  Widget _buildServiceRowCard({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios_new,
              size: 14,
              color: Color(0xFF2563EB),
            ),
            const Spacer(),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1E255E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت بناء الكارت الأحمر المميز (تحليل الجرائم) مع شارة "مميز" جهة اليسار
  Widget _buildFeaturedCrimeCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB91C1C), Color(0xFFDC2626)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDC2626).withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // شارة مميز والسام جهة اليسار بالتطابق مع التصميم
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x2AFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.auto_awesome, size: 10, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'مميز',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  // الـ Bottom Navigation Bar المتناسق مع التحديد الموضح بالرسمة
}
