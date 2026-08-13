import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'core/theme/co_star_theme.dart';
import 'core/router/app_router.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/home/screens/you_screen.dart';
import 'features/birth_chart/screens/chart_screen.dart';
import 'features/friends/screens/friends_screen.dart';
import 'features/profile/screens/profile_screen.dart';

void main() {
  runApp(const ProviderScope(child: CoStarApp()));
}

class CoStarApp extends ConsumerWidget {
  const CoStarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userBirthProfileProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Astro',
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

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: colors.bg,
      body: Row(
        children: [
          if (isDesktop)
            Container(
              width: 240,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: colors.border, width: 1)),
                color: colors.bg,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'ASTRO',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _desktopNavItem(context, ref, 0, 'YOU', LucideIcons.sparkles, currentTab),
                  _desktopNavItem(context, ref, 1, 'CHART', LucideIcons.compass, currentTab),
                  _desktopNavItem(context, ref, 2, 'FRIENDS', LucideIcons.users, currentTab),
                  _desktopNavItem(context, ref, 3, 'PROFILE', LucideIcons.user, currentTab),
                ],
              ),
            ),
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SafeArea(
                  child: IndexedStack(
                    index: currentTab,
                    children: screens,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : Container(
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

  Widget _desktopNavItem(BuildContext context, WidgetRef ref, int index, String label, IconData icon, int currentTab) {
    final colors = CoStarColors.of(context);
    final isSelected = currentTab == index;
    return InkWell(
      onTap: () => ref.read(currentTabProvider.notifier).state = index,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.cardBg : Colors.transparent,
          border: Border.all(color: isSelected ? colors.border : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? colors.textPrimary : colors.textMuted),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? colors.textPrimary : colors.textMuted,
              ),
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
