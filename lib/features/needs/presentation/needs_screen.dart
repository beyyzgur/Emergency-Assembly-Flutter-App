import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'add_need_screen.dart';
import '../../auth/data/auth_service.dart';

class NeedsScreen extends ConsumerWidget {
  const NeedsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İhtiyaçlar Listesi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddNeedScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menü',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Genel Harita'),
              onTap: () {
                Navigator.pop(context);
                context.go('/map');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('İhtiyaç Kayıtları'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await ref.read(authServiceProvider).signOut();
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.water_drop)),
              title: Text("İhtiyaç Başlığı ${index + 1}"),
              subtitle: const Text(
                "Burası ihtiyacın detaylı açıklaması olacak. Konum ve aciliyet durumu da eklenebilir.",
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: İhtiyaç Detay Ekranına Yönlendir
              },
            ),
          );
        },
      ),
    );
  }
}
