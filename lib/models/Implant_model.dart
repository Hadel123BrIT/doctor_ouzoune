class Implant {
  final int id;
  final double radius;
  final double width;
  final double height;
  final int quantity;
  final String brand;
  final String description;
  final String imagePath;
  final int kitId;

  Implant({
    required this.id,
    required this.radius,
    required this.width,
    required this.height,
    required this.quantity,
    required this.brand,
    required this.description,
    required this.imagePath,
    required this.kitId,
  });

  factory Implant.fromJson(Map<String, dynamic> json) {
    return Implant(
      id: json['id'],
      radius: json['radius']?.toDouble() ?? 0.0,
      width: json['width']?.toDouble() ?? 0.0,
      height: json['height']?.toDouble() ?? 0.0,
      quantity: json['quantity'],
      brand: json['brand'],
      description: json['description'],
      imagePath: json['imagePath'],
      kitId: json['kitId'],
    );
  }

}