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
    return Procedure(
      id: json['id'] as int? ?? 0,
      doctorId: json['doctorId'] as String? ?? '',
      numberOfAssistants: json['numberOfAssistants'] as int? ?? 0,
      assistantIds: List<String>.from(json['assistantIds'] as List? ?? []),
      categoryId: json['categoryId'] as int? ?? 0,
      status: json['status'] as int? ?? 1,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      doctor: Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
      tools: (json['tools'] as List?)?.map((x) => AdditionalTool.fromJson(x as Map<String, dynamic>)).toList() ?? [],
      kits: (json['kits'] as List?)?.map((x) => Kit.fromJson(x as Map<String, dynamic>)).toList() ?? [],
      assistants: (json['assistants'] as List?)?.map((x) => Assistant.fromJson(x as Map<String, dynamic>)).toList() ?? [],
    );
  }

  String get statusText {
    switch (status) {
      case 2: return "Pending";
      case 3: return "Accepted";
      case 4: return "Rejected";
      case 7: return "Custom Status";
      default: return "Unknown";
    }
  }

  Color get statusColor {
    switch (status) {
      case 2: return Colors.orange;
      case 3: return Colors.green;
      case 4: return Colors.red;
      case 7: return Colors.blue;
      default: return Colors.grey;
    }
  }
}