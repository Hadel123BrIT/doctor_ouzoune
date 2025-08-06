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
    return Kit(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isMainKit: json['isMainKit'] ?? false,
      implantCount: json['implantCount'] ?? 0,
      toolCount: json['toolCount'] ?? 0,
      implants: List<Implant>.from(
          (json['implants'] ?? []).map((x) => Implant.fromJson(x))),
      tools: List<AdditionalTool>.from(
          (json['tools'] ?? []).map((x) => AdditionalTool.fromJson(x))),
    );
  }
}