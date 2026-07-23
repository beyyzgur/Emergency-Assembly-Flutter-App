import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/offline_storage_service.dart';
import '../../auth/data/needs_repository.dart';
import '../domain/need_model.dart';

class AddNeedScreen extends ConsumerStatefulWidget {
  // Düzenleme işlemi için opsiyonel model eklendi
  final NeedModel? existingNeed;

  const AddNeedScreen({super.key, this.existingNeed});

  @override
  ConsumerState<AddNeedScreen> createState() => _AddNeedScreenState();
}

class _AddNeedScreenState extends ConsumerState<AddNeedScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _peopleCountController;

  late String _selectedCategory;
  late String _selectedUrgency;
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
  void initState() {
    super.initState();
    // Eğer düzenleme yapılıyorsa (existingNeed varsa) verileri doldur, yoksa boş başlat
    final need = widget.existingNeed;
    _titleController = TextEditingController(text: need?.title ?? '');
    _descController = TextEditingController(text: need?.description ?? '');
    _peopleCountController = TextEditingController(
      text: need?.peopleCount.toString() ?? '',
    );
    _selectedCategory = need != null && _categories.contains(need.category)
        ? need.category
        : 'Su';
    _selectedUrgency = need != null && _urgencies.contains(need.urgency)
        ? need.urgency
        : 'Orta';
  }

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
      final double lat = widget.existingNeed?.latitude ?? 39.92077;
      final double lng = widget.existingNeed?.longitude ?? 32.85411;
      final int peopleCount = int.tryParse(_peopleCountController.text) ?? 1;
      final bool isEditing = widget.existingNeed != null;

      final currentNeed = NeedModel(
        id: isEditing ? widget.existingNeed!.id : '',
        title: _titleController.text,
        description: _descController.text,
        category: _selectedCategory,
        latitude: lat,
        longitude: lng,
        urgency: _selectedUrgency,
        peopleCount: peopleCount,
        createdAt: isEditing ? widget.existingNeed!.createdAt : DateTime.now(),
        reporterId: isEditing
            ? widget.existingNeed!.reporterId
            : currentUser.uid,
      );

      try {
        if (isEditing) {
          await ref.read(needsRepositoryProvider).updateNeed(currentNeed);
        } else {
          // Yeni ekleme (Insert) işlemi
          await ref
              .read(needsRepositoryProvider)
              .addNeed(currentNeed)
              .timeout(const Duration(seconds: 3));
        }

        if (mounted) {
          _showSnackBar(
            isEditing
                ? 'Talebiniz başarıyla güncellendi! ✏️'
                : 'İhtiyaç talebi başarıyla iletildi! 🚀',
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (!isEditing) {
          // Sadece yeni kayıtlarda offline yedek alınıyor
          await ref.read(offlineStorageProvider).saveNeed(currentNeed);
          if (mounted) {
            _showSnackBar('İnternet yok! Kayıt cihaza alındı. 📡', duration: 4);
            Navigator.pop(context);
          }
        } else {
          if (mounted) {
            _showSnackBar(
              'Güncelleme için internet bağlantısı gerekiyor.',
              isError: true,
            );
          }
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

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
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
    final isEditing = widget.existingNeed != null;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Talebi Düzenle' : 'Yeni İhtiyaç Talebi',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _dismissKeyboard,
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
                                initialValue: _selectedCategory,
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
                          initialValue: _selectedUrgency,
                          decoration: _customInputDecoration(
                            'Aciliyet Durumu',
                            Icons.warning_amber_rounded,
                          ),
                          items: _urgencies
                              .map(
                                (u) =>
                                    DropdownMenuItem(value: u, child: Text(u)),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedUrgency = v!),
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
                      : Icon(
                          isEditing ? Icons.save_rounded : Icons.send_rounded,
                          size: 24,
                        ),
                  label: Text(
                    _isLoading
                        ? 'Kaydediliyor...'
                        : (isEditing ? 'Değişiklikleri Kaydet' : 'Talebi İlet'),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
