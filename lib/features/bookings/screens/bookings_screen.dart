import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/booking.dart';
import '../providers/booking_provider.dart';

/// Bookings & payments screen — redesigned with responsive cards and tabs.
class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => context.read<BookingProvider>().fetchAll());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.bookings.isEmpty) {
          return const LoadingWidget(message: 'Loading bookings...');
        }
        if (provider.error != null && provider.bookings.isEmpty) {
          return AppErrorWidget(
            message: provider.error!,
            onRetry: () => provider.fetchAll(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              const Text(
                'Bookings & Payments',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Track bookings, payments, and manage withdrawal requests',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),

              // ── Revenue Summary (Always visible at top) ──
              if (provider.revenueStats != null)
                _buildRevenueSummary(provider.revenueStats!),
              const SizedBox(height: 32),

              // ── Tab Bar ──
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  tabs: [
                    _buildTab('Bookings', provider.bookingCount),
                    _buildTab('Withdrawals', provider.pendingWithdrawalCount),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Tab Content ──
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Bookings List
                    _buildBookingsList(provider),
                    // Tab 2: Withdrawals List
                    _buildWithdrawalsList(provider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookingsList(BookingProvider provider) {
    if (provider.bookings.isEmpty) {
      return const Center(
        child: Text(
          'No recent bookings found',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }
    return ListView.separated(
      itemCount: provider.bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _buildBookingCard(provider.bookings[index]),
    );
  }

  Widget _buildWithdrawalsList(BookingProvider provider) {
    return _buildWithdrawalSection(provider);
  }

  Widget _buildRevenueSummary(RevenueStats stats) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            StatCard(
              title: 'Total Revenue',
              value: currencyFormatter.format(stats.totalRevenue),
              icon: Icons.account_balance_rounded,
              iconColor: AppColors.primary,
              trend: stats.revenueTrend,
            ),
            StatCard(
              title: 'This Month',
              value: currencyFormatter.format(stats.thisMonthRevenue),
              icon: Icons.calendar_month_rounded,
              iconColor: AppColors.primaryLight,
            ),
            StatCard(
              title: 'Commission Earned',
              value: currencyFormatter.format(stats.totalCommission),
              icon: Icons.percent_rounded,
              iconColor: AppColors.primary,
              trend: stats.commissionTrend,
            ),
            StatCard(
              title: 'Pending Payouts',
              value: currencyFormatter.format(stats.pendingPayouts),
              icon: Icons.hourglass_bottom_rounded,
              iconColor: AppColors.primaryLight,
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookingCard(Booking b) {
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
          // ── Header: ID + Payment Status ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                b.id,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              _buildPaymentBadge(b.paymentStatus),
            ],
          ),
          const SizedBox(height: 12),

          // ── Event Title ──
          Text(
            b.eventTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 16),

          // ── Stats Wrap ──
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _statChip(Icons.person_outline, b.userName),
              _statChip(
                Icons.confirmation_num_outlined,
                '${b.ticketCount} tickets',
              ),
              _statChip(
                Icons.payments_outlined,
                currencyFormatter.format(b.amount),
              ),
              _statChip(Icons.calendar_today_outlined, b.bookingDate),
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

  Widget _buildPaymentBadge(String status) {
    Color color;
    switch (status) {
      case 'completed':
        color = AppColors.success;
        break;
      case 'pending':
        color = AppColors.textSecondary;
        break;
      case 'failed':
        color = AppColors.destructive;
        break;
      case 'refunded':
        color = AppColors.primaryLight;
        break;
      default:
        color = AppColors.textMuted;
    }
    return StatusBadge(
      label: status[0].toUpperCase() + status.substring(1),
      color: color,
    );
  }

  Widget _buildWithdrawalSection(BookingProvider provider) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    if (provider.withdrawals.isEmpty) {
      return const Center(
        child: Text(
          'No withdrawal requests found',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.separated(
      itemCount: provider.withdrawals.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildWithdrawalCard(
        provider,
        provider.withdrawals[index],
        currencyFormatter,
      ),
    );
  }

  Widget _buildWithdrawalCard(
    BookingProvider provider,
    WithdrawalRequest withdrawal,
    NumberFormat formatter,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      withdrawal.organizerName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bank: ${withdrawal.bankAccount}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatter.format(withdrawal.amount),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                withdrawal.requestDate,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StatusBadge.fromStatus(withdrawal.status),
                  if (withdrawal.status == 'pending') ...[
                    _actionChip(
                      'Approve',
                      Icons.check_circle_outline,
                      AppColors.success,
                      () => provider.approveWithdrawal(withdrawal.id),
                    ),
                    _actionChip(
                      'Reject',
                      Icons.cancel_outlined,
                      AppColors.destructive,
                      () async {
                        final confirm = await ConfirmationDialog.show(
                          context,
                          title: 'Reject Withdrawal',
                          message:
                              'Reject withdrawal of ${formatter.format(withdrawal.amount)} from "${withdrawal.organizerName}"?',
                          confirmLabel: 'Reject',
                          isDestructive: true,
                        );
                        if (confirm) provider.rejectWithdrawal(withdrawal.id);
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
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
      ),
    );
  }
}
