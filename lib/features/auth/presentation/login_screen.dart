import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../data/auth_service.dart';
import 'widgets/auth_brand.dart';

enum _LoginMethod { email, google }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  _LoginMethod? _activeMethod;
  bool _isPasswordVisible = false;

  bool get _isLoading => _activeMethod != null;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _activeMethod = _LoginMethod.email);
    final errorMessage = await ref
        .read(authServiceProvider)
        .signIn(_emailController.text.trim(), _passwordController.text);

    if (!mounted) {
      return;
    }
    setState(() => _activeMethod = null);

    if (errorMessage != null) {
      _showMessage(errorMessage);
      return;
    }

    context.go('/map');
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _activeMethod = _LoginMethod.google);

    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      if (!mounted) {
        return;
      }
      context.go('/map');
    } catch (_) {
      if (mounted) {
        _showMessage('Google ile giriş şu an tamamlanamadı. Tekrar deneyin.');
      }
    } finally {
      if (mounted) {
        setState(() => _activeMethod = null);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _dismissKeyboard,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AuthBrandHeader(),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14243553),
                              blurRadius: 24,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [AppColors.primary, AppColors.accent],
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            const Text(
                              'Güvenli giriş',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Toplanma alanlarına ve ihtiyaç kayıtlarına erişmek için hesabınla devam et.',
                              style: TextStyle(
                                color: Color(0xFF65738A),
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              enabled: !_isLoading,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.username],
                              decoration: _inputDecoration(
                                label: 'E-posta adresi',
                                icon: Icons.mail_outline_rounded,
                              ),
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                if (email.isEmpty) {
                                  return 'E-posta adresinizi girin.';
                                }
                                if (!email.contains('@')) {
                                  return 'Geçerli bir e-posta girin.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              enabled: !_isLoading,
                              obscureText: !_isPasswordVisible,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => _loginWithEmail(),
                              decoration: _inputDecoration(
                                label: 'Şifre',
                                icon: Icons.lock_outline_rounded,
                                suffix: IconButton(
                                  tooltip: _isPasswordVisible
                                      ? 'Şifreyi gizle'
                                      : 'Şifreyi göster',
                                  onPressed: _isLoading
                                      ? null
                                      : () => setState(
                                          () => _isPasswordVisible =
                                              !_isPasswordVisible,
                                        ),
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if ((value ?? '').isEmpty) {
                                  return 'Şifrenizi girin.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: _isLoading ? null : _loginWithEmail,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _activeMethod == _LoginMethod.email
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Text(
                                        'Giriş Yap',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'Henüz hesabın yok mu?',
                                  style: TextStyle(
                                    color: Color(0xFF65738A),
                                    fontSize: 13,
                                  ),
                                ),
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () => context.go('/register'),
                                  child: const Text(
                                    'Kayıt ol',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'veya',
                                    style: TextStyle(color: Color(0xFF8A96A8)),
                                  ),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: _isLoading ? null : _loginWithGoogle,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                    color: Color(0xFFD8E0EB),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: _activeMethod == _LoginMethod.google
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.25,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.g_mobiledata_rounded,
                                        color: Color(0xFF4285F4),
                                        size: 30,
                                      ),
                                label: Text(
                                  _activeMethod == _LoginMethod.google
                                      ? 'Google hesabı açılıyor...'
                                      : 'Google ile devam et',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Acil durumlarda hızlı erişim için bilgilerin güvenle saklanır.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8A96A8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8FAFD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD8E0EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD8E0EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
