import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';

class DiscoveryLockedScreen extends ConsumerWidget {
  const DiscoveryLockedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred background simulating locked discovery feed
          _buildBlurredBackground(),
          // Glass-morphism overlay card
          _buildLockedOverlay(context),
          // Grayed out bottom nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildGrayedBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredBackground() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Column(
        children: [
          // Simulated app bar
          SafeArea(
            bottom: false,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.menu_rounded,
                      color: AppColors.navy.withOpacity(0.3)),
                  const Spacer(),
                  Text(
                    'HOUND',
                    style: AppTextStyles.headlineLarge.copyWith(
                      letterSpacing: 4,
                      color: AppColors.navy.withOpacity(0.3),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.notifications_outlined,
                      color: AppColors.navy.withOpacity(0.3)),
                ],
              ),
            ),
          ),
          // Simulated card placeholder
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.backgroundAlt,
                ),
                child: Center(
                  child: Icon(
                    Icons.pets_rounded,
                    size: 80,
                    color: AppColors.textLight.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildLockedOverlay(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lock icon in circular badge
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.navy.withOpacity(0.08),
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 32,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      'KEŞFET',
                      style: AppTextStyles.headlineLarge.copyWith(
                        letterSpacing: 3,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      'Topluluk özelliklerini keşfetmek için bir köpek profili eklemelisiniz.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Add dog button
                    PrimaryButton(
                      text: 'KÖPEK EKLE',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => context.push('/add-dog'),
                    ),
                    const SizedBox(height: 16),
                    // Secondary link
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to membership info
                      },
                      child: Text(
                        'ÜYELİK HAKKINDA DAHA FAZLA BİLGİ',
                        style: GoogleFonts.publicSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gold,
                          letterSpacing: 1.0,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.gold,
                        ),
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

  Widget _buildGrayedBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border(
          top: BorderSide(
            color: AppColors.border.withOpacity(0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.explore_outlined, 'Keşfet', isActive: true),
              _buildNavItem(Icons.favorite_outline_rounded, 'İstekler'),
              _buildNavItem(Icons.chat_bubble_outline_rounded, 'Sohbet'),
              _buildNavItem(Icons.person_outline_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label, {
    bool isActive = false,
  }) {
    final color = isActive
        ? AppColors.primary.withOpacity(0.4)
        : AppColors.textLight.withOpacity(0.4);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.publicSans(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}
