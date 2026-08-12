import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/astrology_models.dart';
import '../../core/services/astrology_engine.dart';
import '../../core/services/daily_insights_service.dart';

// Theme Mode Provider (Default: Light Mode)
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// User State Providers
final userBirthProfileProvider = StateProvider<BirthProfile?>((ref) => null);

final userNatalChartProvider = Provider<NatalChart?>((ref) {
  final profile = ref.watch(userBirthProfileProvider);
  if (profile == null) return null;
  return AstrologyEngine.calculateNatalChart(profile);
});

final dailyInsightProvider = Provider<DailyInsight?>((ref) {
  final chart = ref.watch(userNatalChartProvider);
  if (chart == null) return null;
  return DailyInsightsService.generateDailyInsight(chart);
});

final friendsProvider = StateNotifierProvider<FriendsNotifier, List<Friend>>((ref) {
  return FriendsNotifier();
});

class FriendsNotifier extends StateNotifier<List<Friend>> {
  FriendsNotifier() : super(_initialFriends());

  static List<Friend> _initialFriends() {
    final defaultProfile = const BirthProfile(
      name: 'Emma',
      birthDate: '1997-07-28',
      birthTime: '15:20',
      isTimeUnknown: false,
      birthCity: 'London',
      birthCountry: 'UK',
      latitude: 51.5074,
      longitude: -0.1278,
      timezone: 'Europe/London',
    );
    final friendChart = AstrologyEngine.calculateNatalChart(defaultProfile);

    return [
      Friend(
        id: 'f1',
        name: 'Emma',
        username: '@emma_leo',
        sunSign: ZodiacSign.leo,
        moonSign: ZodiacSign.scorpio,
        risingSign: ZodiacSign.gemini,
        birthProfile: defaultProfile,
        chart: friendChart,
      ),
      Friend(
        id: 'f2',
        name: 'Alex',
        username: '@alex_aqua',
        sunSign: ZodiacSign.aquarius,
        moonSign: ZodiacSign.libra,
        risingSign: ZodiacSign.aries,
        birthProfile: defaultProfile,
        chart: friendChart,
      ),
      Friend(
        id: 'f3',
        name: 'Sarah',
        username: '@sarah_pisces',
        sunSign: ZodiacSign.pisces,
        moonSign: ZodiacSign.taurus,
        risingSign: ZodiacSign.cancer,
        birthProfile: defaultProfile,
        chart: friendChart,
      ),
    ];
  }

  void addFriend(Friend friend) {
    state = [...state, friend];
  }
}

final currentTabProvider = StateProvider<int>((ref) => 0);
