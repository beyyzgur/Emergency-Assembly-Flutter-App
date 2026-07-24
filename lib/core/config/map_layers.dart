import 'package:flutter/material.dart';

enum MapLayerType { roadmap, satellite, hybrid, osm }

class MapLayer {
  final MapLayerType type;
  final String url;
  final IconData icon;
  final bool cacheable;
  const MapLayer(this.type, this.url, this.icon, this.cacheable);
}

const List<MapLayer> kMapLayers = [
  MapLayer(
    MapLayerType.roadmap,
    'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
    Icons.map_outlined,
    false,
  ),
  MapLayer(
    MapLayerType.satellite,
    'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
    Icons.satellite_alt_outlined,
    false,
  ),
  MapLayer(
    MapLayerType.hybrid,
    'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
    Icons.layers_outlined,
    false,
  ),
  MapLayer(
    MapLayerType.osm,
    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    Icons.public,
    true,
  ),
];
