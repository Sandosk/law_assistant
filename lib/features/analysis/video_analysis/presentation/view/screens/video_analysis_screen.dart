import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investigator/core/di/service_locator.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/core/widgets/analysis_result_screen.dart';
import 'package:investigator/core/widgets/custom_file_uploader.dart';
import 'package:investigator/features/analysis/model/analysis_response.dart';
import 'package:investigator/features/analysis/video_analysis/presentation/view_model/cubit/video_analysis_cubit.dart';
import 'package:investigator/features/analysis/video_analysis/presentation/view_model/cubit/video_analysis_states.dart';

class VideoAnalysisScreen extends StatelessWidget {
  const VideoAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing(context);

    return BlocProvider<VideoAnalysisCubit>(
      create: (context) => getIt<VideoAnalysisCubit>(),
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
            'تحليل الفيديوهات',
            style: TextStyle(
              color: Color(0xFF1E255E),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        // استخدام BlocConsumer للاستماع للحالات وإدارة الواجهة
        body: BlocConsumer<VideoAnalysisCubit, VideoAnalysisState>(
          listener: (context, state) {
            if (state is VideoAnalysisSuccess) {
              // عند النجاح، ننتقل لشاشة النتيجة ونمرر الـ Enum الخاص بالفيديو
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AnalysisResultScreen(
                    data: state.response,
                    fileType: FileType.video,
                  ),
                ),
              );
            } else if (state is VideoAnalysisError) {
              // إظهار رسالة الخطأ للمستخدم في حال فشل المعالجة أو صيغة الملف
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
                    // عرض مؤشر التحميل عند معالجة الفيديو
                    if (state is VideoAnalysisLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Color(0xFFE2E8F0),
                          color: Color(0xFF8B5CF6),
                        ),
                      ),

                    CustomFileUploader(
                      title: 'تحليل الفيديوهات',
                      description:
                          'ارفع مقطع فيديو لكشف الديب فيك والتلاعب البصري',
                      uploadClickText: state is VideoAnalysisLoading
                          ? 'جاري تحليل الفيديو ومطابقته...'
                          : 'اضغط هنا لرفع الملف',
                      uploadDragText: 'أو اسحب وأفلت الملف هنا',
                      footerText:
                          'لا يتم حفظ أي ملفات أو محادثات، تتم جميع عمليات التحليل والمعالجة بشكل مؤقت فقط حفاظاً على خصوصية المستخدم.',
                      topIcon: Icons.videocam_outlined,
                      uploadIcon: Icons.file_upload_outlined,
                      primaryColor: const Color(0xFF8B5CF6),
                      backgroundColor: Colors.transparent,
                      cardBackgroundColor: Colors.white,
                      textColor: Colors.white,
                      onFileSelected: (file) {
                        if (state is VideoAnalysisLoading) return;
                        if (file != null) {
                          final path = file.path.toLowerCase();

                          // تحقق سريع من امتداد الفيديو المدعوم
                          if (path.endsWith('.mp4') ||
                              path.endsWith('.mov') ||
                              path.endsWith('.avi')) {
                            debugPrint("تم اختيار فيديو: ${file.name}");

                            // استدعاء الـ Cubit لبدء التحليل
                            context.read<VideoAnalysisCubit>().analyzeVideo(
                                  File(file.path),
                                );
                          } else {
                            // إظهار خطأ مباشر إذا لم تكن الصيغة مدعومة
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'عذراً، يجب اختيار فيديو بصيغة MP4 أو MOV أو AVI فقط',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
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
