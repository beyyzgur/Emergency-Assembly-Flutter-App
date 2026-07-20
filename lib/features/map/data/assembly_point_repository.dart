import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/assembly_point_model.dart';

final assemblyPointRepositoryProvider = Provider(
  (ref) => AssemblyPointRepository(),
);

class AssemblyPointRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AssemblyPointModel>> getAssemblyPoints() async {
    try {
      final snapshot = await _firestore.collection('assembly_points').get();

      return snapshot.docs.map((doc) {
        return AssemblyPointModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception("Toplanma alanları getirilirken hata oluştu: $e");
    }
  }
}
