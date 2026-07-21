import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Haritanın o anki görünür sınırları (viewport). map_screen günceller;
/// clustering yalnızca ekrandaki alanları işler (9063'ü birden değil).
final mapBoundsProvider = StateProvider<LatLngBounds?>((ref) => null);
