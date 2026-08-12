import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../shared/models/astrology_models.dart';
import '../../../core/router/app_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 1;
  String _name = 'RAHUL';
  DateTime _selectedDate = DateTime(1991, 3, 13);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 22, minute: 35);
  bool _isTimeUnknown = false;
  String _selectedCity = 'New Delhi, India';
  String _calculatingPlanet = 'Sun';

  final List<Map<String, dynamic>> _citiesMock = const [
    {'city': 'New Delhi', 'country': 'India', 'lat': 28.6139, 'lng': 77.2090, 'tz': 'Asia/Kolkata'},
    {'city': 'Mumbai', 'country': 'India', 'lat': 19.0760, 'lng': 72.8777, 'tz': 'Asia/Kolkata'},
    {'city': 'Bengaluru', 'country': 'India', 'lat': 12.9716, 'lng': 77.5946, 'tz': 'Asia/Kolkata'},
    {'city': 'New York', 'country': 'USA', 'lat': 40.7128, 'lng': -74.0060, 'tz': 'America/New_York'},
    {'city': 'London', 'country': 'UK', 'lat': 51.5074, 'lng': -0.1278, 'tz': 'Europe/London'},
    {'city': 'Paris', 'country': 'France', 'lat': 48.8566, 'lng': 2.3522, 'tz': 'Europe/Paris'},
    {'city': 'Tokyo', 'country': 'Japan', 'lat': 35.6762, 'lng': 139.6503, 'tz': 'Asia/Tokyo'},
  ];

  static const List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  ZodiacSign _calculateSunSign(int month, int day) {
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return ZodiacSign.aries;
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return ZodiacSign.taurus;
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return ZodiacSign.gemini;
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return ZodiacSign.cancer;
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return ZodiacSign.leo;
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return ZodiacSign.virgo;
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return ZodiacSign.libra;
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return ZodiacSign.scorpio;
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return ZodiacSign.sagittarius;
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return ZodiacSign.capricorn;
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return ZodiacSign.aquarius;
    return ZodiacSign.pisces;
  }

  String _getZodiacMotto(ZodiacSign sign) {
    switch (sign) {
      case ZodiacSign.aries: return 'the pioneering spark';
      case ZodiacSign.taurus: return 'the grounded anchor';
      case ZodiacSign.gemini: return 'the curious storyteller';
      case ZodiacSign.cancer: return 'the protective haven';
      case ZodiacSign.leo: return 'the luminous heart';
      case ZodiacSign.virgo: return 'the thoughtful artisan';
      case ZodiacSign.libra: return 'the harmonious mirror';
      case ZodiacSign.scorpio: return 'the intuitive alchemist';
      case ZodiacSign.sagittarius: return 'the free seeker';
      case ZodiacSign.capricorn: return 'the wise builder';
      case ZodiacSign.aquarius: return 'the visionary mind';
      case ZodiacSign.pisces: return 'the dreaming heart';
    }
  }

  void _startCalculation() {
    setState(() => _step = 7);
    const planets = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune', 'Pluto'];
    int idx = 0;
    Timer.periodic(const Duration(milliseconds: 350), (timer) {
      idx++;
      if (idx < planets.length) {
        setState(() => _calculatingPlanet = planets[idx]);
      } else {
        timer.cancel();
        setState(() => _step = 8);
      }
    });
  }

  void _finishOnboarding() {
    final parts = _selectedCity.split(',');
    final city = parts[0].trim();
    final country = parts.length > 1 ? parts[1].trim() : 'India';

    final profile = BirthProfile(
      name: _name.isEmpty ? 'Seeker' : _name,
      birthDate: "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
      birthTime: _isTimeUnknown ? '12:00' : "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}",
      isTimeUnknown: _isTimeUnknown,
      birthCity: city,
      birthCountry: country,
      latitude: 28.6139,
      longitude: 77.2090,
      timezone: 'Asia/Kolkata',
    );

    ref.read(userBirthProfileProvider.notifier).state = profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3), // Warm off-white / light cream
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Back Arrow & Star Progress Indicators
            if (_step > 1 && _step < 8) _buildTopNavigation(),
            Expanded(child: _buildCurrentStep()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF2C2823), size: 22),
            onPressed: () {
              if (_step > 1) setState(() => _step--);
            },
          ),
          Row(
            children: List.generate(5, (index) {
              final stepIndex = index + 2; // Steps 2 to 6
              final isActive = _step >= stepIndex;
              return Row(
                children: [
                  Text(
                    isActive ? '✦' : '✧',
                    style: TextStyle(
                      color: isActive ? const Color(0xFFB89D6A) : const Color(0xFFCCCCCC),
                      fontSize: 14,
                    ),
                  ),
                  if (index < 4)
                    Container(
                      width: 14,
                      height: 1,
                      color: const Color(0xFFE5DDD0),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                ],
              );
            }),
          ),
          const SizedBox(width: 40), // Balance space
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 1:
        return _buildWelcomeStep();
      case 2:
        return _buildNameStep();
      case 3:
        return _buildDateStepCustomUI(); // High fidelity birth date screen matching user screenshot
      case 4:
        return _buildTimeStep();
      case 5:
        return _buildLocationStep();
      case 6:
        return _buildConfirmStep();
      case 7:
        return _buildCalculationStep();
      case 8:
        return _buildNotificationStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildWelcomeStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2C2823), width: 1),
            ),
            child: Center(
              child: Text(
                '✶',
                style: GoogleFonts.cormorantGaramond(fontSize: 40, color: const Color(0xFF2C2823)),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'KNOW YOURSELF DIFFERENTLY.',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              color: const Color(0xFF2C2823),
              letterSpacing: 1.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Discover your birth chart, daily insights and relationship dynamics based on your unique astrology.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF666056), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => setState(() => _step = 2),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF2EBDC),
              foregroundColor: const Color(0xFF2C2823),
              elevation: 0,
              side: const BorderSide(color: Color(0xFF332E27), width: 1),
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Get Started',
                  style: GoogleFonts.cormorantGaramond(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(LucideIcons.arrowRight, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('STEP 01 / 05', style: TextStyle(color: Color(0xFF888075), fontSize: 10, fontFamily: 'monospace')),
          const SizedBox(height: 8),
          Text('WHAT\'S YOUR NAME?', style: GoogleFonts.cormorantGaramond(fontSize: 32, color: const Color(0xFF2C2823))),
          const SizedBox(height: 4),
          const Text('Used for greetings, chart calculations & notifications.', style: TextStyle(color: Color(0xFF666056), fontSize: 12)),
          const SizedBox(height: 32),
          TextField(
            autofocus: true,
            style: GoogleFonts.cormorantGaramond(color: const Color(0xFF2C2823), fontSize: 32),
            decoration: const InputDecoration(
              hintText: 'First name',
              hintStyle: TextStyle(color: Color(0xFFCCCCCC)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFCCCCCC))),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2C2823))),
            ),
            onChanged: (val) => setState(() => _name = val),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _name.trim().isEmpty ? null : () => setState(() => _step = 3),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF2EBDC),
              foregroundColor: const Color(0xFF2C2823),
              elevation: 0,
              side: const BorderSide(color: Color(0xFF332E27), width: 1),
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text('Continue', style: GoogleFonts.cormorantGaramond(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // EXACT UI REPLICATION FOR BIRTH DATE SCREEN (Image 1)
  // ----------------------------------------------------
  Widget _buildDateStepCustomUI() {
    final nameDisplay = _name.trim().isNotEmpty ? _name.trim().toUpperCase() : 'RAHUL';
    final age = _calculateAge(_selectedDate);
    final monthStr = monthNames[_selectedDate.month - 1];
    final sunSign = _calculateSunSign(_selectedDate.month, _selectedDate.day);
    final motto = _getZodiacMotto(sunSign);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Headline
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$nameDisplay, what\'s your\nbirth date?',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 34,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF2C2823),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 20),

              // Selected Date Main Text
              Center(
                child: Column(
                  children: [
                    Text(
                      '$monthStr ${_selectedDate.day}, ${_selectedDate.year}',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E1A16),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You are $age years old',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF6B6358),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Wheel Date Picker Component
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center Highlighted Pill Container
                  Container(
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2EBDC).withAlpha(200),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: const Color(0xFFE2D7C3), width: 1.2),
                    ),
                  ),

                  // Cupertino Date Picker Wheel
                  CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: GoogleFonts.cormorantGaramond(
                          fontSize: 22,
                          color: const Color(0xFF2C2823),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: _selectedDate,
                      maximumDate: DateTime.now(),
                      minimumYear: 1930,
                      maximumYear: DateTime.now().year,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => _selectedDate = newDate);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dynamic Zodiac Motto Subtext
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('☀️ ', style: TextStyle(fontSize: 12)),
                Text(
                  '${sunSign.displayName} Sun · $motto',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 16,
                    color: const Color(0xFF4A443C),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Continue Button & Privacy Note
          Column(
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _step = 4),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2EBDC),
                  foregroundColor: const Color(0xFF2C2823),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF332E27), width: 1),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C2823),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.lock, size: 12, color: Color(0xFF888075)),
                  const SizedBox(width: 6),
                  Text(
                    'Never shared. Stored only on your device',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF888075),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('STEP 03 / 05', style: TextStyle(color: Color(0xFF888075), fontSize: 10, fontFamily: 'monospace')),
          const SizedBox(height: 8),
          Text('WHAT TIME WERE YOU BORN?', style: GoogleFonts.cormorantGaramond(fontSize: 32, color: const Color(0xFF2C2823))),
          const SizedBox(height: 24),
          if (!_isTimeUnknown)
            InkWell(
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                if (picked != null) setState(() => _selectedTime = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2EBDC),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFF332E27)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.clock, color: Color(0xFF2C2823), size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _selectedTime.format(context),
                      style: GoogleFonts.cormorantGaramond(color: const Color(0xFF2C2823), fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _isTimeUnknown = !_isTimeUnknown),
            child: Row(
              children: [
                Checkbox(
                  value: _isTimeUnknown,
                  onChanged: (val) => setState(() => _isTimeUnknown = val ?? false),
                  activeColor: const Color(0xFF2C2823),
                  checkColor: Colors.white,
                ),
                const Text('I don\'t know my birth time (Approximate chart used)', style: TextStyle(color: Color(0xFF666056), fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => setState(() => _step = 5),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF2EBDC),
              foregroundColor: const Color(0xFF2C2823),
              elevation: 0,
              side: const BorderSide(color: Color(0xFF332E27), width: 1),
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: Text('Continue', style: GoogleFonts.cormorantGaramond(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('STEP 04 / 05', style: TextStyle(color: Color(0xFF888075), fontSize: 10, fontFamily: 'monospace')),
          const SizedBox(height: 8),
          Text('WHERE WERE YOU BORN?', style: GoogleFonts.cormorantGaramond(fontSize: 32, color: const Color(0xFF2C2823))),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFAF8F3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5DDD0)),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: _citiesMock.map((c) {
                  final locStr = "${c['city']}, ${c['country']}";
                  final isSelected = _selectedCity == locStr;
                  return ListTile(
                    dense: true,
                    title: Text(locStr, style: TextStyle(color: isSelected ? const Color(0xFF2C2823) : const Color(0xFF666056), fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    trailing: isSelected ? const Icon(LucideIcons.check, color: Color(0xFF2C2823), size: 16) : null,
                    onTap: () => setState(() => _selectedCity = locStr),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () => setState(() => _step = 6),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2EBDC),
                  foregroundColor: const Color(0xFF2C2823),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF332E27), width: 1),
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: Text('Continue', style: GoogleFonts.cormorantGaramond(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('STEP 05 / 05', style: TextStyle(color: Color(0xFF888075), fontSize: 10, fontFamily: 'monospace')),
          const SizedBox(height: 8),
          Text('CONFIRM DETAILS', style: GoogleFonts.cormorantGaramond(fontSize: 32, color: const Color(0xFF2C2823))),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF2EBDC).withAlpha(128),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5DDD0)),
            ),
            child: Column(
              children: [
                _summaryRow('NAME', _name),
                const Divider(color: Color(0xFFE5DDD0)),
                _summaryRow('BIRTH DATE', "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                const Divider(color: Color(0xFFE5DDD0)),
                _summaryRow('BIRTH TIME', _isTimeUnknown ? 'Unknown' : _selectedTime.format(context)),
                const Divider(color: Color(0xFFE5DDD0)),
                _summaryRow('LOCATION', _selectedCity),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _startCalculation,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C2823),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: Text('Create My Chart', style: GoogleFonts.cormorantGaramond(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF888075), fontSize: 10, fontFamily: 'monospace')),
          Text(value, style: const TextStyle(color: Color(0xFF2C2823), fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCalculationStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(color: Color(0xFF2C2823), strokeWidth: 1.5),
        ),
        const SizedBox(height: 32),
        Text('CALCULATING BLUEPRINT...', style: GoogleFonts.cormorantGaramond(fontSize: 24, color: const Color(0xFF2C2823), letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Text('Aligning placement: $_calculatingPlanet', style: const TextStyle(color: Color(0xFF666056), fontSize: 11, fontFamily: 'monospace')),
      ],
    );
  }

  Widget _buildNotificationStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.sparkles, color: Color(0xFF2C2823), size: 48),
          const SizedBox(height: 24),
          Text('STAY CONNECTED', style: GoogleFonts.cormorantGaramond(fontSize: 32, color: const Color(0xFF2C2823))),
          const SizedBox(height: 12),
          const Text(
            'Receive short, stark daily insights when cosmic transits cross your natal chart.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF666056), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _finishOnboarding,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C2823),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: Text('Enable Daily Insights', style: GoogleFonts.cormorantGaramond(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
