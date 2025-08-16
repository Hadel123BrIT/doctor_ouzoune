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

    final implant = json['implant'] != null
        ? Implant.fromJson(json['implant'])
        : null;
    final tools = (json['toolsWithImplant'] as List<dynamic>?)
        ?.map((t) => AdditionalTool.fromJson(t))
        .toList() ?? [];

    return Kit(
      id: json['id'] ?? json['kitId'] ?? 0,
      name: json['name'] ?? 'Unnamed Kit',
      isMainKit: json['isMainKit'] ?? false,
      implantCount: implant != null ? 1 : 0,
      toolCount: tools.length,
      implants: implant != null ? [implant] : [],
      tools: tools,
    );
  }

}