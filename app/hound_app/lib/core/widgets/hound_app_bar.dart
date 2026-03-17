import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class HoundAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const HoundAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.showBackButton = false,
    this.actions,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.navy),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: showLogo
          ? Text(
              'HOUND',
              style: AppTextStyles.headlineLarge.copyWith(
                letterSpacing: 4,
                color: AppColors.navy,
              ),
            )
          : title != null
              ? Text(
                  title!,
                  style: AppTextStyles.headlineSmall.copyWith(
                    letterSpacing: 1.5,
                  ),
                )
              : null,
      actions: actions,
    );
  }
}
