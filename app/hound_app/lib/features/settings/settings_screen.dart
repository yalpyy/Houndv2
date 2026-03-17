import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
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
          'Ayarlar',
          style: AppTextStyles.headlineMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 8),

          // HESAP section
          _buildSectionLabel('HESAP'),
          _buildSettingsTile(
            title: 'Profil Bilgileri',
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'E-posta Değiştir',
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Şifre Değiştir',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // BİLDİRİMLER section
          _buildSectionLabel('BİLDİRİMLER'),
          _buildSwitchTile(
            title: 'Anlık Bildirimler',
            value: _pushNotificationsEnabled,
            onChanged: (val) {
              setState(() => _pushNotificationsEnabled = val);
            },
          ),
          _buildDivider(),
          _buildSwitchTile(
            title: 'E-posta Bildirimleri',
            value: _emailNotificationsEnabled,
            onChanged: (val) {
              setState(() => _emailNotificationsEnabled = val);
            },
          ),

          const SizedBox(height: 24),

          // ÜYELİK section
          _buildSectionLabel('ÜYELİK'),
          _buildSettingsTile(
            title: 'Üyelik Planı',
            onTap: () => context.push('/premium'),
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Fatura Geçmişi',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // DESTEK section
          _buildSectionLabel('DESTEK'),
          _buildSettingsTile(
            title: 'Yardım Merkezi',
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Geri Bildirim',
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Gizlilik Politikası',
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Kullanım Koşulları',
            onTap: () {},
          ),

          const SizedBox(height: 32),

          // Logout button
          Center(
            child: TextButton(
              onPressed: () => context.go('/welcome'),
              child: Text(
                'Çıkış Yap',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(height: 1),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textLight,
          size: 22,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(height: 1),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.divider,
      indent: 16,
      endIndent: 16,
    );
  }
}
