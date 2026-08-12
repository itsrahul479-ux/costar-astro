import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/co_star_theme.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _entries = [];
  int _selectedMood = 2; // 0..4

  final List<String> _moods = ['🌧️ Low', '☁️ Heavy', '⚡ Neutral', '✨ Inspired', '🔥 Empowered'];

  @override
  void initState() {
    super.initState();
    _loadJournal();
  }

  Future<void> _loadJournal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _entries.addAll(prefs.getStringList('user_journal_entries') ?? []);
    });
  }

  Future<void> _saveEntry() async {
    if (_controller.text.trim().isEmpty) return;

    final timestamp = DateTime.now().toString().substring(0, 10);
    final moodEmoji = _moods[_selectedMood];
    final fullEntry = "[$timestamp - $moodEmoji]\n${_controller.text.trim()}";

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _entries.insert(0, fullEntry);
      _controller.clear();
    });
    await prefs.setStringList('user_journal_entries', _entries);
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
          'ASTRO JOURNAL & MOOD',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mood selector
            Text(
              'DAILY MOOD CHECK-IN',
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_moods.length, (index) {
                  final isSelected = _selectedMood == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(_moods[index]),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedMood = index);
                      },
                      selectedColor: colors.textPrimary,
                      backgroundColor: colors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? colors.background : colors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: colors.border),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            // Entry Textfield
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(12),
                color: colors.surface,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 4,
                    style: TextStyle(color: colors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Reflect on your transits and thoughts today...',
                      hintStyle: TextStyle(color: colors.textSecondary, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _saveEntry,
                      icon: const Icon(LucideIcons.penTool, size: 16),
                      label: const Text('SAVE REFLECTION'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.textPrimary,
                        foregroundColor: colors.background,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'PREVIOUS ENTRIES',
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            if (_entries.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'No journal reflections saved yet.',
                    style: TextStyle(color: colors.textSecondary, fontSize: 14),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  final parts = entry.split('\n');
                  final header = parts.first;
                  final body = parts.skip(1).join('\n');

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.border),
                      borderRadius: BorderRadius.circular(12),
                      color: colors.surface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          header,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          body,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
