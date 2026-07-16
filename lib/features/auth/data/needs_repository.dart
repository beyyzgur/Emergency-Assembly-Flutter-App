import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_assembly_app/features/needs/domain/need_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final needsRepositoryProvider = Provider((ref) => NeedsRepository());

class NeedsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNeed(NeedModel need) async {
    if (need.title.isNotEmpty) {
      if (need.reporterId.isNotEmpty) {
        try {
          await _firestore.collection('needs').add(need.toJson());
        } catch (e) {
          throw Exception("Veritabanına kayıt sırasında bir hata oluştu: $e");
        }
      } else {
        throw Exception("Kullanıcı kimliği bulunamadı, kayıt yapılamaz.");
      }
    } else {
      throw Exception("İhtiyaç başlığı boş bırakılamaz.");
    }
  }
}
