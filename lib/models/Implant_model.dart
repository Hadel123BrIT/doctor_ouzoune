class Implant {
  final int? id;
  final double? radius;
  final double? width;
  final double? height;
  final int? quantity;
  final String? brand;
  final String? description;
  final String? imagePath;
  final int? kitId;
  List<dynamic> get tools => [];

  Implant({
     this.id,
     this.radius,
     this.width,
     this.height,
     this.quantity,
     this.brand,
     this.description,
     this.imagePath,
     this.kitId,
  });

  factory Implant.fromJson(Map<String, dynamic> json) {
    try {
      return Implant(
        id: json['id'] as int? ?? 0,
        kitId: json['kitId'] as int? ?? 0,
        height: (json['height'] as num?)?.toDouble() ?? 0.0,
        width: (json['width'] as num?)?.toDouble() ?? 0.0,
        radius: (json['radius'] as num?)?.toDouble() ?? 0.0,
        quantity: json['quantity'] as int? ?? 0,
        brand: json['brand'] as String? ?? '',
        description: json['description'] as String? ?? '',
        imagePath: json['imagePath'] as String? ?? 'assets/images/default_implant.png',
      );
    } catch (e) {
      print('Error parsing implant: $e\nJSON: $json');
      throw Exception('Failed to parse implant');
    }
  }

}