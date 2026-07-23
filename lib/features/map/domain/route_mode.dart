/// Rota hesabında kullanılacak ulaşım profili.
///
/// Arayüz bu değeri `routeProvider`a iletir. Varsayılan profil [walking]'dir;
/// böylece kullanıcı ayrıca seçim yapmadığında rota yaya yollarına göre alınır.
enum RouteMode { walking, driving }

extension RouteModeText on RouteMode {
  String get label => switch (this) {
    RouteMode.walking => 'Yürüyüş',
    RouteMode.driving => 'Araç',
  };
}
