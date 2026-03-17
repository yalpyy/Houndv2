import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Üyelik',
          style: AppTextStyles.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section with gold gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFD4AF37),
                    AppColors.gold,
                    Color(0xFFAA8A45),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'HOUND Premium',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ayrıcalıklı deneyimin kapılarını aralayın',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // STANDART tier
                  _buildTierCard(
                    context: context,
                    tierName: 'STANDART',
                    subtitle: 'Mevcut plan',
                    isCurrent: true,
                    isHighlighted: false,
                    features: [
                      'Temel keşfet özellikleri',
                      'Günlük 5 tanışma isteği',
                      'Standart profil görünürlüğü',
                    ],
                    price: null,
                  ),

                  const SizedBox(height: 16),

                  // PREMİUM tier
                  _buildTierCard(
                    context: context,
                    tierName: 'PREMİUM',
                    subtitle: 'Önerilen',
                    isCurrent: false,
                    isHighlighted: true,
                    features: [
                      'Sınırsız keşfet',
                      'Sınırsız tanışma isteği',
                      'Öncelikli profil görünürlüğü',
                      'Özel çemberler erişimi',
                    ],
                    price: '₺299/ay',
                  ),

                  const SizedBox(height: 16),

                  // ELİT tier
                  _buildTierCard(
                    context: context,
                    tierName: 'ELİT',
                    subtitle: 'En üst',
                    isCurrent: false,
                    isHighlighted: false,
                    features: [
                      'Sınırsız keşfet',
                      'Sınırsız tanışma isteği',
                      'Öncelikli profil görünürlüğü',
                      'Özel çemberler erişimi',
                      'Kişisel küratör eşleştirme',
                      'VIP etkinlik davetleri',
                      'Elit rozet',
                    ],
                    price: '₺599/ay',
                  ),

                  const SizedBox(height: 32),

                  // Upgrade button
                  PrimaryButton(
                    text: "PREMİUM'A YÜKSELT",
                    onPressed: () {},
                    backgroundColor: AppColors.gold,
                    icon: Icons.arrow_forward,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required BuildContext context,
    required String tierName,
    required String subtitle,
    required bool isCurrent,
    required bool isHighlighted,
    required List<String> features,
    required String? price,
  }) {
    final bgColor = isHighlighted ? AppColors.navy : AppColors.surface;
    final textColor =
        isHighlighted ? AppColors.textOnDark : AppColors.textPrimary;
    final subtextColor =
        isHighlighted ? AppColors.textOnDark.withOpacity(0.7) : AppColors.textSecondary;
    final checkColor = isHighlighted ? AppColors.gold : AppColors.success;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted
              ? AppColors.gold
              : isCurrent
                  ? AppColors.primary.withOpacity(0.3)
                  : AppColors.border,
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tier header
          Row(
            children: [
              Text(
                tierName,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isHighlighted ? AppColors.gold : textColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Mevcut',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (isHighlighted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Önerilen',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(color: subtextColor),
          ),
          const SizedBox(height: 16),

          // Features
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: checkColor,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textColor.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Price
          if (price != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                price,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: isHighlighted ? AppColors.gold : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
