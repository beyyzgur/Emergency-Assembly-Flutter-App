class NeedModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final double latitude;
  final double longitude;
  final String urgency;
  final DateTime createdAt;
  final String reporterId;

  NeedModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.urgency,
    required this.createdAt,
    required this.reporterId,
  });

  factory NeedModel.fromJson(Map<String, dynamic> json, String documentId) {
    return NeedModel(
      id: documentId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Diğer',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      urgency: json['urgency'] ?? 'Orta',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      reporterId: json['reporterId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'urgency': urgency,
      'createdAt': createdAt.toIso8601String(),
      'reporterId': reporterId,
    };
  }
}
