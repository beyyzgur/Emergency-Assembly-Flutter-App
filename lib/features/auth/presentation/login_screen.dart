import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş Yap")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await ref.read(authServiceProvider).signInWithGoogle();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Bir hata oluştu: ${e.toString()}")),
                );
              }
            }
          },
          child: const Text("Google ile Giriş Yap"),
        ),
      ),
    );
  }
}
