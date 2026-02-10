import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/organizer.dart';
import '../providers/organizer_provider.dart';

/// Organizer management screen — responsive card layout.
class OrganizerManagementScreen extends StatefulWidget {
  const OrganizerManagementScreen({super.key});

  @override
  State<OrganizerManagementScreen> createState() =>
      _OrganizerManagementScreenState();
}

class _OrganizerManagementScreenState extends State<OrganizerManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrganizerProvider>().fetchOrganizers());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrganizerProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.organizers.isEmpty) {
          return const LoadingWidget(message: 'Loading organizers...');
        }
        if (provider.error != null && provider.organizers.isEmpty) {
          return AppErrorWidget(
            message: provider.error!,
            onRetry: () => provider.fetchOrganizers(),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ──
              const Text(
                'Organizer Management',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage event organizers — approve, reject, or block',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),

              // ── Search ──
              SearchField(
                hint: 'Search organizers...',
                onChanged: (q) => provider.setSearchQuery(q),
              ),
              const SizedBox(height: 20),

              // ── Organizer List ──
              Expanded(
                child: provider.organizers.isEmpty
                    ? const EmptyStateWidget(
                        message: 'No organizers found',
                        icon: Icons.business_outlined,
                      )
                    : ListView.separated(
                        itemCount: provider.organizers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _buildOrganizerCard(
                          provider,
                          provider.organizers[index],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrganizerCard(OrganizerProvider provider, Organizer org) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top: Avatar + Name + Status ──
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  org.name[0],
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      org.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      org.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge.fromStatus(org.status),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 16),

          // ── Stats ──
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _statChip(Icons.phone_outlined, org.phone),
              _statChip(Icons.event_rounded, '${org.eventsCount} events'),
              _statChip(
                Icons.account_balance_wallet_outlined,
                currencyFormatter.format(org.totalRevenue),
              ),
              _statChip(
                Icons.calendar_today_outlined,
                'Joined ${org.joinedDate}',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Actions ──
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildActions(provider, org),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.textMuted),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  List<Widget> _buildActions(OrganizerProvider provider, Organizer org) {
    final actions = <Widget>[];

    if (org.status == 'pending') {
      actions.addAll([
        _actionChip(
          'Approve',
          Icons.check_circle_outline,
          AppColors.success,
          () => provider.approveOrganizer(org.id),
        ),
        const SizedBox(width: 8),
        _actionChip(
          'Reject',
          Icons.cancel_outlined,
          AppColors.destructive,
          () async {
            final confirm = await ConfirmationDialog.show(
              context,
              title: 'Reject Organizer',
              message: 'Are you sure you want to reject "${org.name}"?',
              confirmLabel: 'Reject',
              isDestructive: true,
            );
            if (confirm) provider.rejectOrganizer(org.id);
          },
        ),
      ]);
    } else if (org.status == 'approved') {
      actions.add(
        _actionChip('Block', Icons.block, AppColors.destructive, () async {
          final confirm = await ConfirmationDialog.show(
            context,
            title: 'Block Organizer',
            message: 'Are you sure you want to block "${org.name}"?',
            confirmLabel: 'Block',
            isDestructive: true,
          );
          if (confirm) provider.blockOrganizer(org.id);
        }),
      );
    } else if (org.status == 'blocked') {
      actions.add(
        _actionChip(
          'Unblock',
          Icons.lock_open,
          AppColors.primary,
          () => provider.unblockOrganizer(org.id),
        ),
      );
    }

    return actions;
  }

  Widget _actionChip(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
