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
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 540),
          child: SafeArea(
            child: Column(
              children: [
                // Top Bar with Back Arrow & Star Progress Indicators
                if (_step > 1 && _step < 8) _buildTopNavigation(),
                Expanded(child: _buildCurrentStep()),
              ],
            ),
          ),
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
            child: Text('Continue', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
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
                  style: GoogleFonts.inter(
                    fontSize: 16,
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

  // ----------------------------------------------------
  // EXACT UI REPLICATION FOR BIRTH TIME SCREEN
  // Matches the Cupertino wheel slider & luxury layout of the Date screen
  // ----------------------------------------------------
  Widget _buildTimeStep() {
    final hourFormatted = _selectedTime.hourOfPeriod == 0 ? 12 : _selectedTime.hourOfPeriod;
    final minuteFormatted = _selectedTime.minute.toString().padLeft(2, '0');
    final periodFormatted = _selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
    final formattedTimeDisplay = '$hourFormatted:$minuteFormatted $periodFormatted';

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
                'What time were you\nborn?',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 34,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF2C2823),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 20),

              // Selected Time Main Display Text
              Center(
                child: Column(
                  children: [
                    Text(
                      _isTimeUnknown ? 'Time Unknown' : formattedTimeDisplay,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E1A16),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isTimeUnknown
                          ? '12:00 PM will be used as standard noon time'
                          : 'Used for precise rising sign & house calculations',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF6B6358),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Wheel Time Picker Slider (matching date screen structure)
          Expanded(
            child: _isTimeUnknown
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2EBDC).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2D7C3)),
                      ),
                      child: Text(
                        'Approximate chart will be calculated without exact houses.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 16,
                          color: const Color(0xFF4A443C),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Center Highlighted Pill Container (matching Date screen)
                        Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2EBDC).withAlpha(200),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: const Color(0xFFE2D7C3), width: 1.2),
                          ),
                        ),

                        // Cupertino Time Picker Wheel
                        CupertinoTheme(
                          data: CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: GoogleFonts.cormorantGaramond(
                                fontSize: 24,
                                color: const Color(0xFF2C2823),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: DateTime(2024, 1, 1, _selectedTime.hour, _selectedTime.minute),
                            use24hFormat: false,
                            onDateTimeChanged: (DateTime newDateTime) {
                              setState(() {
                                _selectedTime = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          // Checkbox Toggle: I don't know my birth time
          GestureDetector(
            onTap: () => setState(() => _isTimeUnknown = !_isTimeUnknown),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isTimeUnknown,
                    onChanged: (val) => setState(() => _isTimeUnknown = val ?? false),
                    activeColor: const Color(0xFF2C2823),
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  Flexible(
                    child: Text(
                      'I don\'t know my birth time (Approximate chart used)',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF5A5349),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Continue Button & Security Footer (matching Date & Born screens)
          Column(
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _step = 5),
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
                  style: GoogleFonts.inter(
                    fontSize: 16,
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

  final TextEditingController _citySearchController = TextEditingController();
  Map<String, dynamic>? _selectedCityData;

  final List<Map<String, dynamic>> _expandedCities = const [
    {
      'name': 'Vasai-Virar City',
      'state': 'Maharashtra',
      'country': 'India',
      'flag': '🇮🇳',
      'lat': 19.46,
      'lng': 72.81,
      'subLocations': [
        'Vasai East Salt Plant\nVasai East, Vasai-Virar, Maharashtra, India',
        'Vasai East\nVasai, Maharashtra, India',
        'Vasai Phata\nPelhar, Maharashtra, India',
        'Vasai West\nVasai, Maharashtra, India',
        'Vasai\nAhmedabad, Gujarat, India',
      ],
    },
    {
      'name': 'Mumbai',
      'state': 'Maharashtra',
      'country': 'India',
      'flag': '🇮🇳',
      'lat': 19.0760,
      'lng': 72.8777,
      'subLocations': ['Mumbai Suburban, Maharashtra, India', 'South Mumbai, Maharashtra, India'],
    },
    {
      'name': 'New Delhi',
      'state': 'Delhi',
      'country': 'India',
      'flag': '🇮🇳',
      'lat': 28.6139,
      'lng': 77.2090,
      'subLocations': ['Central Delhi, Delhi, India', 'South Delhi, Delhi, India'],
    },
    {
      'name': 'Bengaluru',
      'state': 'Karnataka',
      'country': 'India',
      'flag': '🇮🇳',
      'lat': 12.9716,
      'lng': 77.5946,
      'subLocations': ['Bengaluru Urban, Karnataka, India', 'Electronic City, Bengaluru, India'],
    },
    {
      'name': 'New York',
      'state': 'New York',
      'country': 'USA',
      'flag': '🇺🇸',
      'lat': 40.7128,
      'lng': -74.0060,
      'subLocations': ['Manhattan, NY, USA', 'Brooklyn, NY, USA', 'Queens, NY, USA'],
    },
    {
      'name': 'London',
      'state': 'Greater London',
      'country': 'UK',
      'flag': '🇬🇧',
      'lat': 51.5074,
      'lng': -0.1278,
      'subLocations': ['City of London, UK', 'Westminster, London, UK'],
    },
    {
      'name': 'Paris',
      'state': 'Île-de-France',
      'country': 'France',
      'flag': '🇫🇷',
      'lat': 48.8566,
      'lng': 2.3522,
      'subLocations': ['Paris Center, France', 'Montmartre, Paris, France'],
    },
    {
      'name': 'Tokyo',
      'state': 'Kanto',
      'country': 'Japan',
      'flag': '🇯🇵',
      'lat': 35.6762,
      'lng': 139.6503,
      'subLocations': ['Shinjuku, Tokyo, Japan', 'Shibuya, Tokyo, Japan'],
    },
  ];

  // ----------------------------------------------------
  // EXACT UI REPLICATION FOR WHERE WERE YOU BORN SCREEN
  // Matches all 3 user screenshots (Search, Card & Dark Celestial Map)
  // ----------------------------------------------------
  Widget _buildLocationStep() {
    final query = _citySearchController.text.trim().toLowerCase();

    // Filter matching cities
    final matchingCities = query.isEmpty
        ? _expandedCities
        : _expandedCities.where((c) {
            final name = (c['name'] as String).toLowerCase();
            final state = (c['state'] as String).toLowerCase();
            final country = (c['country'] as String).toLowerCase();
            return name.contains(query) || state.contains(query) || country.contains(query);
          }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Headline
          Text(
            'Where were you born?',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 34,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF2C2823),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your chart is drawn from the sky\nabove your first breath.',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              color: const Color(0xFF5A5349),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),

          // Search Field with Underline & Clear 'x'
          Row(
            children: [
              if (_selectedCityData != null) ...[
                Text(
                  _selectedCityData!['flag'] ?? '📍',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: _citySearchController,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    color: const Color(0xFF2C2823),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search city...',
                    hintStyle: TextStyle(color: Color(0xFFB0A89C), fontSize: 20),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9E9689), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF332E27), width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                  ),
                  onChanged: (val) {
                    setState(() {
                      if (_selectedCityData != null && _selectedCityData!['name'] != val) {
                        _selectedCityData = null;
                      }
                    });
                  },
                ),
              ),
              if (_citySearchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _citySearchController.clear();
                      _selectedCityData = null;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 4),
                    child: Icon(Icons.close, size: 20, color: Color(0xFF6B6358)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Interactive Area
          Expanded(
            child: _selectedCityData == null
                ? (query.isEmpty
                    // Default / Search Suggestion List (Image 3)
                    ? ListView.separated(
                        itemCount: matchingCities.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final c = matchingCities[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCityData = c;
                                _selectedCity = "${c['name']}, ${c['country']}";
                                _citySearchController.text = c['name'];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                children: [
                                  Text(
                                    c['name'] as String,
                                    style: GoogleFonts.cormorantGaramond(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF3A342D),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${c['state']}, ${c['country']}",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF888075),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    // Active Search Result (Image 1: Dropdown card with flag)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final c = matchingCities.isNotEmpty ? matchingCities.first : _expandedCities.first;
                              setState(() {
                                _selectedCityData = c;
                                _selectedCity = "${c['name']}, ${c['country']}";
                                _citySearchController.text = c['name'];
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(color: const Color(0xFFEFE8DA), width: 1),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    matchingCities.isNotEmpty ? (matchingCities.first['flag'] ?? '🇮🇳') : '🇮🇳',
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        matchingCities.isNotEmpty ? (matchingCities.first['name'] as String) : 'Vasai-Virar City',
                                        style: GoogleFonts.cormorantGaramond(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2C2823),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        matchingCities.isNotEmpty ? "${matchingCities.first['state']}, ${matchingCities.first['country']}" : "Maharashtra, India",
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: const Color(0xFF6B6358),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                // Selected City State (Image 2: Dark Cosmic Night Map & Coordinates Card)
                : Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 210,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10131A), // Deep dark cosmic navy
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              // Subtle Coastline & Ocean Map Graphic
                              CustomPaint(
                                size: const Size(double.infinity, 210),
                                painter: _CosmicMapPainter(),
                              ),

                              // Map City Labels
                              const Positioned(
                                top: 22,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Text(
                                    'Surat',
                                    style: TextStyle(
                                      color: Color(0xFF9EABB8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                right: 16,
                                top: 120,
                                child: Text(
                                  'MAHARASHTRA',
                                  style: TextStyle(
                                    color: Color(0xFF5E6B7A),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const Positioned(
                                right: 100,
                                top: 140,
                                child: Text(
                                  'Pune',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 11,
                                  ),
                                ),
                              ),

                              // Selected Glowing City Pin (Golden ring)
                              Positioned(
                                top: 88,
                                left: 0,
                                right: 0,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFFD4AF37), width: 3),
                                        color: const Color(0xFF1E2430),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFD4AF37).withOpacity(0.4),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Mumbai',
                                      style: TextStyle(
                                        color: Color(0xFFE2E8F0),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Dark Bottom Gradient Plate with Gold Coordinates
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(0xFF0F172A).withOpacity(0.0),
                                        const Color(0xFF0B0F19).withOpacity(0.95),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${_selectedCityData!['name']}, ${_selectedCityData!['country']}",
                                        style: GoogleFonts.cormorantGaramond(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFE2C99B), // Soft Gold
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "${_selectedCityData!['lat']}° N  ·  ${_selectedCityData!['lng']}° E",
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: const Color(0xFF94A3B8),
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'The sky over ${_selectedCityData!['name']}, the\nmoment you arrived.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 19,
                          color: const Color(0xFF4A443C),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
          ),

          // Bottom Action: Continue Button + Privacy Note (Matches Screenshot)
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_selectedCityData == null && matchingCities.isNotEmpty) {
                    final c = matchingCities.first;
                    setState(() {
                      _selectedCityData = c;
                      _selectedCity = "${c['name']}, ${c['country']}";
                    });
                  }
                  setState(() => _step = 6);
                },
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
                  style: GoogleFonts.inter(
                    fontSize: 16,
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

class _CosmicMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dark Ocean Background
    final oceanPaint = Paint()..color = const Color(0xFF0C1017);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), oceanPaint);

    // 2. Landmass & Coastline Geometry (West Coast of India style)
    final landPaint = Paint()
      ..color = const Color(0xFF161C26)
      ..style = PaintingStyle.fill;

    final coastPath = Path()
      ..moveTo(size.width * 0.42, 0)
      ..cubicTo(size.width * 0.40, 40, size.width * 0.44, 70, size.width * 0.46, 95)
      ..cubicTo(size.width * 0.48, 120, size.width * 0.47, 150, size.width * 0.52, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(coastPath, landPaint);

    // 3. Glowing Coastline Edge
    final coastBorderPaint = Paint()
      ..color = const Color(0xFF334155).withOpacity(0.5)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final coastLine = Path()
      ..moveTo(size.width * 0.42, 0)
      ..cubicTo(size.width * 0.40, 40, size.width * 0.44, 70, size.width * 0.46, 95)
      ..cubicTo(size.width * 0.48, 120, size.width * 0.47, 150, size.width * 0.52, size.height);

    canvas.drawPath(coastLine, coastBorderPaint);

    // 4. Subtle Cosmic Grid Lines
    final gridPaint = Paint()
      ..color = const Color(0xFF334155).withOpacity(0.12)
      ..strokeWidth = 0.8;

    for (double x = 40; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 30; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
