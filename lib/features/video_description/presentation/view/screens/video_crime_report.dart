import 'package:flutter/material.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/features/video_description/data/model/video_description_entity.dart';

const Color primaryRed = Color(0xFFDC2626);
const Color darkNavy = Color(0xFF1E255E);
const Color background = Color(0xFFF4F7FC);
const Color textDark = Color(0xFF1E293B);

const Color success = Color(0xFF10B981);
const Color card = Colors.white;
const Color border = Color(0xFFE2E8F0);
const Color lightRed = Color(0xFFFEE2E2);
const Color lightBlue = Color(0xFFEFF6FF);

class VideoCriminalReportScreen extends StatefulWidget {
  final VideoDescriptionEntity entity;

  const VideoCriminalReportScreen({
    super.key,
    required this.entity,
  });

  @override
  State<VideoCriminalReportScreen> createState() =>
      _VideoCriminalReportScreenState();
}

class _VideoCriminalReportScreenState extends State<VideoCriminalReportScreen>
    with SingleTickerProviderStateMixin {
  String? expandedId;

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.entity.result;
    final spacing = Spacing(context);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        centerTitle: true,
        title: const Text(
          "التقرير الجنائي",
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: CurvedAnimation(
          parent: controller,
          curve: Curves.easeIn,
        ),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _buildHeader(result, spacing),
            const SizedBox(height: 20),
            _buildExpandableCard(
              id: "report",
              title: "التقرير الجنائي",
              icon: Icons.report_gmailerrorred,
              color: primaryRed,
              text: result.crimeReport,
            ),
            _buildExpandableCard(
              id: "summary",
              title: "الملخص القانوني",
              icon: Icons.balance,
              color: success,
              text: result.legalSummary,
            ),
            _buildExpandableCard(
              id: "answer",
              title: "استنتاج الذكاء الاصطناعي",
              icon: Icons.smart_toy,
              color: darkNavy,
              text: result.answer,
            ),
            _buildArticles(result.retrievedArticles),
            _buildExpandableCard(
              id: "disclaimer",
              title: "إخلاء المسؤولية",
              icon: Icons.warning_amber,
              color: Colors.orange,
              text: result.disclaimer,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Result result, Spacing spacing) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      tween: Tween(begin: 0.9, end: 1),
      curve: Curves.easeOutBack,
      builder: (_, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        height: spacing.heightXl * 3.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              darkNavy,
              Color(0xff27347D),
              primaryRed,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: primaryRed.withOpacity(.25),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative Circles
            Positioned(
              right: -40,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -50,
              bottom: -60,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.15),
                      border: Border.all(
                        color: Colors.white24,
                      ),
                    ),
                    child: const Icon(
                      Icons.gavel_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "التقرير الجنائي",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "رقم القضية #${result.caseId}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white24,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.entity.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableCard({
    required String id,
    required String title,
    required IconData icon,
    required Color color,
    required String text,
  }) {
    final expanded = expandedId == id;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: expanded ? color : border,
          width: expanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: color.withOpacity(
                0.12), // Fixed: Reduced opacity to prevent material ink errors
          )
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: color.withOpacity(0.1),
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          onExpansionChanged: (v) {
            setState(() {
              expandedId = v ? id : null;
            });
          },
          initiallyExpanded: expanded,
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          trailing: const SizedBox(),
          leading: AnimatedRotation(
            turns: expanded ? .25 : 0,
            duration: const Duration(milliseconds: 250),
            child: CircleAvatar(
              backgroundColor: color,
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
          title: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: expanded ? color : textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                text,
                style: const TextStyle(
                  color: textDark,
                  height: 1.7,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildArticles(List<RetrievedArticles> articles) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        leading: const Icon(
          Icons.menu_book,
          color: primaryRed,
        ),
        title: const Text(
          "المواد القانونية المسترجعة",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: articles.map((article) {
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: lightRed,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Article ${article.articleNumber}",
                        style: const TextStyle(
                          color: primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Text(
                        article.lawName,
                        textAlign: TextAlign
                            .start, // Fixed: Changed to start for English text alignment
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  article.text,
                  style: const TextStyle(
                    color: textDark,
                    height: 1.6,
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
