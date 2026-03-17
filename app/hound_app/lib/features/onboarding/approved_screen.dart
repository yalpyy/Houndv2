import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/status_badge.dart';

class ApprovedScreen extends ConsumerWidget {
  const ApprovedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background with elegant gradient simulating dark dog image overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A2A40),
                  Color(0xFF0F1A2A),
                  Color(0xFF0A1220),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Subtle texture overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.white.withOpacity(0.03),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  // Approved badge
                  const StatusBadge(
                    text: 'BAŞVURU DURUMU: ONAYLANDI',
                    type: StatusBadgeType.approved,
                    showDot: true,
                  ),
                  const SizedBox(height: 32),
                  // Heading
                  Text(
                    'Topluluğa\nHoş Geldiniz',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.textOnDark,
                      fontSize: 40,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Decorative gold line
                  Container(
                    width: 48,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Body text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Başvurunuz onaylandı. Keşfetmeye ve tanışma istekleri göndermeye başlamak için lütfen ilk köpek profilinizi oluşturun.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textOnDark.withOpacity(0.75),
                        height: 1.7,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Add dog button
                  PrimaryButton(
                    text: 'KÖPEK EKLE',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => context.push('/add-dog'),
                  ),
                  const SizedBox(height: 16),
                  // Footer
                  Text(
                    'EST. 2024 — PRIVATE SELECTION',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white.withOpacity(0.3),
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
