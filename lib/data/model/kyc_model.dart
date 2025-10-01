class KycResponse {
  final bool status;
  final String message;
  final KycData? data;

  KycResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory KycResponse.fromJson(Map<String, dynamic> json) {
    return KycResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? KycData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class KycData {
  final String idNumber;
  final String idType;
  final String status; // pending, approved, rejected
  final String? verifiedAt; // nullable

  KycData({
    required this.idNumber,
    required this.idType,
    required this.status,
    this.verifiedAt,
  });

  factory KycData.fromJson(Map<String, dynamic> json) {
    return KycData(
      idNumber: json['id_number'] ?? '',
      idType: json['id_type'] ?? '',
      status: json['status'] ?? '',
      verifiedAt: json['verified_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_number": idNumber,
      "id_type": idType,
      "status": status,
      "verified_at": verifiedAt,
    };
  }
}
