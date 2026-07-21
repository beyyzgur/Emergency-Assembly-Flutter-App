import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/map_layers.dart';

final mapLayerProvider = StateProvider<MapLayer>((ref) => kMapLayers.first);
