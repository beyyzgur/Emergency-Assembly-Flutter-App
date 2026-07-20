import 'dart:async'; // TimeoutException için
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// Kullanıcının konumunu veren provider.
/// Position döner (lat/lng + accuracy). accuracy, haritadaki
/// doğruluk çemberi için gerekli — LatLng'de o bilgi yok.
final userLocationProvider = FutureProvider<Position?>((ref) async {
  // 1. Cihazın konum servisi açık mı?
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  // 2. İzin durumu
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null; // izin yok → manuel ilçe seçimine düşer
  }

  // 3. Konumu al
  //    - locationSettings: v14'te desiredAccuracy deprecate oldu, yerine bu
  //    - timeLimit: kapalı alanda GPS fix gelmezse sonsuza kadar beklemesin
  try {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
  } on TimeoutException {
    return null; // 10 sn'de konum gelmezse → manuel seçime düş
  }
});
