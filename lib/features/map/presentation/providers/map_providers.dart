import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../data/api_service.dart';
import '../../data/models/gathering_polygon.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final allPolygonsProvider = FutureProvider<List<GatheringPolygon>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.fetchPolygons();
});

final mapBoundsProvider = StateProvider<LatLngBounds?>((ref) => null);

final currentZoomProvider = StateProvider<double>((ref) => 10.0);

final visiblePolygonsProvider = Provider<List<GatheringPolygon>>((ref) {
  final allPolygonsAsync = ref.watch(allPolygonsProvider);
  final bounds = ref.watch(mapBoundsProvider);

  return allPolygonsAsync.maybeWhen(
    data: (polygons) {
      if (bounds == null) return polygons;

      return polygons.where((polygon) {
        return bounds.contains(polygon.centroid);
      }).toList();
    },
    orElse: () => [],
  );
});
