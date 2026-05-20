import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
import 'providers/search_provider.dart';
import 'providers/random_provider.dart';
import 'services/wikipedia_service.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.load();
  runApp(HistoryVaultApp(favoritesProvider: favoritesProvider));
}

class HistoryVaultApp extends StatelessWidget {
  const HistoryVaultApp({super.key, required this.favoritesProvider});
  final FavoritesProvider favoritesProvider;

  @override
  Widget build(BuildContext context) {
    final service = WikipediaService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: favoritesProvider),
        ChangeNotifierProvider(create: (_) => HistoryProvider(service)),
        ChangeNotifierProvider(create: (_) => SearchProvider(service)),
        ChangeNotifierProvider(create: (_) => RandomProvider(service)),
      ],
      child: MaterialApp.router(
        title: 'HistoryVault',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF1F2937),
            secondary: const Color(0xFF10B981),
            surface: Colors.white,
            onPrimary: Colors.white,
            onSurface: const Color(0xFF111827),
            onSurfaceVariant: const Color(0xFF6B7280),
            outline: const Color(0xFFE5E7EB),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1F2937),
            elevation: 0,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            titleTextStyle: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          textTheme: TextTheme(
            displayLarge: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
              letterSpacing: -1,
            ),
            headlineMedium: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
              letterSpacing: -0.5,
            ),
            titleLarge: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
            titleMedium: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
              letterSpacing: 0.15,
            ),
            titleSmall: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
            bodyLarge: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF374151),
              height: 1.5,
              letterSpacing: 0.15,
            ),
            bodyMedium: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
            bodySmall: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF9CA3AF),
              height: 1.4,
            ),
            labelLarge: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
              letterSpacing: 0.5,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFF3F4F6), width: 1),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1F2937), width: 2),
            ),
            hintStyle: GoogleFonts.inter(color: const Color(0xFF9CA3AF)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F2937),
              foregroundColor: Colors.white,
              textStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color(0xFF1F2937),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF1F2937),
            unselectedItemColor: const Color(0xFF9CA3AF),
            elevation: 8,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
