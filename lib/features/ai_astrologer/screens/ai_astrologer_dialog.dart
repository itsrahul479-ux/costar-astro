import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../shared/models/astrology_models.dart';

class AiAstrologerDialog extends StatefulWidget {
  final NatalChart chart;
  final String userName;

  const AiAstrologerDialog({super.key, required this.chart, required this.userName});

  @override
  State<AiAstrologerDialog> createState() => _AiAstrologerDialogState();
}

class _AiAstrologerDialogState extends State<AiAstrologerDialog> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _inputCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add({
      'sender': 'astrologer',
      'text': 'Greetings, ${widget.userName}. I have analyzed your birth chart (${widget.chart.sunSign.displayName} Sun, ${widget.chart.moonSign.displayName} Moon, ${widget.chart.risingSign.displayName} Rising). What aspect of your blueprint would you like to explore today?',
    });
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text.trim()});
      _isLoading = true;
    });
    _inputCtrl.clear();

    await Future.delayed(const Duration(milliseconds: 1200));

    String reply = "Astrologically, your blueprint is shaped by your ${widget.chart.sunSign.displayName} Sun and ${widget.chart.moonSign.displayName} Moon. The current planetary transits encourage you to ground your decisions in raw self-honesty.";
    final qLower = text.toLowerCase();
    if (qLower.contains('love') || qLower.contains('relationship')) {
      reply = "With your Sun in ${widget.chart.sunSign.displayName} and Moon in ${widget.chart.moonSign.displayName}, you seek passionate connection and emotional safety. Your Venus placement suggests love comes when you stop performing perfection.";
    } else if (qLower.contains('career') || qLower.contains('work')) {
      reply = "Your Midheaven (MC) placement combined with your ${widget.chart.risingSign.displayName} Ascendant indicates that your true vocational superpower lies in bringing distinct authenticity to your projects.";
    }

    if (mounted) {
      setState(() {
        _messages.add({'sender': 'astrologer', 'text': reply});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 520,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('COSMIC AI ASTROLOGER', style: TextStyle(color: Color(0xFF888888), fontSize: 9, fontFamily: 'monospace')),
                    Text('ASK THE STARS', style: GoogleFonts.cormorantGaramond(fontSize: 22, color: Colors.black)),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.black, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: Color(0xFFE0E0E0)),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, idx) {
                  final msg = _messages[idx];
                  final isUser = msg['sender'] == 'user';
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.black : const Color(0xFFF9F9F9),
                        border: Border.all(color: isUser ? Colors.black : const Color(0xFFE0E0E0)),
                      ),
                      child: Text(
                        msg['text']!,
                        style: TextStyle(color: isUser ? Colors.white : Colors.black, fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('Consulting ephemeris...', style: TextStyle(color: Color(0xFF666666), fontSize: 10, fontFamily: 'monospace')),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputCtrl,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'Ask about your chart...',
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.send, color: Colors.black, size: 18),
                  onPressed: () => _sendMessage(_inputCtrl.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
