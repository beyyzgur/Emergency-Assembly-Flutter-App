import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/offline_storage_service.dart';
import '../../auth/data/needs_repository.dart';
import '../domain/need_model.dart';
import '../../../l10n/l10n.dart';

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
      _showSnackBar(context.l10n.noSignedInUser, isError: true);
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
            isEditing ? context.l10n.needUpdated : context.l10n.needSubmitted,
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (!isEditing) {
          // Sadece yeni kayıtlarda offline yedek alınıyor
          await ref.read(offlineStorageProvider).saveNeed(currentNeed);
          if (mounted) {
            _showSnackBar(context.l10n.offlineNeedSaved, duration: 4);
            Navigator.pop(context);
          }
        } else {
          if (mounted) {
            _showSnackBar(context.l10n.updateRequiresInternet, isError: true);
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

  String _categoryLabel(BuildContext context, String category) {
    switch (category) {
      case 'Su':
        return context.l10n.categoryWater;
      case 'Erzak':
        return context.l10n.categoryFood;
      case 'Barınma':
        return context.l10n.categoryShelter;
      case 'Sağlık':
        return context.l10n.categoryHealth;
      default:
        return context.l10n.categoryOther;
    }
  }

  String _urgencyLabel(BuildContext context, String urgency) {
    switch (urgency) {
      case 'Düşük':
        return context.l10n.urgencyLow;
      case 'Orta':
        return context.l10n.urgencyMedium;
      case 'Yüksek':
        return context.l10n.urgencyHigh;
      default:
        return context.l10n.urgencyCritical;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingNeed != null;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          isEditing
              ? context.l10n.editNeedRequest
              : context.l10n.newNeedRequest,
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
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  context.l10n.basicInformation,
                  style: const TextStyle(
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
                          context.l10n.needTitle,
                          Icons.title,
                        ),
                        validator: (v) =>
                            v!.isEmpty ? context.l10n.needTitleRequired : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: _customInputDecoration(
                          context.l10n.detailedDescription,
                          Icons.description,
                        ),
                        validator: (v) => v!.isEmpty
                            ? context.l10n.needDescriptionRequired
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  context.l10n.scopeAndUrgency,
                  style: const TextStyle(
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
                                context.l10n.category,
                                Icons.category,
                              ),
                              items: _categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(_categoryLabel(context, c)),
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
                                context.l10n.peopleCount,
                                Icons.groups,
                              ),
                              validator: (v) => v!.isEmpty
                                  ? context.l10n.peopleCountRequired
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedUrgency,
                        decoration: _customInputDecoration(
                          context.l10n.urgencyStatus,
                          Icons.warning_amber_rounded,
                        ),
                        items: _urgencies
                            .map(
                              (u) => DropdownMenuItem(
                                value: u,
                                child: Text(_urgencyLabel(context, u)),
                              ),
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
                    : Icon(
                        isEditing ? Icons.save_rounded : Icons.send_rounded,
                        size: 24,
                      ),
                label: Text(
                  _isLoading
                      ? context.l10n.saving
                      : (isEditing
                            ? context.l10n.saveChanges
                            : context.l10n.submitNeed),
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
    );
  }
}
