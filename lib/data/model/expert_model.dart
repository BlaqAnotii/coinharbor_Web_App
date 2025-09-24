class ExpertResponse {
  final bool status;
  final String message;
  final List<Expert> data;

  ExpertResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ExpertResponse.fromJson(Map<String, dynamic> json) {
    return ExpertResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Expert.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Expert {
  final int id;
  final String name;
  final String email;
  final double roi;

  final int followers;
  final String risklevel;
  final int activeTrades;
  final String asset;
  final double volume;

  Expert({
    required this.id,
    required this.name,
    required this.email,
    required this.roi,
    required this.followers,
    required this.risklevel,
    required this.activeTrades,
    required this.asset,
    required this.volume,
  });

  factory Expert.fromJson(Map<String, dynamic> json) {
    return Expert(
      id: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roi: (json['roi'] as num?)?.toDouble() ?? 0.0,
      followers: json['followers_count'] ?? 0,
      risklevel: json['risk_level'] ?? '',
      activeTrades: json['active_trades'] ?? 0,
      asset: json['trade_asset'] ?? '',
      volume: (json['trade_volume'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
      'roi': roi,
      'followers_count': followers,
      'risk_level': risklevel,
      'active_trades': activeTrades,
      'trade_asset': asset,
      'trade_volume': volume,
    };
  }
}
