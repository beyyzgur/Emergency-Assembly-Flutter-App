import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/assembly_area.dart';

/// Haritada dokunularak seçilen toplanma alanı (detay kartı bunu gösterir).
/// null → seçim yok, kart gizli.
final selectedAreaProvider = StateProvider<AssemblyArea?>((ref) => null);
