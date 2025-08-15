import 'dart:ui';
import 'package:flutter/material.dart';
import 'assistant_model.dart';
import 'doctor_model.dart';
import 'additionalTool_model.dart';
import 'kit_model.dart';

class Procedure {
  final int id;
  final String doctorId;
  final int numberOfAssistants;
  final List<String> assistantIds;
  final int categoryId;
  final int status;
  final DateTime date;
  final Doctor doctor;
  final List<AdditionalTool> tools;
  final List<Kit> kits;
  final List<Assistant> assistants;

  Procedure({
    required this.id,
    required this.doctorId,
    required this.numberOfAssistants,
    required this.assistantIds,
    required this.categoryId,
    required this.status,
    required this.date,
    required this.doctor,
    required this.tools,
    required this.kits,
    required this.assistants,
  });



  factory Procedure.fromJson(Map<String, dynamic> json) {
  // طباعة جميع مفاتيح JSON للتحقق
  print('JSON keys in Procedure: ${json.keys.join(', ')}');

  // تحديد القيمة الصحيحة لعدد المساعدين
  final numAssistants = json['numberOfAsisstants'] ?? // مع 3 أحرف 's'
  json['numberOfAssistants'] ?? // مع 4 أحرف 's'
  0;

  // تحديد assistantIds سواء كانت null أو غير موجودة
  final assistantIds = json['assistantIds'] is List
  ? List<String>.from(json['assistantIds'])
      : <String>[];

  return Procedure(
  id: json['id'] as int? ?? 0,
  doctorId: json['doctorId'] as String? ?? '',
  numberOfAssistants: (numAssistants as int?) ?? 0,
  assistantIds: assistantIds,
  categoryId: json['categoryId'] as int? ?? 0,
  status: json['status'] as int? ?? 0,
  date: json['date'] != null
  ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
      : DateTime.now(),
  doctor: Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
  tools: (json['tools'] as List?)?.map((x) => AdditionalTool.fromJson(x)).toList() ?? [],
  kits: (json['kits'] as List?)?.map((x) => Kit.fromJson(x)).toList() ?? [],
  assistants: (json['assistants'] as List?)?.map((x) => Assistant.fromJson(x)).toList() ?? [],
  );
  }


  String get statusText {
    switch (status) {
      case 1: return "Request_Sent";
      case 2: return "In_Progress";
      case 3: return "Done";
      case 4: return "Declined";
      default: return "Request_Sent";
    }
  }

  Color get statusColor {
    switch (status) {
      case 1: return Colors.orange;
      case 2: return Colors.blue;
      case 3: return Colors.green;
      case 4: return Colors.red;
      default: return Colors.orange;
    }
  }
}