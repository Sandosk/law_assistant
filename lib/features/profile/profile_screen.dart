import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final Color primaryBlue = const Color(0xFF2563EB);
  final Color darkNavy = const Color(0xFF1E255E);
  final Color bgLightColor = const Color(0xFFF4F7FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLightColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. الجزء العلوي الملون (Header)
            _buildHeader(),

            const SizedBox(height: 16),

            // 2. بطاقة إشعار حماية البيانات الأخضر
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildPrivacyBanner(),
            ),

            const SizedBox(height: 16),

            // 3. قائمة الخيارات والإعدادات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildOptionsList(context),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ==================== مكونات الواجهة (UI Components) ====================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
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
          // إطار الصورة الشخصية المودرن المستوحى من الصورة
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 44,
            ),
          ),
          const SizedBox(height: 16),
          // اسم المستخدم
          const Text(
            'أحمد محمد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // البريد الإلكتروني
          Text(
            'ahmed@example.com',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          // شارة حساب نشط
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
                const SizedBox(width: 8),
                const Text(
                  'حساب نشط',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EA), // خلفية خضراء فاتحة جداً مريحة للعين
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x3334A853), width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Expanded(
            child: Text(
              'جميع بياناتك محمية. لا يتم حفظ أي محادثات أو ملفات تحليل.',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF137333),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.shield_outlined, color: Color(0xFF137333), size: 20),
        ],
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuTile(
            title: 'المعلومات الشخصية',
            subtitle: 'تعديل بيانات الحساب',
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF2563EB),
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuTile(
            title: 'اللغة',
            subtitle: 'العربية',
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF3B82F6),
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuTile(
            title: 'سياسة الخصوصية',
            subtitle: 'كيف نحمي بياناتك',
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF10B981),
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuTile(
            title: 'عن التطبيق',
            subtitle: 'الإصدار 1.0.0 — مشروع تخرج',
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFF6B7280),
            onTap: () {},
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: title == 'المعلومات الشخصية'
            ? const Radius.circular(28)
            : Radius.zero,
        bottom: isLast ? const Radius.circular(28) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // السهم جهة اليسار (مؤشر الانتقال)
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: Colors.grey[400],
            ),
            const Spacer(),
            // النصوص (العناوين) محاذاة لليمين
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: darkNavy,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
            const SizedBox(width: 14),
            // الأيقونة جهة اليمين داخل حاوية دائرية خفيفة
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(color: Colors.grey[100], height: 1, thickness: 1),
    );
  }
}
