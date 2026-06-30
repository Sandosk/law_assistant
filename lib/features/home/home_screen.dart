import 'package:flutter/material.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/features/analysis/audio_analysis/presentation/view/screens/audio_analysis_screen.dart';
import 'package:investigator/features/analysis/image_analyses/presentation/view/screens/image_analysis_screen.dart';
import 'package:investigator/features/analysis/video_analysis/presentation/view/screens/video_analysis_screen.dart';
import 'package:investigator/features/legal_chatbot/presentation/view/screens/legal_chatbot_screen.dart';
import 'package:investigator/features/profile/profile_screen.dart';
import 'package:investigator/features/video_description/presentation/view/screens/vidoe_crime_analysis_screen.dart';
import 'analysis_services_screen.dart';

class HomeScreen extends StatefulWidget {
  // استقبال الـ Index الافتراضي وتصحيح الكلمة إلى currentIndex
  const HomeScreen({super.key, this.currentIndex = 3});

  final int currentIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. هنا نقوم فقط بتعريف المتغير بدون قيمة ابتدائية ثابتة
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  final Color primaryBlue = const Color(0xFF2563EB);
  final Color darkNavy = const Color(0xFF1E255E);

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing(context);

    // 🎯 مصفوفة الشاشات الحقيقية للتنقل بناءً على تصميم الـ Bottom Navigation
    final List<Widget> screens = [
      const ProfileScreen(),
      const LegalChatScreen(),
      const AnalysisServicesScreen(), // تبويب التحليلات (القائمة الطولية)
      _buildHomeDashboard(spacing), // تبويب الرئيسية (الداشبورد الحالي)
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      // استخدام IndexedStack لضمان التنقل الحقيقي مع الحفاظ على حالة الشاشات (State)
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ==================== ويدجت محتوى الداشبورد الرئيسي لشاشة الرئيسية ====================
  Widget _buildHomeDashboard(Spacing spacing) {
    return Stack(
      children: [
        SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 1. الهيدر العلوي الأزرق
                _buildHeader(spacing),

                Padding(
                  padding: spacing.paddingHorizontal.copyWith(
                    top: spacing.heightSm,
                    bottom: spacing.heightMd * 2.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 2. كارد بنر المساعد القانوني الذكي
                      _buildAssistantBanner(spacing),
                      SizedBox(height: spacing.heightSm),

                      // 3. كارد ميزة تحليل الجرائم من الفيديو (المختصر)
                      //  _buildCrimeAnalysisPreview(spacing),
                      // SizedBox(height: spacing.heightSm),

                      // 4. قسم خدمات التحليل (الشبكة الأربعة الأزرار)
                      const Text(
                        'خدمات التحليل',
                        style: TextStyle(
                          color: Color(0xFF1E255E),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: spacing.heightXs),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.15,
                        children: [
                          _buildServiceCard(
                            'تحليل الصور',
                            'كشف التزوير والتلاعب',
                            Icons.image_outlined,
                            const Color(0xFF2563EB),
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ImageAnalysisScreen(),
                                ),
                              );
                            },
                          ),
                          _buildServiceCard(
                            'تحليل الفيديوهات',
                            'كشف الديب فيك',
                            Icons.videocam_outlined,
                            const Color(0xFF8B5CF6),
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const VideoAnalysisScreen(),
                                ),
                              );
                            },
                          ),
                          _buildServiceCard(
                            'تحليل الصوت',
                            'كشف الأصوات المزيفة',
                            Icons.mic_none_outlined,
                            const Color(0xFF118EA6),
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AudioAnalysisScreen(),
                                ),
                              );
                            },
                          ),
                          _buildServiceCard(
                            'تحليل الجرائم',
                            'تحليل فيديوهات الجرائم',
                            Icons.gavel_outlined,
                            const Color(0xFFDC2626),
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CrimeAnalysisScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // الـ FAB المعلق للميزان الأزرق (يظهر فقط عندما نكون في تبويب الرئيسية رقم 3)
        if (_currentIndex == 3)
          Positioned(
            width: spacing.heightLg * 1.5,
            height: spacing.heightLg * 1.5,
            bottom: spacing.heightSm,
            left: spacing.heightSm,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D4ED8).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                //  color: const Color(0xFF1D4ED8),
                shape: const CircleBorder(),
                clipBehavior: Clip
                    .antiAlias, // لضمان بقاء تأثير الضغط والصورة داخل حدود الدائرة
                child: InkWell(
                  onTap: () {
                    // 🎯 الانتقال الفوري لتبويب المحادثة (Index 1)
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  highlightColor: Colors.white.withValues(alpha: 0.1),
                  child: SizedBox(
                    width: spacing.heightLg * 1.5,
                    height: spacing.heightLg * 1.5,
                    child: Image.asset(
                      'assets/images/chatbot.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ==================== مكونات الهيدر والبنرات الفرعية ====================
  Widget _buildHeader(Spacing spacing) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: spacing.heightMd * 1.5,
        bottom: spacing.heightSm * 1.5,
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
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: spacing.widthLg * 3,
                decoration: const BoxDecoration(
                  color: Color(0x1AFFFFFF),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/chatbot.png',
                  fit: BoxFit.contain,
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'مرحباً بك 👋',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    'المساعد القانوني الذكي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: spacing.heightSm),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x33FFFFFF)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '...ابحث عن استشارة قانونية',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistantBanner(Spacing spacing) {
    return Container(
      width: double.infinity,
      padding: spacing.paddingAllMedium,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x22FFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Text(
                      'مباشر',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.circle, color: Colors.green, size: 8),
                  ],
                ),
              ),
              const Row(
                children: [
                  Text(
                    'المساعد القانوني الذكي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.memory, color: Colors.white70, size: 20),
                ],
              ),
            ],
          ),
          SizedBox(height: spacing.heightXs),
          const Text(
            'اسأل أي سؤال قانوني واحصل على إجابة فورية مدعومة بالذكاء الاصطناعي بناءً على القانون الجنائي المصري.',
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
          ),
          SizedBox(height: spacing.heightSm),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(currentIndex: 1),
                ),
              );
            },
            icon: Icon(Icons.chat_bubble_outline, size: 16, color: primaryBlue),
            label: Text(
              'ابدأ المحادثة',
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 42),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                color: darkNavy,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== الـ Bottom Navigation Bar المطور والمتحرك ====================
  Widget _buildBottomNavigationBar() {
    final List<Map<String, dynamic>> navItems = [
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'الحساب',
      },
      {
        'icon': Icons.chat_bubble_outline,
        'activeIcon': Icons.chat_bubble,
        'label': 'المحادثة',
      },
      {
        'icon': Icons.bar_chart_outlined,
        'activeIcon': Icons.bar_chart,
        'label': 'التحليلات',
      },
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'الرئيسية',
      },
    ];

    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final bool isSelected = _currentIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _currentIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? primaryBlue.withValues(alpha: 0.8)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      isSelected
                          ? navItems[index]['activeIcon']
                          : navItems[index]['icon'],
                      color: isSelected ? primaryBlue : Colors.grey[400],
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    navItems[index]['label'],
                    style: TextStyle(
                      color: isSelected ? primaryBlue : Colors.grey[500],
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
