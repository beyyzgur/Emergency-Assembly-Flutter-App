import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/assembly_area.dart';
import '../location_providers.dart';
import 'assembly_areas_provider.dart';

/// Bir alan + kullanıcıya olan mesafesi (metre).
typedef NearestArea = ({AssemblyArea area, double meters});

/// Kullanıcı konumuna en yakın toplanma alanları — 5 km içinde, mesafeye göre
/// sıralı, en fazla 30 tane. Konum yoksa boş.
final nearestAreasProvider = Provider<List<NearestArea>>((ref) {
  final loc = ref.watch(effectiveLocationProvider);
  final areas = ref.watch(assemblyAreasProvider).valueOrNull;
  if (loc == null || areas == null) return const [];

  const distance = Distance();
  final list = <NearestArea>[];
  for (final a in areas) {
    final m = distance.as(LengthUnit.Meter, loc, a.center);
    if (m <= 5000) list.add((area: a, meters: m));
  }
  list.sort((x, y) => x.meters.compareTo(y.meters));
  return list.length > 30 ? list.sublist(0, 30) : list;
});
