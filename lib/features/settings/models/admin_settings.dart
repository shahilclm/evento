/// Admin settings model.
class AdminSettings {
  double commissionPercent;
  bool autoApproveEvents;
  bool autoApproveOrganizers;
  bool maintenanceMode;
  double minWithdrawalAmount;
  double maxTicketPrice;

  AdminSettings({
    required this.commissionPercent,
    required this.autoApproveEvents,
    required this.autoApproveOrganizers,
    required this.maintenanceMode,
    required this.minWithdrawalAmount,
    required this.maxTicketPrice,
  });

  factory AdminSettings.fromJson(Map<String, dynamic> json) {
    return AdminSettings(
      commissionPercent: (json['commissionPercent'] as num).toDouble(),
      autoApproveEvents: json['autoApproveEvents'] as bool,
      autoApproveOrganizers: json['autoApproveOrganizers'] as bool,
      maintenanceMode: json['maintenanceMode'] as bool,
      minWithdrawalAmount: (json['minWithdrawalAmount'] as num).toDouble(),
      maxTicketPrice: (json['maxTicketPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commissionPercent': commissionPercent,
      'autoApproveEvents': autoApproveEvents,
      'autoApproveOrganizers': autoApproveOrganizers,
      'maintenanceMode': maintenanceMode,
      'minWithdrawalAmount': minWithdrawalAmount,
      'maxTicketPrice': maxTicketPrice,
    };
  }
}
