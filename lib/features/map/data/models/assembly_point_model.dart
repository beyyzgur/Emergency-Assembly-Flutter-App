import 'package:cloud_firestore/cloud_firestore.dart';

class AssemblyPointModel {
  final String id;
  final String name;
  final List<GeoPoint> polygonCoordinates;
  final int capacity;

  AssemblyPointModel({
    required this.id,
    required this.name,
    required this.polygonCoordinates,
    this.capacity = 0,
  });

  factory AssemblyPointModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    final List<dynamic> rawCoords = map['polygonCoordinates'] ?? [];
    final List<GeoPoint> coords = rawCoords.map((e) => e as GeoPoint).toList();

    return AssemblyPointModel(
      id: documentId,
      name: map['name'] ?? 'İsimsiz Toplanma Alanı',
      polygonCoordinates: coords,
      capacity: map['capacity'] ?? 0,
    );
  }
}
