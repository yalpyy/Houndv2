import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';

class WalkPlanningScreen extends ConsumerStatefulWidget {
  final String threadId;

  const WalkPlanningScreen({super.key, required this.threadId});

  @override
  ConsumerState<WalkPlanningScreen> createState() =>
      _WalkPlanningScreenState();
}

class _WalkPlanningScreenState extends ConsumerState<WalkPlanningScreen> {
  // Calendar state
  DateTime _currentMonth = DateTime(2026, 3);
  int? _selectedDay = 21;

  // Time of day
  int _selectedTimeIndex = 0;

  // Location
  int _selectedLocationIndex = 0;

  // Note
  final TextEditingController _noteController = TextEditingController();

  final List<String> _dayLabels = ['Pz', 'Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct'];

  final List<_TimeOption> _timeOptions = const [
    _TimeOption(label: 'Sabah', icon: Icons.wb_sunny_outlined),
    _TimeOption(label: 'Öğle', icon: Icons.light_mode_outlined),
    _TimeOption(label: 'Akşam', icon: Icons.wb_twilight_outlined),
    _TimeOption(label: 'Gün Batımı', icon: Icons.nightlight_outlined),
  ];

  final List<_LocationOption> _locationOptions = const [
    _LocationOption(
      name: 'Holland Park Circle',
      color: Color(0xFF4A7C59),
    ),
    _LocationOption(
      name: 'Kensington Gardens',
      color: Color(0xFF2E5A88),
    ),
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
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
                      'Yürüyüş Planla',
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

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // --- Date Section ---
                    _buildSectionLabel('TARİH SEÇİN'),
                    const SizedBox(height: 12),
                    _buildCalendar(),

                    const SizedBox(height: 28),

                    // --- Time of Day ---
                    _buildSectionLabel('GÜNÜN SAATİ'),
                    const SizedBox(height: 12),
                    _buildTimeSelector(),

                    const SizedBox(height: 28),

                    // --- Location ---
                    _buildSectionLabel('ÇEMBER SEÇİN'),
                    const SizedBox(height: 12),
                    _buildLocationSelector(),

                    const SizedBox(height: 28),

                    // --- Note ---
                    _buildSectionLabel('SAHİBE NOT'),
                    const SizedBox(height: 12),
                    _buildNoteField(),

                    const SizedBox(height: 32),

                    // --- Submit Button ---
                    PrimaryButton(
                      text: 'TEKLİFİ GÖNDER',
                      icon: Icons.send,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Yürüyüş teklifi gönderildi!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        context.pop();
                      },
                    ),

                    const SizedBox(height: 16),

                    // Disclaimer
                    Text(
                      'Köpek sahibi teklifinizi inceleyecek ve 24 saat '
                      'içinde yanıt verecektir. Onaylandığında bildirim '
                      'alacaksınız.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),
                  ],
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

  Widget _buildCalendar() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    // Monday = 1, Sunday = 7 in DateTime; our grid starts on Sunday (Pz)
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    // Convert: DateTime weekday 1=Mon..7=Sun → grid index 0=Sun..6=Sat
    final startOffset = firstDayOfMonth.weekday % 7;

    final monthNames = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Month header with arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month - 1,
                    );
                    _selectedDay = null;
                  });
                },
                icon: const Icon(
                  Icons.chevron_left,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
                style: AppTextStyles.headlineSmall,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month + 1,
                    );
                    _selectedDay = null;
                  });
                },
                icon: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Day labels
          Row(
            children: _dayLabels.map((label) {
              return Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: AppTextStyles.labelSmall.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 8),

          // Day grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: startOffset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startOffset) {
                return const SizedBox.shrink();
              }
              final day = index - startOffset + 1;
              final isSelected = _selectedDay == day;

              return GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Row(
      children: List.generate(_timeOptions.length, (index) {
        final option = _timeOptions[index];
        final isSelected = _selectedTimeIndex == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTimeIndex = index),
            child: Container(
              margin: EdgeInsets.only(
                right: index < _timeOptions.length - 1 ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.12)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    option.icon,
                    size: 22,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    option.label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLocationSelector() {
    return Column(
      children: List.generate(_locationOptions.length, (index) {
        final option = _locationOptions[index];
        final isSelected = _selectedLocationIndex == index;

        return GestureDetector(
          onTap: () => setState(() => _selectedLocationIndex = index),
          child: Container(
            margin: EdgeInsets.only(
              bottom: index < _locationOptions.length - 1 ? 12 : 0,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Color placeholder for location image
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: option.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.park_outlined,
                    color: option.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteController,
      maxLines: 3,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Köpek sahibine iletmek istediğiniz bir not ekleyin (isteğe bağlı)',
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLight,
        ),
        filled: true,
        fillColor: AppColors.surface,
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
}

class _TimeOption {
  final String label;
  final IconData icon;

  const _TimeOption({required this.label, required this.icon});
}

class _LocationOption {
  final String name;
  final Color color;

  const _LocationOption({required this.name, required this.color});
}
