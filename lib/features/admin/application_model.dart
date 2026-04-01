import 'dart:convert';

/// Model for a single application record from the Apps Script backend.
class ApplicationRecord {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String church;
  final String ministryType;
  final String paymentStatus;   // "PAID" | "PENDING"
  final String paymentId;
  final String paymentMode;
  final String timestamp;
  final String verificationStatus; // "VERIFIED" | "NOT VERIFIED"
  final Map<String, dynamic> fullJson;

  const ApplicationRecord({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.church,
    required this.ministryType,
    required this.paymentStatus,
    required this.paymentId,
    required this.paymentMode,
    required this.timestamp,
    required this.verificationStatus,
    required this.fullJson,
  });

  factory ApplicationRecord.fromJson(Map<String, dynamic> json) {
    return ApplicationRecord(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      church: (json['church'] ?? '').toString(),
      ministryType: (json['ministry_type'] ?? json['ministryType'] ?? '').toString(),
      paymentStatus: (json['payment_status'] ?? json['paymentStatus'] ?? 'PENDING').toString().toUpperCase(),
      paymentId: (json['payment_id'] ?? json['paymentId'] ?? '').toString(),
      paymentMode: (json['payment_mode'] ?? json['paymentMode'] ?? '').toString(),
      timestamp: (json['timestamp'] ?? '').toString(),
      verificationStatus: (json['verification_status'] ?? json['verificationStatus'] ?? 'NOT VERIFIED').toString().toUpperCase(),
      fullJson: _parseFullJson(json['full_json'] ?? {}),
    );
  }

  static Map<String, dynamic> _parseFullJson(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {}
    }
    return {};
  }

  ApplicationRecord copyWith({String? verificationStatus}) {
    return ApplicationRecord(
      id: id,
      name: name,
      phone: phone,
      address: address,
      church: church,
      ministryType: ministryType,
      paymentStatus: paymentStatus,
      paymentId: paymentId,
      paymentMode: paymentMode,
      timestamp: timestamp,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      fullJson: fullJson,
    );
  }
}
