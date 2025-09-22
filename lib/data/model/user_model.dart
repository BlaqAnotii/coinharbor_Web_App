class UserResponse {
  final bool status;
  final String message;
  final User data;

  UserResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: User.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? dob;
  final String? gender;
  final String? address;
  final String? phone;
  final String? country;
  final List<Wallets> wallets;
  final List<PaymentMethod> paymentMethods;
  final double fiatBalance;
  final bool emailVerified;
  final bool testMode;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.dob,
    this.gender,
    this.address,
    this.phone,
    this.country,
    required this.wallets,
    required this.paymentMethods,
    required this.fiatBalance,
    required this.emailVerified,
    required this.testMode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    dob: json['dob'],
    gender: json['gender'],
    address: json['address'],
    phone: json['phone'],
    country: json['country'],
    wallets: (json['wallets'] as List<dynamic>?)
            ?.map((e) => Wallets.fromJson(e))
            .toList() ??
        [],
    paymentMethods: (json['payment_methods'] as List<dynamic>?)
            ?.map((e) => PaymentMethod.fromJson(e))
            .toList() ??
        [],
    fiatBalance: (json['fiat_balance'] != null)
        ? double.tryParse(json['fiat_balance'].toString()) ?? 0.0
        : 0.0,
    emailVerified: json['email_verified'] ?? false,
    testMode: json['test_mode'] ?? false,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dob': dob,
      'gender': gender,
      'address': address,
      'phone': phone,
      'country': country,
      'wallets': wallets.map((e) => e.toJson()).toList(),
      'payment_methods':
          paymentMethods.map((e) => e.toJson()).toList(),
      'fiat_balance': fiatBalance,
      'email_verified': emailVerified,
      'test_mode': testMode,
    };
  }
}

class Wallets {
  final String currency;
  final String network;
  final String address;
  final double balance;
  final double fiatBalance;

  Wallets({
    required this.currency,
    required this.network,
    required this.address,
    required this.balance,
    required this.fiatBalance,
  });

  factory Wallets.fromJson(Map<String, dynamic> json) {
    return Wallets(
      currency: json['currency'] ?? '',
      network: json['network'] ?? '',
      address: json['address'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      fiatBalance: (json['fiat_balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'network': network,
      'address': address,
      'balance': balance,
      'fiat_balance': fiatBalance,
    };
  }
}

class PaymentMethod {
  final int id;
  final String type;
  final String provider;
  final String accountNumber;
  final String accountName;
  final String countryCode;
  final String currencyCode;
  final bool isDefault;
  final String status;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.provider,
    required this.accountNumber,
    required this.accountName,
    required this.countryCode,
    required this.currencyCode,
    required this.isDefault,
    required this.status,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      provider: json['provider'] ?? '',
      accountNumber: json['account_number'] ?? '',
      accountName: json['account_name'] ?? '',
      countryCode: json['country_code'] ?? '',
      currencyCode: json['currency_code'] ?? '',
      isDefault: json['is_default'] ?? false,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'provider': provider,
      'account_number': accountNumber,
      'account_name': accountName,
      'country_code': countryCode,
      'currency_code': currencyCode,
      'is_default': isDefault,
      'status': status,
    };
  }
}
