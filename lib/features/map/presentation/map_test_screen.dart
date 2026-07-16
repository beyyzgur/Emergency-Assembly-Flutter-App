import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/assembly_points_provider.dart';

class MapTestScreen extends ConsumerWidget {
  const MapTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assemblyPointsAsync = ref.watch(assemblyPointsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Harita Veri Testi')),
      body: assemblyPointsAsync.when(
        data: (points) {
          if (points.isEmpty) {
            return const Center(
              child: Text('Bağlantı başarılı ama liste boş!'),
            );
          }
          return ListView.builder(
            itemCount: points.length,
            itemBuilder: (context, index) {
              final point = points[index];
              return ListTile(
                leading: const Icon(Icons.map, color: Colors.green),
                title: Text(point.name),
                subtitle: Text(
                  'Kapasite: ${point.capacity} | Koordinat Sayısı: ${point.polygonCoordinates.length}',
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('KIRMIZI ALARM: $error')),
      ),
    );
  }
}
