class TransactionsResponse {
  final bool status;
  final String message;
  final int count;
  final List<Transaction> data;

  TransactionsResponse({
    required this.status,
    required this.message,
    required this.count,
    required this.data,
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Transaction.fromJson(e))
          .toList(),
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

class Transaction {
  final int id;
  final String type;
  final String asset;
  final String network;
  final double amount;
  final double fiatAmount;
  final String status;
  final String? txHash;
  final String? method;
  final String description;
  final String createdAt;
  final String updatedAt;

  Transaction({
    required this.id,
    required this.type,
    required this.asset,
    required this.network,
    required this.amount,
    required this.fiatAmount,
    required this.status,
    this.txHash,
    this.method,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      asset: json['asset'] ?? '',
      network: json['network']?.toString().trim() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      fiatAmount: (json['fiat_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      txHash: json['tx_hash'],
      method: json['method'],
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'asset': asset,
      'network': network,
      'amount': amount,
      'fiat_amount': fiatAmount,
      'status': status,
      'tx_hash': txHash,
      'method': method,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
