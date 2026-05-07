import 'package:flutter/material.dart';

import '../app_theme.dart';

const double _kMobile = 480;
const double _kTablet = 768;

class AppFooter extends StatelessWidget {
  const AppFooter({
    super.key,
    required this.poweredByLabel,
    required this.productName,
    required this.counterLabel,
  });

  final String poweredByLabel;
  final String productName;
  final String counterLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isMobile = w < _kMobile;
        final isTablet = w >= _kMobile && w < _kTablet;

        return isMobile
            ? _FooterMobile()
            : _FooterWide(isTablet: isTablet);
      },
    );
  }
}

// ── Mobile footer: stacked vertically ────────────────────────────────────────

class _FooterMobile extends StatelessWidget {
  const _FooterMobile();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: LECO info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Leco.png',
                height: 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lanka Electricity Company (LECO)',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Customer Feedback Kiosk System',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '© 2026 All Rights Reserved',
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Bottom row: Tranzent
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Powered by  ',
                style: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 9,
                ),
              ),
              const Text(
                'SLT Tranzent',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/images/tranzent.png',
                height: 22,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Tablet / Desktop footer: horizontal ───────────────────────────────────────

class _FooterWide extends StatelessWidget {
  const _FooterWide({required this.isTablet});

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final double logoH = isTablet ? 28 : 36;
    final double padH = isTablet ? 24 : 40;
    final double padV = isTablet ? 10 : 12;
    final double fs1 = isTablet ? 10 : 12;
    final double fs2 = isTablet ? 9 : 11;
    final double fs3 = isTablet ? 8 : 10;
    final double fsPowered = isTablet ? 9 : 10;
    final double fsBrand = isTablet ? 10 : 12;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Left: LECO logo + text ─────────────────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Leco.png',
                height: logoH,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 30,
                color: Colors.black.withValues(alpha: 0.10),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lanka Electricity Company (LECO)',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: fs1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Customer Feedback Kiosk System',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: fs2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '© 2026 All Rights Reserved',
                    style: TextStyle(
                      color: const Color(0xFFAAAAAA),
                      fontSize: fs3,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ── Right: Tranzent logo + "Powered by" ───────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Powered by',
                    style: TextStyle(
                      color: const Color(0xFFAAAAAA),
                      fontSize: fsPowered,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'SLT Tranzent',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: fsBrand,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 30,
                color: Colors.black.withValues(alpha: 0.10),
              ),
              const SizedBox(width: 12),
              Image.asset(
                'assets/images/tranzent.png',
                height: logoH,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
