import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Monochrome status badge — uses primary color tones only.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.backgroundColor,
    this.icon,
  });

  final String label;
  final Color color;
  final Color? backgroundColor;
  final IconData? icon;

  factory StatusBadge.approved() => const StatusBadge(
    label: 'Approved',
    color: AppColors.primary,
    icon: Icons.check_circle_outline,
  );

  factory StatusBadge.pending() => const StatusBadge(
    label: 'Pending',
    color: AppColors.textSecondary,
    icon: Icons.access_time,
  );

  factory StatusBadge.blocked() => const StatusBadge(
    label: 'Blocked',
    color: AppColors.destructive,
    icon: Icons.block,
  );

  factory StatusBadge.active() => const StatusBadge(
    label: 'Active',
    color: AppColors.primaryLight,
    icon: Icons.play_circle_outline,
  );

  factory StatusBadge.rejected() => const StatusBadge(
    label: 'Rejected',
    color: AppColors.destructive,
    icon: Icons.cancel_outlined,
  );

  factory StatusBadge.completed() => const StatusBadge(
    label: 'Completed',
    color: AppColors.primary,
    icon: Icons.task_alt,
  );

  factory StatusBadge.cancelled() => const StatusBadge(
    label: 'Cancelled',
    color: AppColors.textMuted,
    icon: Icons.cancel_outlined,
  );

  factory StatusBadge.fromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return StatusBadge.approved();
      case 'pending':
        return StatusBadge.pending();
      case 'blocked':
        return StatusBadge.blocked();
      case 'active':
        return StatusBadge.active();
      case 'rejected':
        return StatusBadge.rejected();
      case 'completed':
        return StatusBadge.completed();
      case 'cancelled':
        return StatusBadge.cancelled();
      default:
        return StatusBadge(label: status, color: AppColors.textMuted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
