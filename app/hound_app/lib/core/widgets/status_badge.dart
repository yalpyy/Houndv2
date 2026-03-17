import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusBadgeType type;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = StatusBadgeType.pending,
    this.showDot = false,
  });

  Color get _backgroundColor {
    switch (type) {
      case StatusBadgeType.pending:
        return AppColors.warning.withOpacity(0.12);
      case StatusBadgeType.approved:
        return AppColors.success.withOpacity(0.12);
      case StatusBadgeType.rejected:
        return AppColors.textLight.withOpacity(0.12);
      case StatusBadgeType.info:
        return AppColors.primary.withOpacity(0.12);
    }
  }

  Color get _textColor {
    switch (type) {
      case StatusBadgeType.pending:
        return AppColors.warning;
      case StatusBadgeType.approved:
        return AppColors.success;
      case StatusBadgeType.rejected:
        return AppColors.textLight;
      case StatusBadgeType.info:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _textColor,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

enum StatusBadgeType {
  pending,
  approved,
  rejected,
  info,
}
