class InvestmentHistoryResponse {
  final bool status;
  final String message;
  final int count;
  final List<InvestmentHistory> data;

  InvestmentHistoryResponse({
    required this.status,
    required this.message,
    required this.count,
    required this.data,
  });

  factory InvestmentHistoryResponse.fromJson(Map<String, dynamic> json) {
    return InvestmentHistoryResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      count: json['count'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => InvestmentHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'count': count,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class InvestmentHistory {
  final int investmentId;
  final int optionId;
  final String optionName;
  final String coin;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final double apy;
  final String status;
  final double accruedFiat;

  InvestmentHistory({
    required this.investmentId,
    required this.optionId,
    required this.optionName,
    required this.coin,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.apy,
    required this.status,
    required this.accruedFiat,
  });

  factory InvestmentHistory.fromJson(Map<String, dynamic> json) {
    return InvestmentHistory(
      investmentId: json['investment_id'] as int,
      optionId: json['option_id'] as int,
      optionName: json['option_name'] as String,
      coin: json['coin'] as String,
      amount: (json['amount'] as num).toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      apy: (json['apy'] as num).toDouble(),
      status: json['status'] as String,
      accruedFiat: (json['accrued_fiat'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'investment_id': investmentId,
        'option_id': optionId,
        'option_name': optionName,
        'coin': coin,
        'amount': amount,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'apy': apy,
        'status': status,
        'accrued_fiat': accruedFiat,
      };
}
