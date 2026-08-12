import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';

// ─── Chart State ─────────────────────────────────────────────
class ChartState {
  final bool isLoading;
  final Map<String, dynamic>? chartData;
  final Map<String, dynamic>? dailyReading;
  final String? error;

  const ChartState({
    this.isLoading = false,
    this.chartData,
    this.dailyReading,
    this.error,
  });

  ChartState copyWith({
    bool? isLoading,
    Map<String, dynamic>? chartData,
    Map<String, dynamic>? dailyReading,
    String? error,
  }) {
    return ChartState(
      isLoading: isLoading ?? this.isLoading,
      chartData: chartData ?? this.chartData,
      dailyReading: dailyReading ?? this.dailyReading,
      error: error,
    );
  }

  String get sunSign => (chartData?['planets']?['Sun']?['sign'] as String?) ?? '—';
  String get moonSign => (chartData?['planets']?['Moon']?['sign'] as String?) ?? '—';
  String get risingSign => (chartData?['rising_sign'] as String?) ?? '—';
  String get readingText =>
      (dailyReading?['reading_text'] as String?) ??
      'Your cosmic reading is being prepared...';
}

// ─── Chart Notifier ───────────────────────────────────────────
class ChartNotifier extends StateNotifier<ChartState> {
  final ApiClient _api = ApiClient();

  ChartNotifier() : super(const ChartState());

  /// Fetch natal chart from the backend (uses Redis cache server-side)
  Future<void> fetchChart({required Map<String, dynamic> birthData}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _api.post('/chart', birthData);

    if (result == null || result['success'] != true) {
      // Try legacy endpoint format
      final legacyResult = await _api.post('/insights/chart', birthData);
      if (legacyResult != null && legacyResult['success'] == true) {
        state = state.copyWith(
          isLoading: false,
          chartData: legacyResult['data'] as Map<String, dynamic>?,
        );
        return;
      }
      state = state.copyWith(
        isLoading: false,
        error: result?['error'] ?? 'Could not fetch chart',
      );
      return;
    }

    state = state.copyWith(
      isLoading: false,
      chartData: result['data'] as Map<String, dynamic>?,
    );

    // Auto-fetch daily reading after chart loads
    await fetchDailyReading();
  }

  /// Fetch today's personalized daily reading
  Future<void> fetchDailyReading() async {
    final result = await _api.get('/content/daily');

    if (result != null && result['success'] == true) {
      state = state.copyWith(
        dailyReading: result['data'] as Map<String, dynamic>?,
      );
    }
  }

  /// Check compatibility between two birth dates
  Future<Map<String, dynamic>?> checkCompatibility({
    required String personABirthDate,
    required String personBBirthDate,
  }) async {
    final result = await _api.post('/compatibility/check', {
      'person_a_birth_date': personABirthDate,
      'person_b_birth_date': personBBirthDate,
    });

    if (result != null && result['success'] == true) {
      return result['data'] as Map<String, dynamic>?;
    }
    return null;
  }
}

// ─── Provider ────────────────────────────────────────────────
final chartProvider = StateNotifierProvider<ChartNotifier, ChartState>(
  (ref) => ChartNotifier(),
);

// Convenience providers
final sunSignProvider = Provider<String>((ref) {
  return ref.watch(chartProvider).sunSign;
});

final dailyReadingProvider = Provider<String>((ref) {
  return ref.watch(chartProvider).readingText;
});
