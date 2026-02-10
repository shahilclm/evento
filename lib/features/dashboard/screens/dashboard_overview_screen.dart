import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/stat_card.dart';
import '../models/dashboard_stats.dart';
import '../providers/dashboard_provider.dart';

/// Dashboard overview screen with summary cards and recent activity.
class DashboardOverviewScreen extends StatefulWidget {
  const DashboardOverviewScreen({super.key});

  @override
  State<DashboardOverviewScreen> createState() =>
      _DashboardOverviewScreenState();
}

class _DashboardOverviewScreenState extends State<DashboardOverviewScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DashboardProvider>().fetchStats());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.stats == null) {
          return const LoadingWidget(message: 'Loading dashboard...');
        }
        if (provider.error != null && provider.stats == null) {
          return AppErrorWidget(
            message: provider.error!,
            onRetry: () => provider.fetchStats(),
          );
        }
        final stats = provider.stats;
        if (stats == null) return const LoadingWidget();

        return RefreshIndicator(
          onRefresh: () => provider.fetchStats(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(),
                const SizedBox(height: 24),
                _buildStatCards(stats),
                const SizedBox(height: 32),
                _buildPendingAlerts(stats),
                const SizedBox(height: 32),
                _buildRecentActivity(stats.recentActivity),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader() {
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good morning'
        : now.hour < 17
        ? 'Good afternoon'
        : 'Good evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, Admin 👋',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE, MMM d, yyyy').format(now),
          style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildStatCards(DashboardStats stats) {
    final formatter = NumberFormat('#,##,###');
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 5
            : constraints.maxWidth > 600
            ? 3
            : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            StatCard(
              title: 'Total Users',
              value: formatter.format(stats.totalUsers),
              icon: Icons.people_outline_rounded,
              iconColor: AppColors.primary,
              trend: stats.usersTrend,
            ),
            StatCard(
              title: 'Organizers',
              value: formatter.format(stats.totalOrganizers),
              icon: Icons.business_outlined,
              iconColor: AppColors.primaryLight,
              trend: stats.organizersTrend,
            ),
            StatCard(
              title: 'Total Events',
              value: formatter.format(stats.totalEvents),
              icon: Icons.event_outlined,
              iconColor: AppColors.primary,
              trend: stats.eventsTrend,
            ),
            StatCard(
              title: 'Bookings',
              value: formatter.format(stats.totalBookings),
              icon: Icons.receipt_long_outlined,
              iconColor: AppColors.primaryLight,
              trend: stats.bookingsTrend,
            ),
            StatCard(
              title: 'Revenue',
              value: currencyFormatter.format(stats.totalRevenue),
              icon: Icons.currency_rupee_rounded,
              iconColor: AppColors.primary,
              trend: stats.revenueTrend,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPendingAlerts(DashboardStats stats) {
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
          const Row(
            children: [
              Icon(
                Icons.pending_actions_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Pending Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAlertTile(
                  '${stats.pendingOrganizers}',
                  'Organizer Approvals',
                  Icons.business_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAlertTile(
                  '${stats.pendingEvents}',
                  'Event Approvals',
                  Icons.event_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAlertTile(
                  '${stats.pendingWithdrawals}',
                  'Withdrawal Requests',
                  Icons.account_balance_wallet_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertTile(String count, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<ActivityItem> activities) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.auto_graph_rounded,
                        color: AppColors.primaryDark,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: const Text(
                    'View All',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return _buildActivityTile(
                  activities[index],
                  isLast: index == activities.length - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(ActivityItem activity, {bool isLast = false}) {
    final typeColor = _getActivityColor(activity.type);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: typeColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getActivityIcon(activity.type),
                    color: typeColor,
                    size: 18,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          typeColor.withValues(alpha: 0.5),
                          AppColors.border.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  activity.message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _formatTimestamp(activity.timestamp),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (!isLast) const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'organizer_signup':
        return Colors.blue;
      case 'event_created':
        return Colors.deepPurple;
      case 'booking':
        return AppColors.success;
      case 'withdrawal':
        return Colors.orange;
      case 'user_report':
        return AppColors.destructive;
      case 'event_completed':
        return AppColors.success;
      default:
        return AppColors.primaryDark;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'organizer_signup':
        return Icons.person_add_rounded;
      case 'event_created':
        return Icons.event_rounded;
      case 'booking':
        return Icons.receipt_long_rounded;
      case 'withdrawal':
        return Icons.account_balance_wallet_rounded;
      case 'user_report':
        return Icons.report_rounded;
      case 'event_completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes} ${diff.inMinutes == 1 ? 'min' : 'mins'} ago';
      }
      if (diff.inHours < 24) {
        return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
      }
      if (diff.inDays < 7) {
        return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
      }
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return timestamp;
    }
  }
}
