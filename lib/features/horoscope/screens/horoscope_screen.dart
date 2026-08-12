import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/co_star_theme.dart';
import '../../../core/services/api_client.dart';

class HoroscopeScreen extends ConsumerStatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  ConsumerState<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends ConsumerState<HoroscopeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _weeklyHoroscope;
  String? _monthlyHoroscope;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchHoroscopes();
  }

  Future<void> _fetchHoroscopes() async {
    setState(() {
      _isLoading = true;
    });

    final weeklyRes = await ApiClient().get('/content/weekly');
    final monthlyRes = await ApiClient().get('/content/monthly');

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (weeklyRes != null && weeklyRes['success'] == true && weeklyRes['data'] != null) {
          _weeklyHoroscope = weeklyRes['data']['reading'] as String?;
        }
        if (monthlyRes != null && monthlyRes['success'] == true && monthlyRes['data'] != null) {
          _monthlyHoroscope = monthlyRes['data']['reading'] as String?;
        }

        _weeklyHoroscope ??= "This week, focus on internal alignment before making major career moves. Mercury's transit supports quiet contemplation over hasty announcements.";
        _monthlyHoroscope ??= "This month presents a major shift in your relational dynamics. Solar alignment encourages deep vulnerability and stripping away superficial facades.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = CoStarColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          'EXTENDED FORECAST',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colors.textPrimary,
          labelColor: colors.textPrimary,
          unselectedLabelColor: colors.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12),
          tabs: const [
            Tab(text: 'WEEKLY'),
            Tab(text: 'MONTHLY'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildForecastView(
                  title: "WEEKLY INSIGHT",
                  subtitle: "Current Solar Cycle",
                  text: _weeklyHoroscope!,
                  colors: colors,
                ),
                _buildForecastView(
                  title: "MONTHLY LUNATION",
                  subtitle: "30-Day Transits",
                  text: _monthlyHoroscope!,
                  colors: colors,
                ),
              ],
            ),
    );
  }

  Widget _buildForecastView({
    required String title,
    required String subtitle,
    required String text,
    required CoStarColors colors,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(16),
              color: colors.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.calendar, size: 18, color: colors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      subtitle.toUpperCase(),
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const Divider(height: 32),
                Text(
                  text,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
