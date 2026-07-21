import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api_service.dart';
import '../../data/models/gathering_polygon.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final visiblePolygonsProvider = FutureProvider<List<GatheringPolygon>>((
  ref,
) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.fetchPolygons();
});
