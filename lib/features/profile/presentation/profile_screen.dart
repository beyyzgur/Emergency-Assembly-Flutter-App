import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/data/auth_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              user?.displayName ?? 'Kullanıcı',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Text(user?.email ?? ''),
          ),
          const Divider(),

          _sectionTitle('Uygulama'),
          const ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.primary),
            title: Text('ATİS — Afet Toplanma Alanı İşaretleme Sistemi'),
            subtitle: Text('Sürüm 1.0.0'),
          ),
          const Divider(),

          _sectionTitle('Güvenlik'),
          ListTile(
            leading: const Icon(
              Icons.health_and_safety_outlined,
              color: AppColors.primary,
            ),
            title: const Text('Durum Bildirimi'),
            subtitle: const Text('10 dakikalık check-in başlat'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/checkin'),
          ),
          const Divider(),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade700),
            title: Text(
              'Çıkış Yap',
              style: TextStyle(color: Colors.red.shade700),
            ),
            onTap: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        letterSpacing: 0.5,
      ),
    ),
  );
}
