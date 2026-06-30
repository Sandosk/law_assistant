import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/features/legal_chatbot/data/model/result_entity.dart';
import 'package:investigator/features/legal_chatbot/presentation/view_model/cubit/leagel_chatbot_states.dart';
import 'package:investigator/features/legal_chatbot/presentation/view_model/cubit/legal_chatbot_cubit.dart';

class LegalChatScreen extends StatelessWidget {
  const LegalChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LegalChatCubit>(
      create: (_) => GetIt.instance<LegalChatCubit>(),
      child: const _LegalChatBody(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _LegalChatBody extends StatefulWidget {
  const _LegalChatBody();

  @override
  State<_LegalChatBody> createState() => _LegalChatBodyState();
}

class _LegalChatBodyState extends State<_LegalChatBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Color primaryBlue = const Color(0xFF2563EB);
  final Color darkNavy = const Color(0xFF1E255E);
  final Color chatBgColor = const Color(0xFFF4F7FC);
  final Color accentLightBlue = const Color(0xFFEFF6FF);

  String? _expandedSectionId;
  String _currentLoadingHint = "جاري فحص أركان الجريمة...";
  Timer? _hintTimer;

  final List<String> _loadingHints = [
    "💡 هل تعلم؟ المادة 55 من الدستور تكفل للمتهم الحق في الصمت تماماً أثناء الاستجواب.",
    "🔍 يقوم المساعد الآن بالبحث في أكثر من 15,000 مادة قانونية جنائية...",
    "⚖️ جاري مراجعة سوابق محكمة النقض المصرية لضمان دقة الرد المستندي...",
    "🛡️ تذكر دائماً: المتهم بريء حتى تثبت إدانته في محاكمة قانونية عادلة.",
    "📊 نتحقق الآن من الأركان المادية والمعنوية للواقعة المذكورة...",
    "⏳ ثوانٍ معدودة... يتم صياغة الملخص القانوني وربطه بالمواد الدستورية.",
  ];

  final List<String> _suggestedQuestions = [
    'ما هي عقوبة السرقة في القانون المصري？',
    'كيف أبلغ عن جريمة إلكترونية？',
    'ما هي حقوق المتهم في مرحلة الاستجواب؟',
  ];

  // 👈 تعديل نوع الـ Lists هنا لتتوافق مع الـ Entity المؤمنة والجديدة
  final List<Map<String, dynamic>> _messages = [
    {
      'id': 'welcome',
      'text':
          'مرحباً بك في المساعد القانوني الذكي. أنا هنا للإجابة على استفساراتك القانونية المتعلقة بالقانون الجنائي المصري. كيف يمكنني مساعدتك اليوم؟',
      'isUser': false,
      'isLoading': false,
      'retrieved_articles': <RetrievedArticles>[],
      'similar_cases': <SimilarCases>[],
    },
  ];

  @override
  void dispose() {
    _hintTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startLoadingHints() {
    _hintTimer?.cancel();
    _currentLoadingHint = _loadingHints[Random().nextInt(_loadingHints.length)];
    _hintTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      setState(() {
        _currentLoadingHint =
            _loadingHints[Random().nextInt(_loadingHints.length)];
      });
    });
  }

  void _stopLoadingHints() {
    _hintTimer?.cancel();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(BuildContext context, String question) {
    if (question.trim().isEmpty) return;

    final String msgId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _messages.add({
        'id': '${msgId}_user',
        'text': question,
        'isUser': true,
        'isLoading': false,
      });
    });

    _scrollToBottom();
    context.read<LegalChatCubit>().sendLegalQuestion(question);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing(context);

    return BlocConsumer<LegalChatCubit, LegalChatState>(
      listener: (context, state) {
        if (state is LegalChatLoading) {
          final String msgId = DateTime.now().millisecondsSinceEpoch.toString();
          setState(() {
            // للتأكيد: بنشيل أي كارد لودينج قديم قبل ما نحط الجديد
            _messages.removeWhere((msg) => msg['isLoading'] == true);
            _messages.add({
              'id': '${msgId}_bot_loading',
              'text': '',
              'isUser': false,
              'isLoading': true,
            });
          });
          _scrollToBottom();
          _startLoadingHints();
        } else if (state is LegalChatSuccess) {
          _stopLoadingHints();
          final String msgId = DateTime.now().millisecondsSinceEpoch.toString();

          setState(() {
            // إزالة كارد التحليل فوراً لأن النتيجة النهائية وصلت من الـ Polling الدوري
            _messages.removeWhere((msg) => msg['isLoading'] == true);
            _messages.add({
              'id': '${msgId}_bot',
              'text': state.result.result
                  .answer, // 👈 تعديل طريقة القراءة حسب الـ Model الجديد
              'isUser': false,
              'isLoading': false,
              'retrieved_articles': state.result.result.retrievedArticles,
              'similar_cases': state.result.result.similarCases,
            });
          });
          _scrollToBottom();
        } else if (state is LegalChatError) {
          _stopLoadingHints();
          setState(() {
            _messages.removeWhere((msg) => msg['isLoading'] == true);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('حدث خطأ: ${state.message}', textAlign: TextAlign.right),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isLoadingState = state is LegalChatLoading;

        return Scaffold(
          backgroundColor: chatBgColor,
          appBar: _buildAppBar(spacing),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: spacing.paddingHorizontal.copyWith(
                    top: spacing.heightSm,
                    bottom: spacing.heightSm,
                  ),
                  children: [
                    if (_messages.length <= 1 && !isLoadingState)
                      _buildSuggestedQuestionsSection(context, spacing),
                    ..._messages.map((msg) => _buildChatGroup(msg, spacing)),
                  ],
                ),
              ),
              _buildPrivacyNotice(spacing),
              _buildInputBar(context, spacing, isLoadingState),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildChatGroup(Map<String, dynamic> msg, Spacing spacing) {
    final bool isUser = msg['isUser'];

    // 👈 استخدام الـ Types الجديدة المؤمنة لمنع الـ Casting Error
    final List<RetrievedArticles> articles =
        msg['retrieved_articles'] as List<RetrievedArticles>? ?? [];
    final List<SimilarCases> cases =
        msg['similar_cases'] as List<SimilarCases>? ?? [];

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _buildChatBubble(msg, spacing),
        if (!isUser && articles.isNotEmpty)
          _buildExpansionCard(msg['id'], 'articles', articles, spacing),
        if (!isUser && cases.isNotEmpty)
          _buildExpansionCard(msg['id'], 'cases', cases, spacing),
        SizedBox(height: spacing.heightXs),
      ],
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> msg, Spacing spacing) {
    final bool isUser = msg['isUser'];
    final bool isLoading = msg['isLoading'] ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.heightXs * 0.2),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: spacing.heightLg,
              height: spacing.heightLg,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/chatbot.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: spacing.paddingAllSmall * 1.3,
              decoration: BoxDecoration(
                color: isUser ? primaryBlue : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: isLoading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "جاري التحليل والمطابقة الدوري كل دقيقة...",
                              style: TextStyle(
                                  color: darkNavy,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: primaryBlue),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing.heightXs),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _currentLoadingHint,
                            key: ValueKey(_currentLoadingHint),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                                height: 1.4,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      msg['text'] ?? '',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: isUser ? Colors.white : darkNavy,
                          fontSize: 13,
                          height: 1.5),
                    ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: spacing.widthXs),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300], shape: BoxShape.circle),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpansionCard(
      String msgId, String type, List<dynamic> items, Spacing spacing) {
    final String uniqueKey = '${msgId}_$type';
    final bool isExpanded = _expandedSectionId == uniqueKey;
    final bool isArticles = type == 'articles';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
      margin: EdgeInsets.only(
          top: spacing.heightXs, bottom: spacing.heightXs * 0.5, left: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: isExpanded ? primaryBlue : const Color(0xFFE2E8F0),
            width: isExpanded ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
              color: isExpanded
                  ? primaryBlue.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.01),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: ExpansionTile(
        key: ValueKey(uniqueKey),
        initiallyExpanded: isExpanded,
        shape: const Border(),
        collapsedShape: const Border(),
        onExpansionChanged: (expanded) {
          setState(() {
            _expandedSectionId = expanded ? uniqueKey : null;
          });
        },
        tilePadding:
            EdgeInsets.symmetric(horizontal: spacing.widthSm, vertical: 4),
        leading: AnimatedRotation(
          turns: isExpanded ? 0.25 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: Container(
            decoration: BoxDecoration(
                color: isExpanded ? accentLightBlue : const Color(0xFFF1F5F9),
                shape: BoxShape.circle),
            child: Icon(Icons.arrow_back_ios_rounded,
                color: isExpanded ? primaryBlue : Colors.grey[600], size: 11),
          ),
        ),
        trailing: const SizedBox.shrink(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                isArticles
                    ? 'المستندات القانونية والمواد المستخدمة'
                    : 'حالات وقضايا مشابهة تم العثور عليها',
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: isExpanded ? primaryBlue : darkNavy,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(width: spacing.widthXs),
            Icon(isArticles ? Icons.gavel_outlined : Icons.folder_open_outlined,
                size: 16, color: isExpanded ? primaryBlue : Colors.grey[600]),
          ],
        ),
        children: [
          Padding(
            padding: spacing.paddingAllSmall * 1.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items.map((item) {
                if (isArticles) {
                  final article = item as RetrievedArticles;
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: spacing.heightXs),
                    padding: spacing.paddingAllSmall * 1.2,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEDF2F7))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: accentLightBlue,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                // 👈 تعامل آمن مع رقم المادة الـ int الجديد وعرضه بشكل سليم
                                article.articleNumber == 0
                                    ? 'N/A'
                                    : article.articleNumber.toString(),
                                style: TextStyle(
                                    color: primaryBlue,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(article.lawName,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: darkNavy,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing.heightXs),
                        Text(article.text,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 11,
                                height: 1.5)),
                      ],
                    ),
                  );
                } else {
                  final caseItem = item as SimilarCases;
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: spacing.heightXs),
                    padding: spacing.paddingAllSmall * 1.2,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEDF2F7))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(caseItem.caseLabel,
                            style: TextStyle(
                                color: darkNavy,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.right),
                        SizedBox(height: spacing.heightXs * 0.5),
                        Text(caseItem.summary,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 11,
                                height: 1.4)),
                        SizedBox(height: spacing.heightXs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.picture_as_pdf,
                                color: Colors.red[400], size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                caseItem.sourceFile,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Spacing spacing) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: Colors.green, size: 8),
          const SizedBox(width: 6),
          Column(
            children: [
              const Text('المساعد القانوني الذكي',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              const Text('قانون جنائي مصري',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          SizedBox(width: spacing.heightLg * 1.1),
          SizedBox(
            width: spacing.heightXl,
            height: spacing.heightXl,
            child: Image.asset('assets/images/chatbot.png', fit: BoxFit.fill),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.maybePop(context),
      ),
    );
  }

  Widget _buildSuggestedQuestionsSection(
      BuildContext context, Spacing spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: spacing.heightXs, top: 4),
          child: const Text('أسئلة مقترحة',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _suggestedQuestions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () =>
                  _handleSendMessage(context, _suggestedQuestions[index]),
              child: Container(
                margin: EdgeInsets.only(bottom: spacing.heightXs),
                padding: spacing.paddingHorizontal.copyWith(
                    top: spacing.heightXs * 1.2,
                    bottom: spacing.heightXs * 1.2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Text(_suggestedQuestions[index],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: darkNavy,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ),
            );
          },
        ),
        SizedBox(height: spacing.heightXs),
      ],
    );
  }

  Widget _buildPrivacyNotice(Spacing spacing) {
    return Container(
      width: double.infinity,
      margin: spacing.paddingHorizontal.copyWith(
          top: spacing.heightXs * 0.5, bottom: spacing.heightXs * 0.5),
      padding: spacing.paddingHorizontal.copyWith(
          top: spacing.heightXs * 1.2, bottom: spacing.heightXs * 1.2),
      decoration: BoxDecoration(
          color: const Color(0x0D2563EB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x1A2563EB))),
      child: Row(
        children: [
          Icon(Icons.security,
              size: 16, color: primaryBlue.withValues(alpha: 0.7)),
          SizedBox(width: spacing.widthXs),
          Expanded(
            child: Text(
              'لا يتم حفظ أي ملفات أو محادثات. تتم جميع عمليات التحليل والمعالجة بشكل مؤقت حفاظاً على الخصوصية.',
              style:
                  TextStyle(color: Colors.grey[600], fontSize: 10, height: 1.4),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(
      BuildContext context, Spacing spacing, bool isLoadingState) {
    return Container(
      padding: spacing.paddingAllSmall * 1.2,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: isLoadingState
                  ? null
                  : () {
                      if (_messageController.text.trim().isNotEmpty) {
                        _handleSendMessage(context, _messageController.text);
                        _messageController.clear();
                      }
                    },
              child: Container(
                padding: spacing.paddingAllSmall * 1.1,
                decoration: BoxDecoration(
                    color: isLoadingState ? Colors.grey : primaryBlue,
                    shape: BoxShape.circle),
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
            SizedBox(width: spacing.widthXs * 1.5),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(24)),
                child: TextField(
                  controller: _messageController,
                  enabled: !isLoadingState,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: 'اسأل سؤالك القانوني هنا...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
