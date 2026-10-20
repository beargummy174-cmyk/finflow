import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/views/main_nav_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase secara aman (graceful fallback ke mode demo jika belum ada google-services.json)
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase berhasil diinisialisasi.');
  } catch (e) {
    debugPrint('Firebase belum terkonfigurasi atau berjalan dalam Mode Demo Offline: $e');
  }

  runApp(
    const ProviderScope(
      child: FinFlowApp(),
    ),
  );
}

class FinFlowApp extends StatelessWidget {
  const FinFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavScreen(),
    );
  }
}
