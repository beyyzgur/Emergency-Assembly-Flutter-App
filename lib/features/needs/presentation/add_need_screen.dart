import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/offline_storage_service.dart';
import '../../auth/data/needs_repository.dart';
import '../domain/need_model.dart';
// TODO: Ana dala (main) merge edince bu importu aktif et:
// import '../../map/utils/location_service.dart';

class AddNeedScreen extends ConsumerStatefulWidget {
  const AddNeedScreen({super.key});

  @override
  ConsumerState<AddNeedScreen> createState() => _AddNeedScreenState();
}

class _AddNeedScreenState extends ConsumerState<AddNeedScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _peopleCountController = TextEditingController();

  String _selectedCategory = 'Su';
  String _selectedUrgency = 'Orta';
  bool _isLoading = false;

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
    _peopleCountController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showSnackBar(
        'Hata: Oturum açmış bir kullanıcı bulunamadı.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ŞU ANKİ TEST İÇİN GEÇİCİ SABİT KONUM
      final double lat = 39.92077;
      final double lng = 32.85411;

      // TODO: Ana dala merge edince burayı aktif et:
      // final location = await LocationService.getCurrentLocation();
      // final double lat = location?.latitude ?? 0.0;
      // final double lng = location?.longitude ?? 0.0;

      // Kişi sayısını integer'a çeviriyoruz, boşsa 1 kabul ediyoruz
      final int peopleCount = int.tryParse(_peopleCountController.text) ?? 1;

      final newNeed = NeedModel(
        id: '',
        title: _titleController.text,
        description: _descController.text,
        category: _selectedCategory,
        latitude: lat,
        longitude: lng,
        urgency: _selectedUrgency,
        createdAt: DateTime.now(),
        reporterId: currentUser.uid,
        // TODO: Model dosyasına ve SQLite'a peopleCount eklenecek!
        // peopleCount: peopleCount,
      );

      try {
        await ref
            .read(needsRepositoryProvider)
            .addNeed(newNeed)
            .timeout(const Duration(seconds: 3));
        if (mounted) {
          _showSnackBar('İhtiyaç talebi başarıyla iletildi! 🚀');
          Navigator.pop(context);
        }
      } catch (e) {
        await ref.read(offlineStorageProvider).saveNeed(newNeed);
        if (mounted) {
          _showSnackBar(
            'İnternet yok! Kayıt güvenli bir şekilde cihaza alındı. 📡',
            duration: 4,
          );
          Navigator.pop(context);
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false, int duration = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade800 : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: duration),
      ),
    );
  }

  InputDecoration _customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Yeni İhtiyaç Talebi',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'TEMEL BİLGİLER',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Card(
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: _customInputDecoration(
                          'İhtiyaç Başlığı',
                          Icons.title,
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Lütfen bir başlık girin' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: _customInputDecoration(
                          'Detaylı Açıklama',
                          Icons.description,
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Lütfen bir açıklama girin' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'KAPSAM VE ACİLİYET',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Card(
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: _customInputDecoration(
                                'Kategori',
                                Icons.category,
                              ),
                              items: _categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedCategory = v!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _peopleCountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: _customInputDecoration(
                                'Kişi Sayısı',
                                Icons.groups,
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Boş bırakılamaz' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedUrgency,
                        decoration: _customInputDecoration(
                          'Aciliyet Durumu',
                          Icons.warning_amber_rounded,
                        ),
                        items: _urgencies
                            .map(
                              (u) => DropdownMenuItem(value: u, child: Text(u)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _selectedUrgency = v!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitForm,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 24),
                label: Text(
                  _isLoading ? 'Kaydediliyor...' : 'Talebi İlet',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
