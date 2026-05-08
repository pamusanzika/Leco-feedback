import 'dart:async';

import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'components/app_footer.dart';
import 'components/app_header.dart';
import 'screens/feedback_screen.dart';
import 'screens/thank_you_screen.dart';

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
                      : 'Branch \u2013 ${activeSession.branchName}',
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      child: isLoading
                          ? const _LoadingPanel()
                          : isThankYouVisible && activeSession != null
                          ? ThankYouScreen(
                              key: const ValueKey('thankYou'),
                              copy: copy,
                              queueId: activeSession.queueId,
                              remainingSeconds: remainingSeconds,
                            )
                          : FeedbackScreen(
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

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.lecoYellow),
    );
  }
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
