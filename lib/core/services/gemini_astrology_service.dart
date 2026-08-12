import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/models/astrology_models.dart';

class GeminiAstrologyService {
  final String apiKey;
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  GeminiAstrologyService({this.apiKey = ''});

  /// Generate personalized daily readings using Gemini AI
  Future<String> generateDailyReading({
    required NatalChart chart,
    required String theme, // e.g. "Self", "Social", "Work"
  }) async {
    if (apiKey.isEmpty) {
      return _fallbackDailyReading(chart, theme);
    }

    final prompt = '''
You are the AI Astrologer for Co-Star Astrology.
Write a short, stark, poetic, and direct daily reading for a user with the following natal chart:
- Sun Sign: ${chart.sunSign.displayName} (${chart.sunSign.element})
- Moon Sign: ${chart.moonSign.displayName} (${chart.moonSign.element})
- Rising Sign: ${chart.risingSign.displayName}

Theme: $theme
Format: 2-3 sentences. Tone: Monochromatic, existential, precise, editorial (Co-Star style).
Do not use generic fluff or emojis.
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 200,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (text != null && text.toString().trim().isNotEmpty) {
          return text.toString().trim();
        }
      }
    } catch (_) {
      // Fallback on network or API failure
    }

    return _fallbackDailyReading(chart, theme);
  }

  /// Ask the Stars AI Astrologer Q&A
  Future<String> askAstrologer({
    required NatalChart chart,
    required String userQuestion,
  }) async {
    if (apiKey.isEmpty) {
      return _fallbackAskAstrologer(chart, userQuestion);
    }

    final prompt = '''
User Natal Chart:
- Sun: ${chart.sunSign.displayName}
- Moon: ${chart.moonSign.displayName}
- Rising: ${chart.risingSign.displayName}

User Question: "$userQuestion"

Answer as the Co-Star AI Astrologer. Be perceptive, psychological, stark, and direct. Keep response under 100 words.
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.8,
            'maxOutputTokens': 250,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (text != null && text.toString().trim().isNotEmpty) {
          return text.toString().trim();
        }
      }
    } catch (_) {}

    return _fallbackAskAstrologer(chart, userQuestion);
  }

  String _fallbackDailyReading(NatalChart chart, String theme) {
    switch (theme.toLowerCase()) {
      case 'self':
        return 'Your ${chart.sunSign.displayName} Sun and ${chart.moonSign.displayName} Moon demand truth over comfort today. Stop performing balance and acknowledge what you actually feel.';
      case 'social':
        return 'Connection requires vulnerability, not control. Let your ${chart.risingSign.displayName} Ascendant drop its shield for a moment.';
      case 'work':
        return 'Precision is your greatest asset right now. Align your daily rituals with your long-term vision before acting.';
      default:
        return 'The transits today urge you to listen carefully to what you usually ignore.';
    }
  }

  String _fallbackAskAstrologer(NatalChart chart, String question) {
    return 'Your ${chart.sunSign.displayName} Sun and ${chart.moonSign.displayName} Moon suggest that "$question" is less about external circumstances and more about your internal boundaries. Take time to reflect on what you are protecting.';
  }
}
