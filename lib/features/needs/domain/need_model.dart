import 'package:cloud_firestore/cloud_firestore.dart';

class NeedModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final double latitude;
  final double longitude;
  final String urgency;
  final int peopleCount; // TODO listesindeki eksik alan eklendi
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
    required this.peopleCount,
    required this.createdAt,
    required this.reporterId,
  });

  factory NeedModel.fromJson(Map<String, dynamic> json, String documentId) {
    // Firestore'dan gelen Timestamp veya lokalden gelen String tarih verisini güvenli parse etme
    DateTime parsedDate = DateTime.now();
    if (json['createdAt'] != null) {
      if (json['createdAt'] is Timestamp) {
        parsedDate = (json['createdAt'] as Timestamp).toDate();
      } else {
        parsedDate =
            DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
      }
    }

    return NeedModel(
      id: documentId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Diğer',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      urgency: json['urgency'] ?? 'Orta',
      peopleCount: json['peopleCount'] ?? 1, // Kişi sayısı JSON'dan alındı
      createdAt: parsedDate,
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
      'peopleCount': peopleCount, // JSON'a eklendi
      'createdAt': createdAt.toIso8601String(),
      'reporterId': reporterId,
    };
  }
}
