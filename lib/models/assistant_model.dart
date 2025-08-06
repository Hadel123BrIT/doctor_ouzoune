import 'clinic_model.dart';

class Assistant {
  final String id;
  final String userName;
  final String email;
  final String? phoneNumber;
  final String role;
  final Clinic? clinic;
  final double? rate;

  Assistant({
    required this.id,
    required this.userName,
    required this.email,
    this.phoneNumber,
    required this.role,
    this.clinic,
    this.rate,
  });

  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      id: json['id'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String? ?? 'User',
      clinic: json['clinic'] != null ? Clinic.fromJson(json['clinic'] as Map<String, dynamic>) : null,
      rate: (json['rate'] as num?)?.toDouble(),
    );
  }
}