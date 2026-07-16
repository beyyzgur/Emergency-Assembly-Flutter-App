import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/assembly_point_repository.dart';
import '../../data/models/assembly_point_model.dart';

final assemblyPointsProvider = FutureProvider<List<AssemblyPointModel>>((
  ref,
) async {
  final repository = ref.read(assemblyPointRepositoryProvider);

  return repository.getAssemblyPoints();
});
