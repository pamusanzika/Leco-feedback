import 'package:flutter/material.dart';

import '../app_theme.dart';

// Breakpoints
const double _kMobile = 480;
const double _kTablet = 768;

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.branchLabel,
  });

  final String title;
  final String subtitle;
  final String branchLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isMobile = w < _kMobile;
        final isTablet = w >= _kMobile && w < _kTablet;

        final double headerHeight = isMobile
            ? 72
            : isTablet
            ? 90
            : 110;
        final double logoPadH = isMobile
            ? 24
            : isTablet
            ? 32
            : 40;

        return SizedBox(
          width: double.infinity,
          height: headerHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Background banner image ────────────────────────────────
              Image.asset(
                'assets/images/leco_logo.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),

              // ── Content row ───────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: logoPadH),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left — logo + text
                    _LecoLogo(isMobile: isMobile, isTablet: isTablet),

                    // Right — branch label
                    _BranchLabel(
                      label: branchLabel,
                      isMobile: isMobile,
                      isTablet: isTablet,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── LECO logo + text ──────────────────────────────────────────────────────────

class _LecoLogo extends StatelessWidget {
  const _LecoLogo({required this.isMobile, required this.isTablet});

  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final double logoH = isMobile
        ? 34
        : isTablet
        ? 44
        : 54;
    final double fontSize1 = isMobile
        ? 11
        : isTablet
        ? 13
        : 15;
    final double fontSize2 = isMobile
        ? 8.5
        : isTablet
        ? 10
        : 11;
    final double divH = isMobile
        ? 24
        : isTablet
        ? 30
        : 36;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/Leco.png',
          height: logoH,
          fit: BoxFit.contain,
        ),
        // Hide divider + text label on very small screens
        if (!isMobile) ...[
          const SizedBox(width: 14),
          Container(
            width: 1.5,
            height: divH,
            color: Colors.white.withValues(alpha: 0.55),
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Feedback',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  height: 1.2,
                  shadows: const [
                    Shadow(
                      color: Color(0x99000000),
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'KIOSK SYSTEM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize2,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  shadows: const [
                    Shadow(
                      color: Color(0x88000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ── Branch label ──────────────────────────────────────────────────────────────

class _BranchLabel extends StatelessWidget {
  const _BranchLabel({
    required this.label,
    required this.isMobile,
    required this.isTablet,
  });

  final String label;
  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final double fontSize = isMobile
        ? 11
        : isTablet
        ? 13
        : 15;
    final double dotSize = isMobile ? 6 : 8;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: dotSize,
          height: dotSize,
          decoration: const BoxDecoration(
            color: AppColors.lecoYellow,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            shadows: const [
              Shadow(
                color: Color(0x99000000),
                blurRadius: 6,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
