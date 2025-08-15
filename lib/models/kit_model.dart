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
    // تحقق من وجود الأدوات وكونها List
    List<AdditionalTool> tools = [];
    if (json['tools'] != null && json['tools'] is List) {
      try {
        tools = (json['tools'] as List).map((toolJson) {
          // تحقق من أن toolJson هو Map
          if (toolJson is Map<String, dynamic>) {
            return AdditionalTool.fromJson(toolJson);
          }
          return AdditionalTool.empty();
        }).toList();
      } catch (e) {
        debugPrint('Error parsing tools: $e');
      }
    }

    return Kit(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unnamed Kit',
      isMainKit: json['isMainKit'] as bool? ?? false,
      implantCount: json['implantCount'] as int? ?? 0,
      toolCount: json['toolCount'] as int? ?? 0,
      implants: (json['implants'] as List<dynamic>?)
          ?.map((i) => Implant.fromJson(i))
          .toList() ?? [],
      tools: tools, // استخدم القائمة المحولة
    );
  }
}