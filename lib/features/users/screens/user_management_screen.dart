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
import '../models/app_user.dart';
import '../providers/user_provider.dart';

/// User management screen — redesigned card layout.
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<UserProvider>().fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.users.isEmpty) {
          return const LoadingWidget(message: 'Loading users...');
        }
        if (provider.error != null && provider.users.isEmpty) {
          return AppErrorWidget(
            message: provider.error!,
            onRetry: () => provider.fetchUsers(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              const Text(
                'User Management',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage registered users, view booking history',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),

              // ── Search ──
              SearchField(
                hint: 'Search users...',
                onChanged: (q) => provider.setSearchQuery(q),
              ),
              const SizedBox(height: 20),

              // ── User List ──
              Expanded(
                child: provider.users.isEmpty
                    ? const EmptyStateWidget(
                        message: 'No users found',
                        icon: Icons.people_outline,
                      )
                    : ListView.separated(
                        itemCount: provider.users.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final user = provider.users[index];
                          return _buildUserCard(provider, user);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserCard(UserProvider provider, AppUser user) {
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
                  user.name[0],
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
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge.fromStatus(user.status),
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
              _statChip(Icons.phone_outlined, user.phone),
              _statChip(
                Icons.confirmation_num_outlined,
                '${user.bookingsCount} bookings',
              ),
              _statChip(
                Icons.calendar_today_outlined,
                'Joined ${user.joinedDate}',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Actions ──
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _actionChip(
                'History',
                Icons.history,
                AppColors.primary,
                () => _showBookingHistory(provider, user),
              ),
              const SizedBox(width: 8),
              if (user.status == 'active')
                _actionChip(
                  'Block',
                  Icons.block,
                  AppColors.destructive,
                  () async {
                    final confirm = await ConfirmationDialog.show(
                      context,
                      title: 'Block User',
                      message: 'Are you sure you want to block "${user.name}"?',
                      confirmLabel: 'Block',
                      isDestructive: true,
                    );
                    if (confirm) provider.blockUser(user.id);
                  },
                )
              else if (user.status == 'blocked')
                _actionChip(
                  'Unblock',
                  Icons.lock_open,
                  AppColors.primary,
                  () => provider.unblockUser(user.id),
                ),
            ],
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

  void _showBookingHistory(UserProvider provider, AppUser user) {
    provider.fetchBookingHistory(user.id);
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  user.name[0],
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'Booking History',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            height: 400,
            child: Consumer<UserProvider>(
              builder: (context, p, _) {
                if (p.isLoadingHistory) {
                  return const LoadingWidget(message: 'Loading history...');
                }
                if (p.bookingHistory.isEmpty) {
                  return const EmptyStateWidget(
                    message: 'No booking history',
                    icon: Icons.receipt_long_outlined,
                  );
                }
                return ListView.separated(
                  itemCount: p.bookingHistory.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.divider),
                  itemBuilder: (context, index) {
                    final b = p.bookingHistory[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        b.eventTitle,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        b.date,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currencyFormatter.format(b.amount),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          StatusBadge.fromStatus(b.status),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
