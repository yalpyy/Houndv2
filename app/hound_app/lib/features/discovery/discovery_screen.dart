import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  final List<_MockDogProfile> _dogs = const [
    _MockDogProfile(
      name: 'Jasper',
      age: 4,
      location: 'Kensington Circle',
      traits: ['Sakin', 'Sosyal', 'Çevik'],
      bio:
          'Sabah koşularını ve park buluşmalarını seven zarif bir Golden Retriever. Tüm köpeklerle iyi geçinir.',
      isVerified: true,
    ),
    _MockDogProfile(
      name: 'Luna',
      age: 2,
      location: 'Nişantaşı Park',
      traits: ['Enerjik', 'Oyuncu', 'Sadık'],
      bio:
          'Frisbee oynamaya bayılan, meraklı bir Border Collie. Yeni arkadaşlıklara her zaman açık.',
      isVerified: true,
    ),
    _MockDogProfile(
      name: 'Atlas',
      age: 5,
      location: 'Bebek Sahil',
      traits: ['Sakin', 'Koruyucu', 'Uyumlu'],
      bio:
          'Deneyimli ve olgun bir Alman Çoban Köpeği. Uzun yürüyüşleri ve sakin ortamları tercih eder.',
      isVerified: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.navy),
          onPressed: () {
            // TODO: Open drawer
          },
        ),
        centerTitle: true,
        title: Text(
          'HOUND',
          style: AppTextStyles.headlineLarge.copyWith(
            letterSpacing: 4,
            color: AppColors.navy,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.navy,
                    size: 24,
                  ),
                  onPressed: () {
                    // TODO: Open notifications
                  },
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _dogs.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return _buildDogCard(_dogs[index]);
              },
            ),
          ),
          _buildActionButtons(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDogCard(_MockDogProfile dog) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dog photo area
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder photo with gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFE8DDD3),
                          Color(0xFFD4C5B5),
                          Color(0xFFC9B8A5),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.pets_rounded,
                        size: 80,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                  // Bottom gradient overlay for text readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 160,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Verified badge
                  if (dog.isVerified)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Doğrulanmış',
                              style: GoogleFonts.publicSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Dog info overlay
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${dog.name}, ${dog.age}',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dog.location,
                              style: GoogleFonts.publicSans(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom info section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trait chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: dog.traits
                        .map((trait) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                trait,
                                style: GoogleFonts.publicSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  // Bio
                  Text(
                    dog.bio,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Pass button
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _handlePass,
              icon: const Icon(
                Icons.close_rounded,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Meet request button
          Expanded(
            child: PrimaryButton(
              text: 'TANIŞMA İSTEĞİ GÖNDER',
              icon: Icons.favorite_outline_rounded,
              onPressed: _handleMeetRequest,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePass() {
    if (_currentIndex < _dogs.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleMeetRequest() {
    final dog = _dogs[_currentIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${dog.name} için tanışma isteği gönderildi'),
        duration: const Duration(seconds: 2),
      ),
    );
    _handlePass();
  }
}

class _MockDogProfile {
  final String name;
  final int age;
  final String location;
  final List<String> traits;
  final String bio;
  final bool isVerified;

  const _MockDogProfile({
    required this.name,
    required this.age,
    required this.location,
    required this.traits,
    required this.bio,
    required this.isVerified,
  });
}
