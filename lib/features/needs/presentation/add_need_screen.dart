import 'package:emergency_assembly_app/features/auth/data/needs_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/need_model.dart';

class AddNeedScreen extends ConsumerStatefulWidget {
  const AddNeedScreen({super.key});

  @override
  ConsumerState<AddNeedScreen> createState() => _AddNeedScreenState();
}

class _AddNeedScreenState extends ConsumerState<AddNeedScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedCategory = 'Su';
  String _selectedUrgency = 'Orta';

  final List<String> _categories = [
    'Su',
    'Erzak',
    'Barınma',
    'Sağlık',
    'Diğer',
  ];
  final List<String> _urgencies = ['Düşük', 'Orta', 'Yüksek', 'Kritik'];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final newNeed = NeedModel(
          id: '',
          title: _titleController.text,
          description: _descController.text,
          category: _selectedCategory,
          latitude: 39.92077,
          longitude: 32.85411,
          urgency: _selectedUrgency,
          createdAt: DateTime.now(),
          reporterId: currentUser.uid,
        );

        try {
          await ref.read(needsRepositoryProvider).addNeed(newNeed);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('İhtiyaç başarıyla kaydedildi! 🚀')),
            );
            Navigator.pop(context);
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Kaydedilemedi: $e")));
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hata: Oturum açmış bir kullanıcı bulunamadı.'),
          ),
        );
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni İhtiyaç Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'İhtiyaç Başlığı (Örn: Temiz Su)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir başlık girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Açıklama (Örn: 3 koli pet şişe su)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir açıklama girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedUrgency,
                decoration: const InputDecoration(
                  labelText: 'Aciliyet Durumu',
                  border: OutlineInputBorder(),
                ),
                items: _urgencies.map((urgency) {
                  return DropdownMenuItem(value: urgency, child: Text(urgency));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedUrgency = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Kaydet ve Gönder',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
