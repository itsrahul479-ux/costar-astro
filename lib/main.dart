import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:device_preview/device_preview.dart';

import 'core/theme/co_star_theme.dart';
import 'core/router/app_router.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/home/screens/you_screen.dart';
import 'features/birth_chart/screens/chart_screen.dart';
import 'features/friends/screens/friends_screen.dart';
import 'features/profile/screens/profile_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const ProviderScope(child: CoStarApp()),
    ),
  );
}

class CoStarApp extends ConsumerWidget {
  const CoStarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userBirthProfileProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Astro',
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: CoStarTheme.lightTheme,
      darkTheme: CoStarTheme.darkTheme,
      themeMode: themeMode,
      home: profile == null ? const OnboardingScreen() : const MainTabShell(),
    );
  }
}

class MainTabShell extends ConsumerWidget {
  const MainTabShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);
    final colors = CoStarColors.of(context);

    final screens = const [
      YouScreen(),
      ChartScreen(),
      FriendsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: IndexedStack(
          index: currentTab,
          children: screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.border, width: 1)),
          color: colors.bg,
        ),
        child: BottomNavigationBar(
          currentIndex: currentTab,
          onTap: (idx) => ref.read(currentTabProvider.notifier).state = idx,
          backgroundColor: colors.bg,
          selectedItemColor: colors.textPrimary,
          unselectedItemColor: colors.textMuted,
          selectedLabelStyle: const TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontFamily: 'monospace', fontSize: 10),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarSpan(
              icon: Icon(LucideIcons.sparkles, size: 18),
              label: 'YOU',
            ),
            BottomNavigationBarSpan(
              icon: Icon(LucideIcons.compass, size: 18),
              label: 'CHART',
            ),
            BottomNavigationBarSpan(
              icon: Icon(LucideIcons.users, size: 18),
              label: 'FRIENDS',
            ),
            BottomNavigationBarSpan(
              icon: Icon(LucideIcons.user, size: 18),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationBarSpan extends BottomNavigationBarItem {
  const BottomNavigationBarSpan({required super.icon, required super.label});
}
