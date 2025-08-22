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
  late final int status;
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
      id: json['id'],
      doctorId: json['doctorId'],
      categoryId: json['categoryId'],
      numberOfAssistants: json['numberOfAsisstants'] ?? 0,
      status: json['status'],
      date: DateTime.parse(json['date']),
      doctor: Doctor.fromJson(json['doctor']),
      tools: List<AdditionalTool>.from(
          (json['requiredTools'] ?? []).map((x) => AdditionalTool.fromJson(x))),

      kits: [
        ...(json['surgicalKits'] ?? []).map((x) => Kit.fromJson(x)),
        ...(json['implantKits'] ?? []).map((x) => Kit.fromJson({
          ...x,
          'isImplantKit': true,
        })),
      ],
      assistants: List<Assistant>.from(
          (json['assistants'] ?? []).map((x) => Assistant.fromJson(x))),
      assistantIds: (json['assistants'] as List<dynamic>?)
          ?.map((a) => a['id'] as String)
          .toList() ?? [],
    );
  }


  String get statusText {
    switch (status) {
      case 1: return "Request_Sent";
      case 2: return "In_Progress";
      case 3: return "Done";
      case 4: return "Declined";
      case 5: return "Cancelled";
      default: return "Request_Sent";
    }
  }

  Color get statusColor {
    switch (status) {
      case 1: return Colors.orange;
      case 2: return Colors.blue;
      case 3: return Colors.green;
      case 4: return Colors.red;
      case 5 : return Colors.grey;
      default: return Colors.orange;
    }
  }
}