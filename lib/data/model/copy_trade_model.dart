class CopyTradesResponse {
  final bool status;
  final String message;
  final List<CopyTrade> data;

  CopyTradesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CopyTradesResponse.fromJson(Map<String, dynamic> json) {
    return CopyTradesResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => CopyTrade.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class CopyTrade {
  final int copyId;
  final int traderId;
  final String traderName;
  final double allocationAmount;
  final String allocationCurrency;
  final double currentValue;
  final String status;
  final DateTime createdAt;
  final double roi;
  final String riskLevel;

  CopyTrade({
    required this.copyId,
    required this.traderId,
    required this.traderName,
    required this.allocationAmount,
    required this.allocationCurrency,
    required this.currentValue,
    required this.status,
    required this.createdAt,
    required this.roi,
    required this.riskLevel,
  });

  factory CopyTrade.fromJson(Map<String, dynamic> json) {
    return CopyTrade(
      copyId: json['copy_id'] as int,
      traderId: json['trader_id'] as int,
      traderName: json['trader_name'] as String,
      allocationAmount: (json['allocation_amount'] as num).toDouble(),
      allocationCurrency: json['allocation_currency'] as String,
      currentValue: (json['current_value'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at']),
      roi: (json['roi'] as num).toDouble(),
      riskLevel: json['risk_level'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'copy_id': copyId,
        'trader_id': traderId,
        'trader_name': traderName,
        'allocation_amount': allocationAmount,
        'allocation_currency': allocationCurrency,
        'current_value': currentValue,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'roi': roi,
        'risk_level': riskLevel,
      };
}
