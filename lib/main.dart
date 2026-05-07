import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'components/app_footer.dart';
import 'components/app_header.dart';

void main() {
  runApp(const LecoFeedbackApp());
}

class LecoFeedbackApp extends StatelessWidget {
  const LecoFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LECO Feedback',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.lecoYellow,
          primary: AppColors.lecoYellow,
        ),
        fontFamily: 'Inter',
      ),
      home: const FeedbackKioskScreen(api: FeedbackApi()),
    );
  }
}

class FeedbackKioskScreen extends StatefulWidget {
  const FeedbackKioskScreen({super.key, required this.api});

  final FeedbackApi api;

  @override
  State<FeedbackKioskScreen> createState() => _FeedbackKioskScreenState();
}

class _FeedbackKioskScreenState extends State<FeedbackKioskScreen> {
  FeedbackSession? session;
  int? selectedRating;
  bool isLoading = true;
  bool isSubmitting = false;
  bool isThankYouVisible = false;
  int remainingSeconds = 10;
  Timer? closeTimer;

  @override
  void initState() {
    super.initState();
    loadSession();
  }

  @override
  void dispose() {
    closeTimer?.cancel();
    super.dispose();
  }

  Future<void> loadSession() async {
    closeTimer?.cancel();
    setState(() {
      isLoading = true;
      isSubmitting = false;
      isThankYouVisible = false;
      remainingSeconds = 10;
      selectedRating = null;
    });

    final nextSession = await widget.api.fetchFeedbackSession();

    if (!mounted) {
      return;
    }

    setState(() {
      session = nextSession;
      isLoading = false;
    });
  }

  Future<void> submitFeedback() async {
    final activeSession = session;
    final rating = selectedRating;
    if (activeSession == null || rating == null || isSubmitting) {
      return;
    }

    setState(() => isSubmitting = true);

    await widget.api.submitFeedback(
      FeedbackPayload(
        questionId: activeSession.questionId,
        queueId: activeSession.queueId,
        language: activeSession.language,
        rating: rating,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isSubmitting = false;
      isThankYouVisible = true;
      remainingSeconds = 10;
    });

    startThankYouCountdown();
  }

  void startThankYouCountdown() {
    closeTimer?.cancel();
    closeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (remainingSeconds <= 1) {
        timer.cancel();
        loadSession();
        return;
      }

      setState(() => remainingSeconds--);
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeSession = session;
    final language = activeSession?.language ?? 'en';
    final copy = AppCopy.of(language);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          return ColoredBox(
            color: AppColors.canvas,
            child: Column(
              children: [
                AppHeader(
                  title: copy.brandTitle,
                  subtitle: copy.brandSubtitle,
                  branchLabel: activeSession == null
                      ? copy.loading
                      : '${copy.branchPrefix} · ${activeSession.branchName}',
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      child: isLoading
                          ? const _LoadingPanel()
                          : isThankYouVisible && activeSession != null
                          ? _ThankYouPanel(
                              key: const ValueKey('thankYou'),
                              copy: copy,
                              queueId: activeSession.queueId,
                              remainingSeconds: remainingSeconds,
                            )
                          : _FeedbackBody(
                              key: const ValueKey('feedback'),
                              copy: copy,
                              isWide: isWide,
                              isSubmitting: isSubmitting,
                              selectedRating: selectedRating,
                              options: localizedOptions(copy),
                              onChanged: (rating) =>
                                  setState(() => selectedRating = rating),
                              onSubmit: submitFeedback,
                            ),
                    ),
                  ),
                ),
                AppFooter(
                  poweredByLabel: copy.poweredBy,
                  productName: copy.productName,
                  counterLabel: activeSession == null
                      ? copy.counterFallback
                      : '${copy.version} · ${copy.counterPrefix} ${activeSession.counterId}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeedbackBody extends StatelessWidget {
  const _FeedbackBody({
    super.key,
    required this.copy,
    required this.isWide,
    required this.isSubmitting,
    required this.selectedRating,
    required this.options,
    required this.onChanged,
    required this.onSubmit,
  });

  final AppCopy copy;
  final bool isWide;
  final bool isSubmitting;
  final int? selectedRating;
  final List<FeedbackOption> options;
  final ValueChanged<int> onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return Row(
        children: [
          Expanded(
            child: _IntroPanel(
              copy: copy,
              onSubmit: onSubmit,
              isSubmitting: isSubmitting,
              hasSelection: selectedRating != null,
            ),
          ),
          const SizedBox(width: 64),
          Expanded(
            child: _FeedbackStack(
              options: options,
              selectedRating: selectedRating,
              onChanged: onChanged,
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _IntroPanel(
          copy: copy,
          onSubmit: onSubmit,
          isSubmitting: isSubmitting,
          hasSelection: selectedRating != null,
        ),
        const SizedBox(height: 34),
        _FeedbackStack(
          options: options,
          selectedRating: selectedRating,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _IntroPanel extends StatelessWidget {
  const _IntroPanel({
    required this.copy,
    required this.onSubmit,
    required this.isSubmitting,
    required this.hasSelection,
  });

  final AppCopy copy;
  final VoidCallback onSubmit;
  final bool isSubmitting;
  final bool hasSelection;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SmallAccentLine(),
              const SizedBox(width: 12),
              Text(
                copy.quickFeedback,
                style: const TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            copy.heading,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 56,
              fontWeight: FontWeight.w700,
              height: 1.04,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            copy.description,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 17,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 240,
            height: 64,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 24,
                    spreadRadius: -10,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withValues(alpha: 0.86),
                          Colors.black.withValues(alpha: 0.72),
                        ],
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: isSubmitting || !hasSelection ? null : onSubmit,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                copy.submit,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: isSubmitting
                                    ? const Padding(
                                        key: ValueKey('loading'),
                                        padding: EdgeInsets.only(left: 10),
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        key: ValueKey('notLoading'),
                                        width: 0,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallAccentLine extends StatelessWidget {
  const _SmallAccentLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 2,
      decoration: BoxDecoration(
        color: AppColors.lecoYellow,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _FeedbackStack extends StatelessWidget {
  const _FeedbackStack({
    required this.options,
    required this.selectedRating,
    required this.onChanged,
  });

  final List<FeedbackOption> options;
  final int? selectedRating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in options) ...[
              _FeedbackOptionCard(
                option: option,
                isSelected: selectedRating == option.rating,
                onTap: () => onChanged(option.rating),
              ),
              if (option != options.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _FeedbackOptionCard extends StatelessWidget {
  const _FeedbackOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final FeedbackOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: '${option.title}, ${option.subtitle}',
      child: AnimatedScale(
        scale: isSelected ? 1.015 : 1,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          height: 94,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lecoYellow : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isSelected
                  ? Colors.black.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isSelected ? 0.20 : 0.02),
                blurRadius: isSelected ? 24 : 2,
                spreadRadius: isSelected ? -12 : 0,
                offset: Offset(0, isSelected ? 10 : 1),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFFF3F3EF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        option.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 22),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.title,
                            style: const TextStyle(
                              color: Color(0xD8111111),
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            option.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: isSelected ? 1 : 0.22,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: isSelected ? Colors.black : AppColors.muted,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThankYouPanel extends StatelessWidget {
  const _ThankYouPanel({
    super.key,
    required this.copy,
    required this.queueId,
    required this.remainingSeconds,
  });

  final AppCopy copy;
  final String queueId;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.lecoYellow,
              borderRadius: BorderRadius.circular(28),
            ),
            alignment: Alignment.center,
            child: const Text('🙏', style: TextStyle(fontSize: 42)),
          ),
          const SizedBox(height: 28),
          Text(
            copy.thankYouTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 46,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            copy.thankYouMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 17,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            '${copy.queueIdLabel}: $queueId',
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${copy.closingIn} $remainingSeconds${copy.secondsSuffix}',
            style: const TextStyle(
              color: Color(0xFF9A9A9A),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.lecoYellow),
    );
  }
}

class FeedbackOption {
  const FeedbackOption(this.rating, this.emoji, this.title, this.subtitle);

  final int rating;
  final String emoji;
  final String title;
  final String subtitle;
}

List<FeedbackOption> localizedOptions(AppCopy copy) {
  return [
    FeedbackOption(5, '😍', copy.veryGood, copy.veryGoodSubtitle),
    FeedbackOption(4, '🙂', copy.good, copy.goodSubtitle),
    FeedbackOption(3, '😐', copy.okay, copy.okaySubtitle),
    FeedbackOption(2, '😕', copy.bad, copy.badSubtitle),
    FeedbackOption(1, '😡', copy.veryBad, copy.veryBadSubtitle),
  ];
}

class FeedbackSession {
  const FeedbackSession({
    required this.questionId,
    required this.queueId,
    required this.language,
    required this.branchName,
    required this.counterId,
  });

  final int questionId;
  final String queueId;
  final String language;
  final String branchName;
  final String counterId;

  factory FeedbackSession.fromJson(Map<String, dynamic> json) {
    return FeedbackSession(
      questionId: json['questionId'] as int,
      queueId: json['queueId'] as String,
      language: json['language'] as String,
      branchName: json['branchName'] as String? ?? 'Dehiwala',
      counterId: json['counterId'] as String? ?? '03',
    );
  }
}

class FeedbackPayload {
  const FeedbackPayload({
    required this.questionId,
    required this.queueId,
    required this.language,
    required this.rating,
  });

  final int questionId;
  final String queueId;
  final String language;
  final int rating;

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'queueId': queueId,
      'language': language,
      'rating': rating,
    };
  }
}

class FeedbackApi {
  const FeedbackApi();

  Future<FeedbackSession> fetchFeedbackSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    return FeedbackSession.fromJson({
      'questionId': 101,
      'queueId': 'Q-247',
      'language': 'en',
      'branchName': 'Dehiwala',
      'counterId': '03',
    });
  }

  Future<void> submitFeedback(FeedbackPayload payload) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    debugPrint('Feedback payload: ${payload.toJson()}');
  }
}

class AppCopy {
  const AppCopy({
    required this.brandTitle,
    required this.brandSubtitle,
    required this.branchPrefix,
    required this.quickFeedback,
    required this.heading,
    required this.description,
    required this.submit,
    required this.poweredBy,
    required this.productName,
    required this.version,
    required this.counterPrefix,
    required this.counterFallback,
    required this.loading,
    required this.thankYouTitle,
    required this.thankYouMessage,
    required this.queueIdLabel,
    required this.closingIn,
    required this.secondsSuffix,
    required this.veryGood,
    required this.veryGoodSubtitle,
    required this.good,
    required this.goodSubtitle,
    required this.okay,
    required this.okaySubtitle,
    required this.bad,
    required this.badSubtitle,
    required this.veryBad,
    required this.veryBadSubtitle,
  });

  final String brandTitle;
  final String brandSubtitle;
  final String branchPrefix;
  final String quickFeedback;
  final String heading;
  final String description;
  final String submit;
  final String poweredBy;
  final String productName;
  final String version;
  final String counterPrefix;
  final String counterFallback;
  final String loading;
  final String thankYouTitle;
  final String thankYouMessage;
  final String queueIdLabel;
  final String closingIn;
  final String secondsSuffix;
  final String veryGood;
  final String veryGoodSubtitle;
  final String good;
  final String goodSubtitle;
  final String okay;
  final String okaySubtitle;
  final String bad;
  final String badSubtitle;
  final String veryBad;
  final String veryBadSubtitle;

  static AppCopy of(String language) {
    switch (language.toLowerCase()) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      case 'en':
      default:
        return en;
    }
  }

  static const en = AppCopy(
    brandTitle: 'LECO',
    brandSubtitle: 'Customer feedback',
    branchPrefix: 'Branch',
    quickFeedback: 'Quick feedback',
    heading: 'How did we\ndo today?',
    description:
        'Your honest rating helps us improve our service at every counter.',
    submit: 'Submit',
    poweredBy: 'Powered by',
    productName: 'LECO Digital',
    version: 'v2.4',
    counterPrefix: 'Counter',
    counterFallback: 'v2.4 · Counter --',
    loading: 'Loading',
    thankYouTitle: 'Thank you!',
    thankYouMessage: 'Your feedback has been recorded successfully.',
    queueIdLabel: 'Queue ID',
    closingIn: 'Closing in',
    secondsSuffix: 's',
    veryGood: 'Very good',
    veryGoodSubtitle: 'Excellent - thank you!',
    good: 'Good',
    goodSubtitle: 'A pleasant experience.',
    okay: 'Okay',
    okaySubtitle: 'Service was alright.',
    bad: 'Bad',
    badSubtitle: 'Below expectations.',
    veryBad: 'Very bad',
    veryBadSubtitle: "We need to do better - we're sorry.",
  );

  static const si = AppCopy(
    brandTitle: 'LECO',
    brandSubtitle: 'පාරිභෝගික ප්‍රතිචාර',
    branchPrefix: 'ශාඛාව',
    quickFeedback: 'කෙටි ප්‍රතිචාර',
    heading: 'අද අපගේ\nසේවාව කොහොමද?',
    description: 'ඔබගේ අවංක ඇගයීම අපගේ සේවාව වැඩි දියුණු කිරීමට උපකාරී වේ.',
    submit: 'යවන්න',
    poweredBy: 'බලගැන්වීම',
    productName: 'LECO Digital',
    version: 'v2.4',
    counterPrefix: 'කවුන්ටරය',
    counterFallback: 'v2.4 · කවුන්ටරය --',
    loading: 'පූරණය වෙමින්',
    thankYouTitle: 'ස්තූතියි!',
    thankYouMessage: 'ඔබගේ ප්‍රතිචාරය සාර්ථකව සටහන් විය.',
    queueIdLabel: 'පෝලිම් අංකය',
    closingIn: 'වසා දමන්නේ තත්පර',
    secondsSuffix: '',
    veryGood: 'ඉතා හොඳයි',
    veryGoodSubtitle: 'විශිෂ්ටයි - ස්තූතියි!',
    good: 'හොඳයි',
    goodSubtitle: 'සතුටුදායක අත්දැකීමක්.',
    okay: 'සාමාන්‍යයි',
    okaySubtitle: 'සේවාව සාමාන්‍ය මට්ටමේ විය.',
    bad: 'අඩුයි',
    badSubtitle: 'අපේක්ෂාවට අඩුයි.',
    veryBad: 'ඉතා අඩුයි',
    veryBadSubtitle: 'අපි තවත් හොඳ කළ යුතුයි.',
  );

  static const ta = AppCopy(
    brandTitle: 'LECO',
    brandSubtitle: 'வாடிக்கையாளர் கருத்து',
    branchPrefix: 'கிளை',
    quickFeedback: 'விரைவு கருத்து',
    heading: 'இன்று எங்கள்\nசேவை எப்படி?',
    description:
        'உங்கள் நேர்மையான மதிப்பீடு எங்கள் சேவையை மேம்படுத்த உதவுகிறது.',
    submit: 'சமர்ப்பிக்க',
    poweredBy: 'வழங்கியது',
    productName: 'LECO Digital',
    version: 'v2.4',
    counterPrefix: 'கவுண்டர்',
    counterFallback: 'v2.4 · கவுண்டர் --',
    loading: 'ஏற்றுகிறது',
    thankYouTitle: 'நன்றி!',
    thankYouMessage: 'உங்கள் கருத்து வெற்றிகரமாக பதிவு செய்யப்பட்டது.',
    queueIdLabel: 'வரிசை ID',
    closingIn: 'மூடப்படும் நேரம்',
    secondsSuffix: 's',
    veryGood: 'மிகவும் நல்லது',
    veryGoodSubtitle: 'சிறப்பு - நன்றி!',
    good: 'நல்லது',
    goodSubtitle: 'இனிய அனுபவம்.',
    okay: 'சரி',
    okaySubtitle: 'சேவை சரியாக இருந்தது.',
    bad: 'மோசம்',
    badSubtitle: 'எதிர்பார்ப்புக்கு குறைவு.',
    veryBad: 'மிக மோசம்',
    veryBadSubtitle: 'நாங்கள் இன்னும் மேம்பட வேண்டும்.',
  );
}
