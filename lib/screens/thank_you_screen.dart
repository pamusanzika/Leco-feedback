import 'package:flutter/material.dart';

import '../app_theme.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({
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
