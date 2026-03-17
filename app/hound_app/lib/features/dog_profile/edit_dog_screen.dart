import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/trait_indicator.dart';

class EditDogScreen extends ConsumerStatefulWidget {
  final String dogId;

  const EditDogScreen({super.key, required this.dogId});

  @override
  ConsumerState<EditDogScreen> createState() => _EditDogScreenState();
}

class _EditDogScreenState extends ConsumerState<EditDogScreen> {
  final _formKey = GlobalKey<FormState>();

  // Pre-filled mock data
  late final TextEditingController _nameController;
  late final TextEditingController _breedController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _bioController;
  late final TextEditingController _favoriteActivityController;

  String _selectedGender = 'Erkek';
  String _selectedSize = 'Büyük';
  int _energyLevel = 40;
  int _socialLevel = 90;
  bool _isNeutered = true;
  bool _isVaccinated = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Jasper');
    _breedController = TextEditingController(text: 'Golden Retriever');
    _ageController = TextEditingController(text: '4');
    _weightController = TextEditingController(text: '65');
    _bioController = TextEditingController(
      text: 'Jasper, enerjik ve sevecen bir Golden Retriever\'dır. '
          'Parkta koşmayı, yeni arkadaşlar edinmeyi ve '
          'uzun yürüyüşleri çok sever.',
    );
    _favoriteActivityController = TextEditingController(
      text: 'Hyde Park\'ta sabah yürüyüşleri',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _bioController.dispose();
    _favoriteActivityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Köpek Bilgilerini Düzenle',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headlineSmall.copyWith(
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Scrollable form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // --- Photo Section ---
                      _buildSectionLabel('FOTOĞRAFLAR'),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            // Existing photos
                            ...List.generate(3, (index) {
                              return Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.champagne,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    const Center(
                                      child: Icon(
                                        Icons.pets,
                                        size: 36,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            // Add photo button
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundAlt,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.border,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    color: AppColors.textSecondary,
                                    size: 24,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Ekle',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // --- Basic Info ---
                      _buildSectionLabel('TEMEL BİLGİLER'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _nameController,
                        label: 'İsim',
                        hint: 'Köpeğinizin adı',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _breedController,
                        label: 'Irk',
                        hint: 'Köpeğinizin ırkı',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _ageController,
                              label: 'Yaş (Yıl)',
                              hint: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _weightController,
                              label: 'Kilo (kg)',
                              hint: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // --- Gender ---
                      _buildSectionLabel('CİNSİYET'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildSelectableChip(
                            'Erkek',
                            _selectedGender == 'Erkek',
                            () => setState(() => _selectedGender = 'Erkek'),
                          ),
                          const SizedBox(width: 12),
                          _buildSelectableChip(
                            'Dişi',
                            _selectedGender == 'Dişi',
                            () => setState(() => _selectedGender = 'Dişi'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // --- Size ---
                      _buildSectionLabel('BOYUT'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildSelectableChip(
                            'Küçük',
                            _selectedSize == 'Küçük',
                            () => setState(() => _selectedSize = 'Küçük'),
                          ),
                          const SizedBox(width: 8),
                          _buildSelectableChip(
                            'Orta',
                            _selectedSize == 'Orta',
                            () => setState(() => _selectedSize = 'Orta'),
                          ),
                          const SizedBox(width: 8),
                          _buildSelectableChip(
                            'Büyük',
                            _selectedSize == 'Büyük',
                            () => setState(() => _selectedSize = 'Büyük'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // --- Health ---
                      _buildSectionLabel('SAĞLIK BİLGİLERİ'),
                      const SizedBox(height: 12),
                      _buildSwitchRow(
                        'Kısırlaştırılmış',
                        _isNeutered,
                        (v) => setState(() => _isNeutered = v),
                      ),
                      const SizedBox(height: 8),
                      _buildSwitchRow(
                        'Aşıları Tam',
                        _isVaccinated,
                        (v) => setState(() => _isVaccinated = v),
                      ),

                      const SizedBox(height: 28),

                      // --- Bio ---
                      _buildSectionLabel('HAKKINDA'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _bioController,
                        label: 'Biyografi',
                        hint: 'Köpeğinizi tanıtın...',
                        maxLines: 4,
                      ),

                      const SizedBox(height: 28),

                      // --- Personality ---
                      _buildSectionLabel('KİŞİLİK'),
                      const SizedBox(height: 16),
                      TraitSliderInput(
                        label: 'Enerji Seviyesi',
                        value: _energyLevel,
                        onChanged: (v) => setState(() => _energyLevel = v),
                      ),
                      const SizedBox(height: 20),
                      TraitSliderInput(
                        label: 'Sosyallik Seviyesi',
                        value: _socialLevel,
                        onChanged: (v) => setState(() => _socialLevel = v),
                      ),

                      const SizedBox(height: 28),

                      // --- Favorite Activity ---
                      _buildSectionLabel('FAVORİ AKTİVİTE'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _favoriteActivityController,
                        label: 'Favori Aktivite',
                        hint: 'Örn: Parkta koşmak',
                      ),

                      const SizedBox(height: 32),

                      // --- Re-verification disclaimer ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.warning.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.warning,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Irk, yaş veya sağlık bilgilerinde yapılan değişiklikler '
                                'yeniden doğrulama sürecini başlatabilir.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- Save Button ---
                      PrimaryButton(
                        text: 'DEĞİŞİKLİKLERİ KAYDET',
                        icon: Icons.check,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.pop();
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      // --- Submit for Review Button ---
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Değişiklikler incelemeye gönderildi',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              context.pop();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.navy,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'İNCELEMEYE GÖNDER',
                            style: AppTextStyles.buttonMedium.copyWith(
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.labelMedium.copyWith(
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTextStyles.bodySmall,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLight,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Bu alan zorunludur';
        }
        return null;
      },
    );
  }

  Widget _buildSelectableChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyLarge),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
