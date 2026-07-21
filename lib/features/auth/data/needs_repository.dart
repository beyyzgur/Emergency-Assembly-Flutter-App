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

  Future<void> updateNeed(NeedModel need) async {
    if (need.id.isEmpty) {
      throw Exception('İhtiyaç kaydı bulunamadı, güncelleme yapılamaz.');
    }
    if (need.title.isEmpty) {
      throw Exception('İhtiyaç başlığı boş bırakılamaz.');
    }
    if (need.reporterId.isEmpty) {
      throw Exception('Kullanıcı kimliği bulunamadı, güncelleme yapılamaz.');
    }

    try {
      await _firestore.collection('needs').doc(need.id).update(need.toJson());
    } catch (e) {
      throw Exception('İhtiyaç güncellenirken bir hata oluştu: $e');
    }
  }
}
