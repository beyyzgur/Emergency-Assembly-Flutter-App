import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// GEÇİCİ — Dev1'in gerçek userLocationProvider'ı gelince bu dosya silinecek.
/// Konum iznini ister; izin varsa Position döndürür (konum + doğruluk), yoksa null.
final userLocationProvider = FutureProvider<Position?>((ref) async {
  // Cihazın konum servisi açık mı?
  if (!await Geolocator.isLocationServiceEnabled()) return null;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null;
  }

  return Geolocator.getCurrentPosition();
});
