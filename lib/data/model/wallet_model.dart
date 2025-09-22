class WalletResponse {
  final bool status;
  final String message;
  final int count;
  final List<Wallet> data;

  WalletResponse({
    required this.status,
    required this.message,
    required this.count,
    required this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Wallet.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'count': count,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Wallet {
  final int id;
  final String currency;
  final String network;
  final String address;
  final double balance;
  final double fiatBalance;
  final double lastFiatRate;

  Wallet({
    required this.id,
    required this.currency,
    required this.network,
    required this.address,
    required this.balance,
    required this.fiatBalance,
    required this.lastFiatRate,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] ?? 0,
      currency: json['currency'] ?? '',
      network: json['network'] ?? '',
      address: json['address'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      fiatBalance: (json['fiat_balance'] ?? 0).toDouble(),
      lastFiatRate: (json['last_fiat_rate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currency': currency,
      'network': network,
      'address': address,
      'balance': balance,
      'fiat_balance': fiatBalance,
      'last_fiat_rate': lastFiatRate,
    };
  }
}
