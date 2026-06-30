import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/core/widgets/dashed_rect_painter.dart';

class CustomFileUploader extends StatelessWidget {
  final String title;
  final String description;
  final String uploadClickText;
  final String uploadDragText;
  final String footerText;
  final IconData? topIcon;
  final IconData? uploadIcon;
  final Color primaryColor;
  final Color backgroundColor;
  final Color cardBackgroundColor;
  final Color textColor;

  /// بدل PlatformFile → XFile
  final Function(XFile?) onFileSelected;

  const CustomFileUploader({
    super.key,
    required this.title,
    required this.description,
    required this.uploadClickText,
    required this.uploadDragText,
    required this.footerText,
    this.topIcon = Icons.image,
    this.uploadIcon = Icons.cloud_upload_outlined,
    this.primaryColor = const Color(0xFF2563EB),
    this.backgroundColor = const Color(0xFFF8FAFC),
    this.cardBackgroundColor = Colors.white,
    this.textColor = Colors.white,
    required this.onFileSelected,
  });

  Future<void> _pickFile() async {
    try {
      final XFile? file = await openFile(
        acceptedTypeGroups: const [
          XTypeGroup(
            label: 'all files',
            extensions: [
              'jpg',
              'png',
              'jpeg',
              'mp4',
              'mp3',
              'wav',
              'pdf',
              'doc',
              'docx',
            ],
          ),
        ],
      );

      if (file != null) {
        onFileSelected(file);
      } else {
        onFileSelected(null);
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing(context);

    final double opacityBackgroundValue =
        primaryColor == const Color(0xFF118EA6) ? 0.03 : 0.02;

    final double opacityFooterValue =
        primaryColor == const Color(0xFF118EA6) ? 0.06 : 0.05;

    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: spacing.heightMd,
                    horizontal: spacing.widthMd,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: spacing.paddingAllSmall,
                        decoration: BoxDecoration(
                          color: const Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(topIcon, size: 44, color: textColor),
                      ),
                      SizedBox(height: spacing.heightSm),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Upload area
                Padding(
                  padding: spacing.paddingAllMedium,
                  child: GestureDetector(
                    onTap: _pickFile,
                    child: CustomPaint(
                      painter: DashedRectPainter(
                        color: primaryColor.withValues(alpha: 0.6),
                        strokeWidth: 1.5,
                        gap: 5.0,
                        dashLength: 8.0,
                        radius: 16.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: spacing.heightMd,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(
                            alpha: opacityBackgroundValue,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(uploadIcon, size: 40, color: primaryColor),
                            SizedBox(height: spacing.heightXs),
                            Text(
                              uploadClickText,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: spacing.heightXs / 2),
                            Text(
                              uploadDragText,
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: spacing.heightSm),

          // Footer
          Container(
            padding: EdgeInsets.symmetric(
              vertical: spacing.heightXs * 1.5,
              horizontal: spacing.widthSm,
            ),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: opacityFooterValue),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, size: 20, color: primaryColor),
                SizedBox(width: spacing.widthXs),
                const Expanded(
                  child: Text(
                    'لا يتم حفظ أي ملفات أو محادثات، تتم جميع عمليات التحليل بشكل مؤقت فقط.',
                    style: TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
