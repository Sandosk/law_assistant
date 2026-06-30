import 'package:flutter/material.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/features/home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  final Color primaryBlue = const Color(0xFF2563EB);
  final Color darkNavy = const Color(0xFF1E255E);

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              // وضع صورة الـ Logo فوق كالمطلوب تماماً وبشكل متناسق
              _buildLogoSection(spacing),
              SizedBox(height: spacing.heightSm),

              // الحاوية البيضاء الممتدة
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: spacing.screenHeight * 0.03,
                    left: spacing.widthMd,
                    right: spacing.widthMd,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            color: darkNavy,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: spacing.heightXs),
                        Text(
                          'قم بملء البيانات التالية للتسجيل معنا',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: spacing.heightSm),

                        // حقل الاسم الكامل
                        _buildFieldLabel('الاسم بالكامل'),
                        SizedBox(height: spacing.heightXs),
                        _buildTextField(
                          hintText: 'أدخل اسمك الثلاثي',
                          icon: Icons.person_outline_rounded,
                        ),
                        SizedBox(height: spacing.heightSm),

                        // حقل البريد الإلكتروني
                        _buildFieldLabel('البريد الإلكتروني'),
                        SizedBox(height: spacing.heightXs),
                        _buildTextField(
                          hintText: 'name@example.com',
                          icon: Icons.email_outlined,
                        ),
                        SizedBox(height: spacing.heightSm),

                        // حقل رقم الهاتف
                        _buildFieldLabel('رقم الهاتف'),
                        SizedBox(height: spacing.heightXs),
                        _buildTextField(
                          hintText: '01xxxxxxxxx',
                          icon: Icons.phone_outlined,
                        ),
                        SizedBox(height: spacing.heightSm),

                        // حقل كلمة المرور
                        _buildFieldLabel('كلمة مرور جديدة'),
                        SizedBox(height: spacing.heightXs),
                        _buildTextField(
                          hintText: 'أدخل كلمة المرور',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onSuffixTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        SizedBox(height: spacing.heightMd),

                        // زر تسجيل الحساب الجديد المتجه فوراً للـ HomeScreen
                        _buildPrimaryButton(
                          text: 'تسجيل الحساب ودخول التطبيق',
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                              (route) =>
                                  false, // يمسح كل الـ Stack لضمان تجربة مستخدم آمنة
                            );
                          },
                        ),
                        SizedBox(height: spacing.heightSm),

                        // العودة لتسجيل الدخول
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              'لديك حساب بالفعل؟',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing.heightSm),
                      ],
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

  // نفس بناء الـ Logo المتماثل بالـ Spacing لضمان التماثل بين الصفحتين
  Widget _buildLogoSection(Spacing spacing) {
    return Column(
      children: [
        Container(
          width: spacing.screenWidth *
              0.16, // حجم أصغر قليلاً في الـ SignUp لتوفير مساحة للحقول
          height: spacing.screenWidth * 0.16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset('assets/images/app_icon.jpg', fit: BoxFit.cover),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) => Text(
        label,
        style: TextStyle(
          color: darkNavy,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          prefixIcon: isPassword
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                )
              : null,
          suffixIcon: Icon(
            icon,
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.6),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D4ED8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          shadowColor: const Color(0xFF1D4ED8).withValues(alpha: 0.4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
