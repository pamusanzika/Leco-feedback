import 'dart:ui';

import 'package:flutter/material.dart';

import '../app_theme.dart';

class FeedbackOption {
  const FeedbackOption(this.rating, this.emoji, this.title, this.subtitle);

  final int rating;
  final String emoji;
  final String title;
  final String subtitle;
}

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({
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
              color: Colors.black,
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
