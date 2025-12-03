import 'package:nylo_framework/nylo_framework.dart';

class DisasterImage extends Model {

  final int? id;
  final int disasterId;
  final String imagePath;

  DisasterImage({
    this.id,
    required this.disasterId,
    required this.imagePath,
  });

  factory DisasterImage.fromMap(Map<String, dynamic> map) {
    return DisasterImage(
      id: map['id'] as int?,
      disasterId: map['disaster_id'] as int,
      imagePath: map['image_path'] as String,
    );
  }

  // Chuyển Object sang Map để insert vào database
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'disaster_id': disasterId,
      'image_path': imagePath,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'disaster_id': disasterId,
      'image_path': imagePath,
    };
  }

  @override
  String toString() {
    return 'DisasterImage{id: $id, disasterId: $disasterId, path: $imagePath}';
  }

  // Copy with method
  DisasterImage copyWith({
    int? id,
    int? disasterId,
    String? imagePath,
  }) {
    return DisasterImage(
      id: id ?? this.id,
      disasterId: disasterId ?? this.disasterId,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  static fromJson(data) {}
}
