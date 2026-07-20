import 'package:emergency_assembly_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'routing/app_router.dart';

Future<void> main() async {
  // Flutter motorunun tam olarak başlatıldığından emin oluyoruz
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i güncel platform ayarlarına göre başlatıyoruz
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Riverpod'u tüm uygulamaya sarmalayarak çalıştırıyoruz
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      // 1. DİNAMİK BAŞLIK: İşletim sistemi menülerinde uygulamanın adını sözlükten okur.
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      routerConfig: router,

      // 2. KURUMSAL TEMA: Afet koordinasyon uygulamasına uygun temiz bir UI iskeleti.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors
              .red
              .shade700, // Afet / Acil durum konseptine uygun ana renk
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),

      // 3. DİL DESTEĞİ DELEGELERİ
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr')],
    );
  }
}
