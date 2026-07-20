import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Giriş Yap',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.security, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'AFAD Koordinasyon Paneli',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 48),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: Colors.blue.shade800,
                  elevation: 0,
                ),
                onPressed: () async {
                  try {
                    await ref.read(authServiceProvider).signInWithGoogle();
                    if (context.mounted) {
                      context.go('/');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Google Giriş Hatası: ${e.toString().split('] ').last}',
                          ),
                          backgroundColor: Colors.red.shade700,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.login),
                label: const Text(
                  'Google ile Giriş Yap',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  try {
                    await ref.read(authServiceProvider).signInWithApple();
                    // Giriş başarılıysa güvenli yönlendirme
                    if (context.mounted) {
                      context.go('/');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Apple ile giriş iptal edildi veya bir hata oluştu.',
                          ),
                          backgroundColor: Colors.orange.shade800,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.apple, size: 24),
                label: const Text(
                  'Apple ile Giriş Yap',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
