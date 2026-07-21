import 'dart:math' as math;
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/assembly_area.dart';
import '../../domain/cluster_model.dart';
import 'assembly_areas_provider.dart';
import 'map_zoom_provider.dart';
import 'map_bounds_provider.dart';

/// Clustering sonucu: hâlâ toplu olanlar (cluster) + çözülmüş olanlar (poligon).
class ClusteringResult {
  final List<ClusterModel> clusters;
  final List<AssemblyArea> polygons;
  const ClusteringResult(this.clusters, this.polygons);
}

/// Ekrandaki toplanma alanlarını zoom'a göre grid ile gruplar:
/// aynı hücrede birden fazla alan → cluster; tek alan → poligon.
/// Sadece viewport'takiler işlenir → 9063 alanla bile hızlı ve az çizim.
final clusteringProvider = Provider<ClusteringResult>((ref) {
  final areas = ref.watch(assemblyAreasProvider).valueOrNull;
  final zoom = ref.watch(mapZoomProvider);
  final bounds = ref.watch(mapBoundsProvider);
  if (areas == null || bounds == null) {
    return const ClusteringResult([], []);
  }

  // 1) Sadece görünür alandakiler
  final inView = <AssemblyArea>[];
  for (final a in areas) {
    if (bounds.contains(a.center)) inView.add(a);
  }

  // 2) Grid hücre boyutu (derece) — zoom arttıkça küçülür, cluster'lar bölünür
  final cellDeg = 0.08 / math.pow(2, zoom - 11);

  // 3) Alanları hücrelere dağıt
  final cells = <String, List<AssemblyArea>>{};
  for (final a in inView) {
    final gx = (a.center.longitude / cellDeg).floor();
    final gy = (a.center.latitude / cellDeg).floor();
    (cells['$gx:$gy'] ??= <AssemblyArea>[]).add(a);
  }

  // 4) Tek alan → poligon; çok alan → cluster
  final clusters = <ClusterModel>[];
  final polygons = <AssemblyArea>[];
  for (final group in cells.values) {
    if (group.length == 1) {
      polygons.add(group.first);
    } else {
      double lat = 0, lng = 0;
      for (final a in group) {
        lat += a.center.latitude;
        lng += a.center.longitude;
      }
      final n = group.length;
      clusters.add(
        ClusterModel(
          center: LatLng(lat / n, lng / n),
          count: n,
          points: [for (final a in group) a.center],
        ),
      );
    }
  }
  return ClusteringResult(clusters, polygons);
});
