import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/hound_app_bar.dart';

class ApplicationScreen extends ConsumerStatefulWidget {
  const ApplicationScreen({super.key});

  @override
  ConsumerState<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends ConsumerState<ApplicationScreen> {
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Step 1: Kişisel Bilgiler
  final _fullNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _referralCodeController = TextEditingController();

  // Step 2: Köpek Bilgileri
  final _dogNameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();

  // Step 3: Yaşam Tarzı
  final _lifestyleController = TextEditingController();
  final _activityLevelController = TextEditingController();
  final _livingEnvironmentController = TextEditingController();

  // Step 4: Referans
  final _howDidYouHearController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _cityController.dispose();
    _referralCodeController.dispose();
    _dogNameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _lifestyleController.dispose();
    _activityLevelController.dispose();
    _livingEnvironmentController.dispose();
    _howDidYouHearController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _submitApplication();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _submitApplication() {
    // TODO: Implement submission logic
    context.go('/waitlist');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HoundAppBar(
        showBackButton: true,
        title: 'Üyelik Başvurusu',
        onBack: () {
          if (_currentStep > 0) {
            _previousStep();
          } else {
            context.pop();
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Adım ${_currentStep + 1} / $_totalSteps',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        _stepTitle(_currentStep),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.gold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / _totalSteps,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.gold,
                      ),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: _buildStepContent(),
                ),
              ),
            ),

            // Bottom area with buttons and security note
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Navigation buttons
                  Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton(
                              onPressed: _previousStep,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.navy,
                                side: const BorderSide(
                                  color: AppColors.border,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'GERİ',
                                style: AppTextStyles.buttonLarge.copyWith(
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _nextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _currentStep == _totalSteps - 1
                                  ? 'BAŞVURUYU GÖNDER'
                                  : 'DEVAM ET',
                              style: AppTextStyles.buttonLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Security note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Bilgileriniz güvende',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textLight,
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
    );
  }

  String _stepTitle(int step) {
    switch (step) {
      case 0:
        return 'KİŞİSEL BİLGİLER';
      case 1:
        return 'KÖPEK BİLGİLERİ';
      case 2:
        return 'YAŞAM TARZI';
      case 3:
        return 'REFERANS';
      case 4:
        return 'ONAY';
      default:
        return '';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildDogInfoStep();
      case 2:
        return _buildLifestyleStep();
      case 3:
        return _buildReferralStep();
      case 4:
        return _buildConfirmationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1: Kişisel Bilgiler
  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Sizi tanıyalım',
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Lütfen kişisel bilgilerinizi doldurun.',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 32),
        _buildLabel('AD SOYAD'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _fullNameController,
          decoration: _inputDecoration(hintText: 'Adınız ve soyadınız'),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 24),
        _buildLabel('ŞEHİR / ÇEVRENİZ'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cityController,
          decoration: _inputDecoration(hintText: 'Yaşadığınız şehir'),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 24),
        _buildLabel('REFERANS KODU (İSTEĞE BAĞLI)'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _referralCodeController,
          decoration: _inputDecoration(hintText: 'Varsa referans kodunuz'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Step 2: Köpek Bilgileri
  Widget _buildDogInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Köpeğinizi tanıyalım',
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Köpeğiniz hakkında bilgi verin.',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 32),
        _buildLabel('KÖPEK ADI'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _dogNameController,
          decoration: _inputDecoration(hintText: 'Köpeğinizin adı'),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 24),
        _buildLabel('IRK'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _breedController,
          decoration: _inputDecoration(hintText: 'Köpeğinizin ırkı'),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 24),
        _buildLabel('YAŞ'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _ageController,
          decoration: _inputDecoration(hintText: 'Köpeğinizin yaşı'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Step 3: Yaşam Tarzı
  Widget _buildLifestyleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Yaşam tarzınız',
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Köpeğinizle günlük yaşamınız hakkında bilgi verin.',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 32),
        _buildLabel('GÜNLÜK RUTİNİNİZ'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _lifestyleController,
          decoration: _inputDecoration(
            hintText: 'Köpeğinizle günlük rutininizi anlatın',
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 24),
        _buildLabel('AKTİVİTE SEVİYESİ'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _activityLevelController,
          decoration: _inputDecoration(
            hintText: 'Aktivite seviyenizi tanımlayın',
          ),
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 24),
        _buildLabel('YAŞAM ALANI'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _livingEnvironmentController,
          decoration: _inputDecoration(
            hintText: 'Yaşam alanınızı tanımlayın (ev, bahçe, vb.)',
          ),
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Step 4: Referans
  Widget _buildReferralStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Bizi nasıl buldunuz?',
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Hound\'u nasıl keşfettiniz?',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 32),
        _buildLabel('HOUND\'U NASIL DUYDUNUZ?'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _howDidYouHearController,
          decoration: _inputDecoration(
            hintText: 'Arkadaş, sosyal medya, etkinlik vb.',
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Step 5: Onay
  Widget _buildConfirmationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Başvurunuzu onaylayın',
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bilgilerinizi kontrol edin ve başvurunuzu gönderin.',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 32),

        // Summary cards
        _buildSummaryCard('KİŞİSEL BİLGİLER', [
          _buildSummaryRow('Ad Soyad', _fullNameController.text),
          _buildSummaryRow('Şehir', _cityController.text),
          if (_referralCodeController.text.isNotEmpty)
            _buildSummaryRow('Referans Kodu', _referralCodeController.text),
        ]),
        const SizedBox(height: 16),

        _buildSummaryCard('KÖPEK BİLGİLERİ', [
          _buildSummaryRow('Köpek Adı', _dogNameController.text),
          _buildSummaryRow('Irk', _breedController.text),
          _buildSummaryRow('Yaş', _ageController.text),
        ]),
        const SizedBox(height: 16),

        _buildSummaryCard('YAŞAM TARZI', [
          _buildSummaryRow('Günlük Rutin', _lifestyleController.text),
          _buildSummaryRow('Aktivite', _activityLevelController.text),
          _buildSummaryRow('Yaşam Alanı', _livingEnvironmentController.text),
        ]),
        const SizedBox(height: 16),

        _buildSummaryCard('REFERANS', [
          _buildSummaryRow('Nasıl Duydunuz', _howDidYouHearController.text),
        ]),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSummaryCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.gold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.labelMedium.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 1.5,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textLight,
      ),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}
