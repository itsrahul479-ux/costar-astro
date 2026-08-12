import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/co_star_theme.dart';
import '../../../core/services/api_client.dart';

class TarotCard {
  final String name;
  final String arcana;
  final String meaningUpright;
  final String iconSymbol;
  final String keyword;

  const TarotCard({
    required this.name,
    required this.arcana,
    required this.meaningUpright,
    required this.iconSymbol,
    required this.keyword,
  });
}

const List<TarotCard> _sampleDeck = [
  TarotCard(
    name: "The Fool",
    arcana: "Major Arcana 0",
    meaningUpright: "New beginnings, innocence, spontaneity, a leap of faith.",
    iconSymbol: "✨",
    keyword: "Beginnings",
  ),
  TarotCard(
    name: "The High Priestess",
    arcana: "Major Arcana II",
    meaningUpright: "Intuition, sacred knowledge, divine feminine, the subconscious mind.",
    iconSymbol: "🌙",
    keyword: "Intuition",
  ),
  TarotCard(
    name: "The Empress",
    arcana: "Major Arcana III",
    meaningUpright: "Femininity, beauty, nature, nurturing, abundance.",
    iconSymbol: "🌿",
    keyword: "Abundance",
  ),
  TarotCard(
    name: "The Lovers",
    arcana: "Major Arcana VI",
    meaningUpright: "Love, harmony, relationships, values alignment, choices.",
    iconSymbol: "❤️",
    keyword: "Harmony",
  ),
  TarotCard(
    name: "The Star",
    arcana: "Major Arcana XVII",
    meaningUpright: "Hope, faith, purpose, renewal, spirituality.",
    iconSymbol: "⭐",
    keyword: "Hope",
  ),
  TarotCard(
    name: "The Moon",
    arcana: "Major Arcana XVIII",
    meaningUpright: "Illusion, fear, anxiety, subconscious, intuition.",
    iconSymbol: "🔮",
    keyword: "Mystical",
  ),
  TarotCard(
    name: "The Sun",
    arcana: "Major Arcana XIX",
    meaningUpright: "Positivity, fun, warmth, success, vitality.",
    iconSymbol: "☀️",
    keyword: "Vitality",
  ),
  TarotCard(
    name: "Wheel of Fortune",
    arcana: "Major Arcana X",
    meaningUpright: "Good luck, karma, life cycles, destiny, a turning point.",
    iconSymbol: "☸️",
    keyword: "Destiny",
  ),
];

class TarotScreen extends ConsumerStatefulWidget {
  const TarotScreen({super.key});

  @override
  ConsumerState<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends ConsumerState<TarotScreen> {
  final List<TarotCard> _drawnCards = [];
  bool _isFlipped = false;
  bool _isLoadingAi = false;
  String? _aiReading;

  void _drawCards() {
    setState(() {
      final deck = List<TarotCard>.from(_sampleDeck)..shuffle();
      _drawnCards.clear();
      _drawnCards.addAll(deck.take(3));
      _isFlipped = true;
      _aiReading = null;
    });
    _fetchAiReading();
  }

  Future<void> _fetchAiReading() async {
    if (_drawnCards.length < 3) return;
    setState(() {
      _isLoadingAi = true;
    });

    final cardNames = _drawnCards.map((c) => c.name).join(", ");
    final res = await ApiClient().post('/content/tarot-reading', {
      'cards': cardNames,
    });

    if (mounted) {
      setState(() {
        _isLoadingAi = false;
        if (res != null && res['success'] == true && res['data'] != null) {
          _aiReading = res['data']['reading'] as String?;
        } else {
          _aiReading =
              "Past: ${_drawnCards[0].name} (${_drawnCards[0].keyword})\n"
              "Present: ${_drawnCards[1].name} (${_drawnCards[1].keyword})\n"
              "Future: ${_drawnCards[2].name} (${_drawnCards[2].keyword})\n\n"
              "Trust your inner guidance as these archetype energies unfold in your path.";
        }
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
          '3-CARD TAROT',
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'PAST • PRESENT • FUTURE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            if (!_isFlipped) ...[
              Container(
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(16),
                  color: colors.surface,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.sparkles, size: 48, color: colors.textSecondary),
                      const SizedBox(height: 16),
                      Text(
                        'Tap below to draw 3 cards',
                        style: TextStyle(color: colors.textPrimary, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _drawCards,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.textPrimary,
                  foregroundColor: colors.background,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'DRAW CARDS',
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  final card = _drawnCards[index];
                  final label = index == 0 ? 'PAST' : (index == 1 ? 'PRESENT' : 'FUTURE');

                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 4,
                        right: index == 2 ? 0 : 4,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.border),
                        borderRadius: BorderRadius.circular(12),
                        color: colors.surface,
                      ),
                      child: Column(
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            card.iconSymbol,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            card.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            card.keyword,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(12),
                  color: colors.surface,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.sparkles, size: 18, color: colors.textPrimary),
                        const SizedBox(width: 8),
                        Text(
                          'COSMIC INTERPRETATION',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    if (_isLoadingAi)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      Text(
                        _aiReading ?? 'Drawing cards...',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: _drawCards,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'DRAW AGAIN',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
