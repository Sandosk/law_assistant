import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investigator/core/di/service_locator.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/core/widgets/analysis_result_screen.dart';
import 'package:investigator/core/widgets/custom_file_uploader.dart';
import 'package:investigator/features/analysis/audio_analysis/presentation/view_model/cubit/audio_analysis_cubit.dart';
import 'package:investigator/features/analysis/audio_analysis/presentation/view_model/cubit/audio_analysis_states.dart';
import 'package:investigator/features/analysis/model/analysis_response.dart';

class AudioAnalysisScreen extends StatelessWidget {
  const AudioAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing(context);

    // استخدام BlocProvider وحقن الـ Cubit من الـ GetIt مباشرة
    return BlocProvider<AudioAnalysisCubit>(
      create: (context) => getIt<AudioAnalysisCubit>(),
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
            'تحليل الصوت',
            style: TextStyle(
              color: Color(0xFF1E255E),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        // استخدام BlocConsumer للاستماع للحالات وعمل الـ UI المناسب
        body: BlocConsumer<AudioAnalysisCubit, AudioAnalysisState>(
          listener: (context, state) {
            if (state is AudioAnalysisSuccess) {
              // عند النجاح يتم الانتقال فوراً إلى شاشة النتيجة مع تمرير البيانات والـ Enum
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AnalysisResultScreen(
                    data: state.response,
                    fileType: FileType.audio,
                  ),
                ),
              );
            } else if (state is AudioAnalysisError) {
              // إظهار رسالة الخطأ سواء كانت بسبب الامتداد أو الـ API
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                    ), // أو أي خط تستخدمه
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
                    // إذا كانت الحالة Loading، نعرض مؤشر تحميل فوق الـ Uploader أو نمنع الضغط
                    if (state == AudioAnalysisLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Color(0xFFE2E8F0),
                          color: Color(0xFF118EA6),
                        ),
                      ),

                    CustomFileUploader(
                      title: 'تحليل الصوت',
                      description:
                          'ارفع ملف صوتي لكشف ما إذا كان صوتاً حقيقياً أم مولداً',
                      uploadClickText: state is AudioAnalysisLoading
                          ? 'جاري التحليل المعالجة...'
                          : 'اضغط هنا لرفع الملف',
                      uploadDragText: 'أو اسحب وأفلت الملف هنا',
                      footerText:
                          'لا يتم حفظ أي ملفات أو محادثات، تتم جميع عمليات التحليل والمعالجة بشكل مؤقت فقط حفاظاً على خصوصية المستخدم.',
                      topIcon: Icons.mic_none_outlined,
                      uploadIcon: Icons.file_upload_outlined,
                      primaryColor: const Color(0xFF118EA6),
                      backgroundColor: Colors.transparent,
                      cardBackgroundColor: Colors.white,
                      textColor: Colors.white,
                      onFileSelected: (XFile? file) {
                        // دائماً نمرر دالة غير قابلة لأن تكون null لأن التايب المطلوب غير قابل للـ null
                        if (state is AudioAnalysisLoading) {
                          return; // تعطيل الاختيار أثناء التحميل
                        }
                        if (file != null) {
                          debugPrint("تم اختيار ملف صوتي: ${file.name}");
                          // استدعاء الدالة من الـ Cubit عبر الـ context وتمرير الملف بعد تحويله لـ File
                          context.read<AudioAnalysisCubit>().analyzeAudio(
                                File(file.path),
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
