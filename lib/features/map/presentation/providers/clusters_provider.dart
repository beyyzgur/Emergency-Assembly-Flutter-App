import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/cluster_model.dart';
import 'assembly_points_provider.dart';
import 'map_zoom_provider.dart';

/// Zoom'a göre gruplanmış geçici toplanma noktası cluster'ları.
final clustersProvider = Provider<List<ClusterModel>>((ref) {
  final pointsAsync = ref.watch(assemblyPointsProvider);
  final zoom = ref.watch(mapZoomProvider);

  final points = pointsAsync.valueOrNull;
  if (points == null) return [];
  return [
    ClusterModel(center: LatLng(39.93, 32.85), count: 12, points: const []),
    ClusterModel(center: LatLng(39.95, 32.80), count: 5, points: const []),
    ClusterModel(center: LatLng(39.90, 32.90), count: 8, points: const []),
  ];
});
