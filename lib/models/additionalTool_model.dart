class AdditionalTool {
  final int? id;
  final String? name;
  final double? width;
  final double? height;
  final double? thickness;
  final int? quantity;
  final int? kitId;
  final int? categoryId;

  AdditionalTool({
    required this.id,
    required this.name,
    required this.width,
    required this.height,
    required this.thickness,
    required this.quantity,
    this.kitId,
    required this.categoryId,
  });

  factory AdditionalTool.fromJson(Map<String, dynamic> json) {
    return AdditionalTool(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      thickness: (json['thickness'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      kitId: json['kitId'] as int?,
      categoryId: json['categoryId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'width': width,
    'height': height,
    'thickness': thickness,
    'quantity': quantity,
    'kitId': kitId,
    'categoryId': categoryId,
  };
}