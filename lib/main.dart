import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/locale/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/splash_overlay.dart';
import 'l10n/l10n.dart';
import 'routing/app_router.dart';
import 'features/map/presentation/providers/assembly_areas_provider.dart';

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _splashDone = false;
  bool _showIndicator = false;
  bool _nativeSplashRemoved = false;
  bool _precacheStarted = false;
  bool _splashImageReady = false;
  DateTime? _overlayShownAt;
  Timer? _indicatorTimer;
  Timer? _safety;
  Timer? _nativeFallback;
  Timer? _minVisibleTimer;

  static const Duration _minOverlayVisible = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _indicatorTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showIndicator = true);
    });
    _safety = Timer(const Duration(seconds: 20), _forceFinishSplash);
    _nativeFallback = Timer(const Duration(seconds: 3), _removeNativeSplash);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precacheStarted) return;
    _precacheStarted = true;
    precacheImage(
      const AssetImage('assets/branding/splash.png'),
      context,
    ).whenComplete(() {
      if (!mounted) {
        _removeNativeSplash();
        return;
      }
      setState(() => _splashImageReady = true);
    });
  }

  void _removeNativeSplash() {
    if (_nativeSplashRemoved) return;
    _nativeSplashRemoved = true;
    _overlayShownAt = DateTime.now();
    FlutterNativeSplash.remove();
  }

  void _forceFinishSplash() {
    if (!mounted || _splashDone) return;
    _removeNativeSplash();
    setState(() => _splashDone = true);
  }

  void _finishSplash() {
    if (!mounted || _splashDone) return;
    final shownAt = _overlayShownAt;
    if (!_nativeSplashRemoved || shownAt == null) return;
    final visible = DateTime.now().difference(shownAt);
    if (visible < _minOverlayVisible) {
      _minVisibleTimer?.cancel();
      _minVisibleTimer = Timer(_minOverlayVisible - visible, _finishSplash);
      return;
    }
    setState(() => _splashDone = true);
  }

  @override
  void dispose() {
    _indicatorTimer?.cancel();
    _safety?.cancel();
    _nativeFallback?.cancel();
    _minVisibleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);

    if (!_splashDone) {
      if (_splashImageReady && !_nativeSplashRemoved) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _removeNativeSplash(),
        );
      }
      final ready =
          !ref.watch(assemblyAreasProvider).isLoading &&
          !ref.watch(authStateProvider).isLoading;
      if (ready) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _finishSplash());
      }
    }

    return MaterialApp.router(
      title: 'ATİS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: ref.watch(localeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) => Stack(
        children: [
          ?child,
          if (!_splashDone)
            Positioned.fill(
              key: const ValueKey('splash-overlay'),
              child: SplashOverlay(showIndicator: _showIndicator),
            ),
        ],
      ),
    );
  }
}
