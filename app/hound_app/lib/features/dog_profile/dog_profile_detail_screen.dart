import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/trait_indicator.dart';

class DogProfileDetailScreen extends ConsumerStatefulWidget {
  final String dogId;

  const DogProfileDetailScreen({super.key, required this.dogId});

  @override
  ConsumerState<DogProfileDetailScreen> createState() =>
      _DogProfileDetailScreenState();
}

class _DogProfileDetailScreenState
    extends ConsumerState<DogProfileDetailScreen> {
  int _currentImageIndex = 0;
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Hero Image Gallery ---
                _buildHeroImageGallery(context),

                // --- Name & Location ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Jasper',
                            style: AppTextStyles.displaySmall,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.verified,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Danua \u2022 Chelsea Circle',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      const StatusBadge(
                        text: 'ONAYLI \u00dcYE',
                        type: StatusBadgeType.approved,
                        showDot: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- Stats Grid ---
                _buildStatsRow(),

                const SizedBox(height: 24),
                const Divider(color: AppColors.divider, indent: 24, endIndent: 24),
                const SizedBox(height: 24),

                // --- Hakk\u0131nda ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hakk\u0131nda',
                        style: AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Jasper, enerjik ve sevecen bir Golden Retriever\'d\u0131r. '
                        'Parkta ko\u015fmay\u0131, yeni arkada\u015flar edinmeyi ve '
                        'uzun y\u00fcr\u00fcy\u00fc\u015fleri \u00e7ok sever. Ailesiyle '
                        'birlikte Chelsea b\u00f6lgesinde ya\u015famaktad\u0131r.',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(color: AppColors.divider, indent: 24, endIndent: 24),
                const SizedBox(height: 24),

                // --- Ki\u015filik ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ki\u015filik',
                        style: AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          TraitIndicator(
                            label: 'Enerji Seviyesi',
                            value: 40,
                          ),
                          TraitIndicator(
                            label: 'Sosyallik Seviyesi',
                            value: 90,
                            color: AppColors.gold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(color: AppColors.divider, indent: 24, endIndent: 24),
                const SizedBox(height: 24),

                // --- Favori Aktivite ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Favori Aktivite',
                          style: AppTextStyles.labelMedium.copyWith(
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_walk,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Hyde Park\'ta sabah y\u00fcr\u00fcy\u00fc\u015fleri',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(color: AppColors.divider, indent: 24, endIndent: 24),
                const SizedBox(height: 24),

                // --- Owner Section ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Owner avatar
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.champagne,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.textSecondary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alex Rivera',
                                style: AppTextStyles.headlineSmall,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'K\u00f6pek Sahibi',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SecondaryButton(
                        text: 'Mesaj G\u00f6nder',
                        icon: Icons.chat_bubble_outline,
                        onPressed: () {
                          context.push('/chat/mock-thread-1');
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(color: AppColors.divider, indent: 24, endIndent: 24),
                const SizedBox(height: 24),

                // --- Neighborhood / Map ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mahalle',
                        style: AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.champagne,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.map_outlined,
                            size: 48,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Haritay\u0131 G\u00f6r\u00fcnt\u00fcle',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // --- Fixed Header ---
          _buildFixedHeader(context),

          // --- Sticky Bottom CTA ---
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: PrimaryButton(
                text: 'TANI\u015eMA \u0130STE\u011e\u0130 G\u00d6NDER',
                icon: Icons.pets,
                onPressed: () {
                  // TODO: Send meet request
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedHeader(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.95),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                onPressed: () => context.pop(),
              ),
              const Spacer(),
              Text(
                'HOUND Profili',
                style: AppTextStyles.headlineSmall.copyWith(
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: AppColors.navy),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorited ? AppColors.primary : AppColors.navy,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorited = !_isFavorited;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImageGallery(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 56;
    return Column(
      children: [
        SizedBox(height: topPadding),
        Container(
          height: 300,
          width: double.infinity,
          color: AppColors.champagne,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: 4,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    color: AppColors.champagne.withOpacity(0.7 + index * 0.1),
                    child: Center(
                      child: Icon(
                        Icons.pets,
                        size: 80,
                        color: AppColors.textLight.withOpacity(0.4),
                      ),
                    ),
                  );
                },
              ),
              // Page indicator dots
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      width: _currentImageIndex == index ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: _currentImageIndex == index
                            ? AppColors.primary
                            : Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildStatItem('Ya\u015f', '4 Y\u0131l'),
          _buildStatDivider(),
          _buildStatItem('Kilo', '65 kg'),
          _buildStatDivider(),
          _buildStatItem('Cinsiyet', 'Erkek'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.border,
    );
  }
}
