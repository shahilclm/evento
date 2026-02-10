import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';

/// Event management screen with tabbed view.
class EventManagementScreen extends StatefulWidget {
  const EventManagementScreen({super.key});

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<EventProvider>().setTabIndex(_tabController.index);
      }
    });
    Future.microtask(() => context.read<EventProvider>().fetchEvents());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.allEvents.isEmpty) {
          return const LoadingWidget(message: 'Loading events...');
        }
        if (provider.error != null && provider.allEvents.isEmpty) {
          return AppErrorWidget(
            message: provider.error!,
            onRetry: () => provider.fetchEvents(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Event Management',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Review and manage event submissions',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
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
                    _buildTab('Pending', provider.pendingCount),
                    _buildTab('Approved', provider.approvedCount),
                    _buildTab('Active', provider.activeCount),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: provider.filteredEvents.isEmpty
                    ? const EmptyStateWidget(
                        message: 'No events in this category',
                        icon: Icons.event_busy_rounded,
                      )
                    : ListView.separated(
                        itemCount: provider.filteredEvents.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _buildEventCard(
                          provider,
                          provider.filteredEvents[index],
                        ),
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
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventProvider provider, Event event) {
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
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(event.category),
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
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'by ${event.organizerName}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge.fromStatus(event.status),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _detailChip(Icons.calendar_today, event.date),
              _detailChip(Icons.location_on_outlined, event.venue),
              _detailChip(
                Icons.confirmation_number_outlined,
                event.ticketPrice > 0
                    ? currencyFormatter.format(event.ticketPrice)
                    : 'Free',
              ),
              _detailChip(
                Icons.people_outline,
                '${event.bookingsCount} bookings',
              ),
              _detailChip(Icons.category_outlined, event.category),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildEventActions(provider, event),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEventActions(EventProvider provider, Event event) {
    final actions = <Widget>[];

    if (event.status == 'pending') {
      actions.addAll([
        _buildActionChip(
          'Approve',
          Icons.check_circle_outline,
          AppColors.success,
          () => provider.approveEvent(event.id),
        ),
        const SizedBox(width: 8),
        _buildActionChip(
          'Reject',
          Icons.cancel_outlined,
          AppColors.destructive,
          () async {
            final confirm = await ConfirmationDialog.show(
              context,
              title: 'Reject Event',
              message: 'Reject "${event.title}"?',
              confirmLabel: 'Reject',
              isDestructive: true,
            );
            if (confirm) provider.rejectEvent(event.id);
          },
        ),
      ]);
    } else if (event.status == 'approved' || event.status == 'active') {
      actions.add(
        _buildActionChip(
          'Cancel',
          Icons.cancel_outlined,
          AppColors.destructive,
          () async {
            final confirm = await ConfirmationDialog.show(
              context,
              title: 'Cancel Event',
              message: 'Cancel "${event.title}"? This cannot be undone.',
              confirmLabel: 'Cancel Event',
              isDestructive: true,
            );
            if (confirm) provider.cancelEvent(event.id);
          },
        ),
      );
    }
    return actions;
  }

  Widget _buildActionChip(
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

  Widget _detailChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'technology':
        return Icons.computer_rounded;
      case 'music':
        return Icons.music_note_rounded;
      case 'business':
        return Icons.business_center_rounded;
      case 'cultural':
        return Icons.theater_comedy_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'comedy':
        return Icons.emoji_emotions_rounded;
      case 'exhibition':
        return Icons.museum_rounded;
      case 'sports':
        return Icons.sports_rounded;
      default:
        return Icons.event_rounded;
    }
  }
}
