import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investigator/core/di/service_locator.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/core/widgets/analysis_result_screen.dart';
import 'package:investigator/core/widgets/custom_file_uploader.dart';
import 'package:investigator/features/analysis/image_analyses/presentation/view_model/cubit/image_analysis_cubit.dart';
import 'package:investigator/features/analysis/image_analyses/presentation/view_model/cubit/image_analysis_states.dart';
import 'package:investigator/features/analysis/model/analysis_response.dart';

class ImageAnalysisScreen extends StatelessWidget {
  const ImageAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing(context);

    // توفير الـ Cubit للشاشة وحقنه عبر GetIt
    return BlocProvider<ImageAnalysisCubit>(
      create: (context) => getIt<ImageAnalysisCubit>(),
      child: Scaffold(
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
            'تحليل الصور',
            style: TextStyle(
              color: Color(0xFF1E255E),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        // استخدام BlocConsumer للاستماع للحالات وإدارة الواجهة
        body: BlocConsumer<ImageAnalysisCubit, ImageAnalysisState>(
          listener: (context, state) {
            if (state is ImageAnalysisSuccess) {
              // عند النجاح، ننتقل لشاشة النتيجة ونمرر الـ Enum الخاص بالصورة
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AnalysisResultScreen(
                    data: state.response,
                    fileType: FileType.image,
                  ),
                ),
              );
            } else if (state is ImageAnalysisError) {
              // إظهار رسالة الخطأ للمستخدم في حال فشل الرفع أو صيغة الملف
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: spacing.paddingHorizontal.copyWith(
                  top: spacing.heightSm,
                  bottom: spacing.heightSm,
                ),
                child: Column(
                  children: [
                    // عرض مؤشر التحميل عند معالجة الصورة
                    if (state is ImageAnalysisLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Color(0xFFE2E8F0),
                          color: Color(0xFF2563EB),
                        ),
                      ),

                    CustomFileUploader(
                      title: 'تحليل الصور',
                      description:
                          'ارفع صورة وسيحدد الذكاء الاصطناعي مدى أصالتها',
                      uploadClickText: state is ImageAnalysisLoading
                          ? 'جاري تحليل الصورة...'
                          : 'اضغط هنا لرفع الملف',
                      uploadDragText: 'أو اسحب وأفلت الملف هنا',
                      footerText:
                          'لا يتم حفظ أي ملفات أو محادثات، تتم جميع عمليات التحليل والمعالجة بشكل مؤقت فقط حفاظاً على خصوصية المستخدم.',
                      topIcon: Icons.image_outlined,
                      uploadIcon: Icons.file_upload_outlined,
                      primaryColor: const Color(0xFF2563EB),
                      backgroundColor: Colors.transparent,
                      cardBackgroundColor: Colors.white,
                      textColor: Colors.white,
                      onFileSelected: (xFile) {
                        // Always provide a callback. If loading, ignore selections.
                        if (state is ImageAnalysisLoading) return;
                        if (xFile == null) return;

                        final path = xFile.path.toLowerCase();

                        // تحقق سريع من امتداد الصورة قبل استدعاء الـ Cubit
                        if (path.endsWith('.jpg') ||
                            path.endsWith('.jpeg') ||
                            path.endsWith('.png')) {
                          debugPrint("تم اختيار صورة: ${xFile.name}");

                          // استدعاء الـ Cubit لبدء التحليل
                          context.read<ImageAnalysisCubit>().detectImage(
                                File(xFile.path),
                              );
                        } else {
                          // إظهار خطأ مباشر إذا لم تكن الصيغة مدعومة
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'عذراً، يجب اختيار صورة بصيغة JPG أو PNG فقط',
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
