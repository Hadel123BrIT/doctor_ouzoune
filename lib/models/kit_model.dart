import 'package:flutter/cupertino.dart';
import 'Implant_model.dart';
import 'additionalTool_model.dart';

class Kit {
  final int id;
  final String name;
  final bool isMainKit;
  final int implantCount;
  final int toolCount;
  final List<Implant> implants;
  final List<AdditionalTool> tools;

  Kit({
    required this.id,
    required this.name,
    required this.isMainKit,
    required this.implantCount,
    required this.toolCount,
    required this.implants,
    required this.tools,
  });

  factory Kit.fromJson(Map<String, dynamic> json) {
    // معالجة الزرعات (Implants)
    final implantsJson = json['implants'] as List<dynamic>? ?? [];
    final implants = implantsJson.map((e) => Implant.fromJson(e)).toList();

    // معالجة الأدوات (Tools)
    final toolsJson = json['tools'] as List<dynamic>? ?? [];
    final tools = toolsJson.map((e) => AdditionalTool.fromJson(e)).toList();

    return Kit(
      id: json['id'] ?? json['kitId'] ?? 0,
      name: json['name'] ?? 'Unnamed Kit',
      isMainKit: json['isMainKit'] ?? false,
      implantCount: implants.length,
      toolCount: tools.length,
      implants: implants,
      tools: tools,
    );
  }
}