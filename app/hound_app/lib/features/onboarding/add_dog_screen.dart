import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';

class AddDogScreen extends ConsumerStatefulWidget {
  const AddDogScreen({super.key});

  @override
  ConsumerState<AddDogScreen> createState() => _AddDogScreenState();
}

class _AddDogScreenState extends ConsumerState<AddDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _activityController = TextEditingController();

  String? _selectedAge;
  String _selectedGender = 'Erkek';

  int _energy = 50;
  int _sociability = 50;
  int _adaptability = 50;

  bool _passportUploaded = false;
  bool _vaccineUploaded = false;

  final List<String> _ageOptions = [
    '0-6 ay',
    '6-12 ay',
    '1 yaş',
    '2 yaş',
    '3 yaş',
    '4 yaş',
    '5 yaş',
    '6 yaş',
    '7 yaş',
    '8+ yaş',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _activityController.dispose();
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
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Köpek Ekle',
          style: AppTextStyles.headlineSmall.copyWith(
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildPhotoUpload(),
              const SizedBox(height: 20),
              Text(
                'Canine Profilini Oluştur',
                style: AppTextStyles.displaySmall.copyWith(
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sadık dostunuz için sessiz lüks',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 36),

              // KÖPEK BİLGİLERİ
              _buildSectionHeader('KÖPEK BİLGİLERİ'),
              const SizedBox(height: 16),
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
              _buildAgeDropdown(),
              const SizedBox(height: 16),
              _buildGenderToggle(),
              const SizedBox(height: 36),

              // KİŞİLİK ÖZELLİKLERİ
              _buildSectionHeader('KİŞİLİK ÖZELLİKLERİ'),
              const SizedBox(height: 16),
              _buildTraitSlider(
                label: 'Enerji',
                value: _energy,
                onChanged: (v) => setState(() => _energy = v),
              ),
              const SizedBox(height: 20),
              _buildTraitSlider(
                label: 'Sosyallik',
                value: _sociability,
                onChanged: (v) => setState(() => _sociability = v),
              ),
              const SizedBox(height: 20),
              _buildTraitSlider(
                label: 'Uyum',
                value: _adaptability,
                onChanged: (v) => setState(() => _adaptability = v),
              ),
              const SizedBox(height: 36),

              // FAVORİ AKTİVİTE
              _buildSectionHeader('FAVORİ AKTİVİTE'),
              const SizedBox(height: 16),
              _buildTextArea(),
              const SizedBox(height: 36),

              // DOĞRULAMA
              _buildSectionHeader('DOĞRULAMA'),
              const SizedBox(height: 16),
              _buildDocumentUpload(
                label: 'Köpek Pasaportu',
                isUploaded: _passportUploaded,
                onTap: () => setState(() => _passportUploaded = true),
              ),
              const SizedBox(height: 12),
              _buildDocumentUpload(
                label: 'Aşı Kayıtları',
                isUploaded: _vaccineUploaded,
                onTap: () => setState(() => _vaccineUploaded = true),
              ),
              const SizedBox(height: 36),

              // Buttons
              PrimaryButton(
                text: 'İNCELEMEYE GÖNDER',
                icon: Icons.send_rounded,
                onPressed: _handleSubmit,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _handleSave,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.navy,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'KAYDET',
                    style: GoogleFonts.publicSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Disclaimer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Temel bilgilerin değiştirilmesi yeniden doğrulama gerektirebilir',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textLight,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: () {
        // TODO: Handle photo upload
      },
      child: Container(
        width: 148,
        height: 148,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.backgroundAlt,
          border: Border.all(
            color: AppColors.border,
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.pets_rounded,
              size: 48,
              color: AppColors.textLight.withOpacity(0.5),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(
              letterSpacing: 2,
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 32,
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.4),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTextStyles.bodyMedium,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLight,
        ),
        filled: true,
        fillColor: Colors.white,
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
    );
  }

  Widget _buildAgeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedAge,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        labelText: 'Yaş',
        labelStyle: AppTextStyles.bodyMedium,
        filled: true,
        fillColor: Colors.white,
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
      hint: Text(
        'Yaş seçiniz',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLight,
        ),
      ),
      items: _ageOptions
          .map((age) => DropdownMenuItem(
                value: age,
                child: Text(age),
              ))
          .toList(),
      onChanged: (value) => setState(() => _selectedAge = value),
    );
  }

  Widget _buildGenderToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cinsiyet',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _GenderButton(
                label: 'Erkek',
                icon: Icons.male_rounded,
                isSelected: _selectedGender == 'Erkek',
                onTap: () => setState(() => _selectedGender = 'Erkek'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GenderButton(
                label: 'Dişi',
                icon: Icons.female_rounded,
                isSelected: _selectedGender == 'Dişi',
                onTap: () => setState(() => _selectedGender = 'Dişi'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTraitSlider({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final numberController = TextEditingController(text: value.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.toUpperCase(),
              style: AppTextStyles.labelMedium.copyWith(
                letterSpacing: 1.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.backgroundAlt,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '%$value',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.border,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.1),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        SizedBox(
          width: 80,
          child: TextFormField(
            controller: numberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _RangeInputFormatter(0, 100),
            ],
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: '0-100',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
            onChanged: (text) {
              final parsed = int.tryParse(text);
              if (parsed != null && parsed >= 0 && parsed <= 100) {
                onChanged(parsed);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea() {
    return TextFormField(
      controller: _activityController,
      maxLines: 4,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Köpeğinizin en sevdiği aktiviteyi tanımlayın...',
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLight,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
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
    );
  }

  Widget _buildDocumentUpload({
    required String label,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded ? AppColors.success : AppColors.border,
            width: isUploaded ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isUploaded
                  ? Icons.check_circle_rounded
                  : Icons.cloud_upload_outlined,
              size: 36,
              color: isUploaded ? AppColors.success : AppColors.textLight,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isUploaded ? AppColors.success : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isUploaded
                  ? 'Belge yüklendi'
                  : 'Yüklemek için dokunun',
              style: AppTextStyles.bodySmall.copyWith(
                color: isUploaded ? AppColors.success : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() {
    // TODO: Save form data locally
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil kaydedildi'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Submit form data for review
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil incelemeye gönderildi'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color:
                    isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _RangeInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final value = int.tryParse(newValue.text);
    if (value == null) return oldValue;
    if (value < min || value > max) return oldValue;
    return newValue;
  }
}
