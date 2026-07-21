import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/assembly_geojson.dart';
import '../../domain/assembly_area.dart';

/// Tüm toplanma alanları — GeoJSON asset'inden bir kez yüklenir, cache'lenir.
/// Parse arka isolate'te (compute) yapılır ki ana thread donmasın.
final assemblyAreasProvider = FutureProvider<List<AssemblyArea>>((ref) async {
  final raw = await rootBundle.loadString(
    'assets/geo/toplanma_alanlari.geojson',
  );
  return compute(parseAssemblyGeoJson, raw);
});
