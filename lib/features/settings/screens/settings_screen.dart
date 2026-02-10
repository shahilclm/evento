import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../providers/settings_provider.dart';

/// Admin settings screen.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SettingsProvider>().fetchSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.settings == null) {
          return const LoadingWidget(message: 'Loading settings...');
        }
        if (provider.error != null && provider.settings == null) {
          return AppErrorWidget(
            message: provider.error!,
            onRetry: () => provider.fetchSettings(),
          );
        }
        final settings = provider.settings;
        if (settings == null) return const LoadingWidget();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Configure platform settings and preferences',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (provider.hasChanges)
                    ElevatedButton.icon(
                      onPressed: provider.isSaving
                          ? null
                          : () async {
                              final success = await provider.saveSettings();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? 'Settings saved successfully!'
                                          : 'Failed to save settings',
                                    ),
                                    backgroundColor: success
                                        ? AppColors.primary
                                        : AppColors.destructive,
                                  ),
                                );
                              }
                            },
                      icon: provider.isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_rounded, size: 18),
                      label: Text(
                        provider.isSaving ? 'Saving...' : 'Save Changes',
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Commission Settings ──
              _buildSection(
                title: 'Commission',
                icon: Icons.percent_rounded,
                children: [
                  _buildSliderTile(
                    title: 'Platform Commission',
                    subtitle:
                        '${settings.commissionPercent.toStringAsFixed(0)}%',
                    value: settings.commissionPercent,
                    min: 0,
                    max: 30,
                    divisions: 30,
                    onChanged: (v) => provider.setCommission(v),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Approval Settings ──
              _buildSection(
                title: 'Approval Settings',
                icon: Icons.verified_user_outlined,
                children: [
                  _buildSwitchTile(
                    title: 'Auto-Approve Events',
                    subtitle: 'Automatically approve new event submissions',
                    value: settings.autoApproveEvents,
                    onChanged: (v) => provider.setAutoApproveEvents(v),
                  ),
                  const Divider(
                    color: AppColors.divider,
                    height: 1,
                    indent: 16,
                  ),
                  _buildSwitchTile(
                    title: 'Auto-Approve Organizers',
                    subtitle: 'Automatically approve organizer registrations',
                    value: settings.autoApproveOrganizers,
                    onChanged: (v) => provider.setAutoApproveOrganizers(v),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Financial Settings ──
              _buildSection(
                title: 'Financial Settings',
                icon: Icons.account_balance_wallet_outlined,
                children: [
                  _buildSliderTile(
                    title: 'Minimum Withdrawal Amount',
                    subtitle:
                        '₹${settings.minWithdrawalAmount.toStringAsFixed(0)}',
                    value: settings.minWithdrawalAmount,
                    min: 500,
                    max: 10000,
                    divisions: 19,
                    onChanged: (v) => provider.setMinWithdrawalAmount(v),
                  ),
                  const Divider(
                    color: AppColors.divider,
                    height: 1,
                    indent: 16,
                  ),
                  _buildSliderTile(
                    title: 'Maximum Ticket Price',
                    subtitle: '₹${settings.maxTicketPrice.toStringAsFixed(0)}',
                    value: settings.maxTicketPrice,
                    min: 1000,
                    max: 100000,
                    divisions: 99,
                    onChanged: (v) => provider.setMaxTicketPrice(v),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Maintenance ──
              _buildSection(
                title: 'System',
                icon: Icons.settings_outlined,
                children: [
                  _buildSwitchTile(
                    title: 'Maintenance Mode',
                    subtitle:
                        'Temporarily disable the platform for maintenance',
                    value: settings.maintenanceMode,
                    onChanged: (v) => provider.setMaintenanceMode(v),
                    isDangerous: true,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isDangerous = false,
  }) {
    final activeColor = isDangerous ? AppColors.destructive : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: activeColor,
            activeTrackColor: activeColor.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.primary.withValues(alpha: 0.15),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
