import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RoutePhase { idle, directions, navigating }

final routePhaseProvider = StateProvider<RoutePhase>((ref) => RoutePhase.idle);
