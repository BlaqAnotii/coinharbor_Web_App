class InvestmentOptionsResponse {
  final bool status;
  final String message;
  final List<InvestmentOption> data;

  InvestmentOptionsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory InvestmentOptionsResponse.fromJson(Map<String, dynamic> json) {
    return InvestmentOptionsResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => InvestmentOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class InvestmentOption {
  final int id;
  final String name;
  final String coin;
  final double minAmount;
  final double maxAmount;
  final int durationDays;
  final double apy;
  final String status;

  InvestmentOption({
    required this.id,
    required this.name,
    required this.coin,
    required this.minAmount,
    required this.maxAmount,
    required this.durationDays,
    required this.apy,
    required this.status,
  });

  factory InvestmentOption.fromJson(Map<String, dynamic> json) {
    return InvestmentOption(
      id: json['id'] as int,
      name: json['name'] as String,
      coin: json['coin'] as String,
      minAmount: (json['min_amount'] as num).toDouble(),
      maxAmount: (json['max_amount'] as num).toDouble(),
      durationDays: json['duration_days'] as int,
      apy: (json['apy'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'coin': coin,
        'min_amount': minAmount,
        'max_amount': maxAmount,
        'duration_days': durationDays,
        'apy': apy,
        'status': status,
      };
}
