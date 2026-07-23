import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/l10n.dart';
import '../../auth/data/auth_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _sectionTitle(context.l10n.profile),
          ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              user?.displayName ?? context.l10n.user,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Text(user?.email ?? ''),
          ),
          const Divider(),

          _sectionTitle(context.l10n.application),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.primary),
            title: Text(context.l10n.appFullName),
            subtitle: Text(context.l10n.version('1.0.0')),
          ),
          const Divider(),

          _sectionTitle(context.l10n.security),
          ListTile(
            leading: const Icon(
              Icons.health_and_safety_outlined,
              color: AppColors.primary,
            ),
            title: Text(context.l10n.statusCheck),
            subtitle: Text(context.l10n.startTenMinuteCheckIn),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/checkin'),
          ),
          const Divider(),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade700),
            title: Text(
              context.l10n.signOut,
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
