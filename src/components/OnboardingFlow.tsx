import React, { useState } from 'react';
import { BirthProfile } from '../types/astrology';
import { Sparkles, Calendar, Clock, MapPin, CheckCircle, ArrowRight, ShieldCheck } from 'lucide-react';

interface OnboardingFlowProps {
  onComplete: (profile: BirthProfile) => void;
}

const CITIES_MOCK = [
  { city: 'New Delhi', country: 'India', lat: 28.6139, lng: 77.2090, tz: 'Asia/Kolkata' },
  { city: 'Mumbai', country: 'India', lat: 19.0760, lng: 72.8777, tz: 'Asia/Kolkata' },
  { city: 'Bengaluru', country: 'India', lat: 12.9716, lng: 77.5946, tz: 'Asia/Kolkata' },
  { city: 'New York', country: 'USA', lat: 40.7128, lng: -74.0060, tz: 'America/New_York' },
  { city: 'London', country: 'United Kingdom', lat: 51.5074, lng: -0.1278, tz: 'Europe/London' },
  { city: 'Paris', country: 'France', lat: 48.8566, lng: 2.3522, tz: 'Europe/Paris' },
  { city: 'Tokyo', country: 'Japan', lat: 35.6762, lng: 139.6503, tz: 'Asia/Tokyo' },
  { city: 'Sydney', country: 'Australia', lat: -33.8688, lng: 151.2093, tz: 'Australia/Sydney' }
];

export const OnboardingFlow: React.FC<OnboardingFlowProps> = ({ onComplete }) => {
  const [step, setStep] = useState<number>(1);
  const [name, setName] = useState<string>('');
  const [birthDate, setBirthDate] = useState<string>('1998-08-15');
  const [birthTime, setBirthTime] = useState<string>('22:35');
  const [isTimeUnknown, setIsTimeUnknown] = useState<boolean>(false);
  const [locationSearch, setLocationSearch] = useState<string>('New Delhi, India');
  const [selectedLocation, setSelectedLocation] = useState(CITIES_MOCK[0]);
  const [calculatingPlanet, setCalculatingPlanet] = useState<string>('Sun');

  const handleStartChartCalculation = () => {
    setStep(7); // Calculation step
    const planetsSeq = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune', 'Pluto'];
    let idx = 0;
    const interval = setInterval(() => {
      idx++;
      if (idx < planetsSeq.length) {
        setCalculatingPlanet(planetsSeq[idx]);
      } else {
        clearInterval(interval);
        setStep(8); // Notification step
      }
    }, 350);
  };

  const handleFinishOnboarding = () => {
    onComplete({
      name: name || 'Seeker',
      birthDate,
      birthTime: isTimeUnknown ? '12:00' : birthTime,
      isTimeUnknown,
      birthCity: selectedLocation.city,
      birthCountry: selectedLocation.country,
      latitude: selectedLocation.lat,
      longitude: selectedLocation.lng,
      timezone: selectedLocation.tz
    });
  };

  return (
    <div className="min-h-screen bg-black text-white flex flex-col justify-between p-6 max-w-md mx-auto relative overflow-hidden font-sans border-x border-neutral-900">
      
      {/* Top Progress bar */}
      {step > 1 && step < 8 && (
        <div className="w-full bg-neutral-900 h-1 mb-8 rounded">
          <div
            className="bg-white h-1 transition-all duration-300"
            style={{ width: `${((step - 1) / 6) * 100}%` }}
          />
        </div>
      )}

      {/* STEP 1: WELCOME SCREEN */}
      {step === 1 && (
        <div className="my-auto text-center space-y-8 animate-fade-in">
          <div className="w-20 h-20 mx-auto rounded-full border border-white flex items-center justify-center text-3xl font-serif">
            ✶
          </div>
          <div>
            <h1 className="text-4xl font-serif font-light tracking-wide uppercase mb-3">
              Know yourself differently.
            </h1>
            <p className="text-sm text-neutral-400 font-sans leading-relaxed max-w-xs mx-auto">
              Discover your birth chart, daily insights and relationship dynamics based on your unique astrology.
            </p>
          </div>
          <div className="pt-6 space-y-3">
            <button
              onClick={() => setStep(2)}
              className="w-full btn-costar-primary flex items-center justify-center gap-2"
            >
              <span>Get Started</span>
              <ArrowRight className="w-4 h-4" />
            </button>
            <button
              onClick={() => {
                setName('Rahul');
                setStep(2);
              }}
              className="w-full btn-costar-secondary"
            >
              I already have an account
            </button>
          </div>
        </div>
      )}

      {/* STEP 2: NAME SCREEN */}
      {step === 2 && (
        <div className="my-auto space-y-8">
          <div>
            <span className="text-xs uppercase font-mono text-neutral-500 tracking-widest">Step 01 / 05</span>
            <h2 className="text-3xl font-serif uppercase tracking-wide mt-2">What's your name?</h2>
            <p className="text-xs text-neutral-400 mt-1">Used for your chart, daily notifications & compatibility.</p>
          </div>
          <div>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="First name"
              autoFocus
              className="w-full bg-transparent border-b border-neutral-600 focus:border-white text-2xl py-3 outline-none transition-colors"
            />
          </div>
          <button
            disabled={!name.trim()}
            onClick={() => setStep(3)}
            className="w-full btn-costar-primary disabled:opacity-40"
          >
            Continue
          </button>
        </div>
      )}

      {/* STEP 3: DATE OF BIRTH SCREEN */}
      {step === 3 && (
        <div className="my-auto space-y-8">
          <div>
            <span className="text-xs uppercase font-mono text-neutral-500 tracking-widest">Step 02 / 05</span>
            <h2 className="text-3xl font-serif uppercase tracking-wide mt-2">When were you born?</h2>
            <p className="text-xs text-neutral-400 mt-1">Your exact birth date sets your planetary alignments.</p>
          </div>
          <div className="flex items-center gap-3 bg-neutral-900/60 p-4 border border-neutral-800">
            <Calendar className="w-5 h-5 text-neutral-400" />
            <input
              type="date"
              value={birthDate}
              onChange={(e) => setBirthDate(e.target.value)}
              className="bg-transparent text-xl font-mono text-white outline-none w-full cursor-pointer"
            />
          </div>
          <button
            onClick={() => setStep(4)}
            className="w-full btn-costar-primary"
          >
            Continue
          </button>
        </div>
      )}

      {/* STEP 4: BIRTH TIME SCREEN */}
      {step === 4 && (
        <div className="my-auto space-y-8">
          <div>
            <span className="text-xs uppercase font-mono text-neutral-500 tracking-widest">Step 03 / 05</span>
            <h2 className="text-3xl font-serif uppercase tracking-wide mt-2">What time were you born?</h2>
            <p className="text-xs text-neutral-400 mt-1">Birth time determines your Ascendant (Rising sign) & houses.</p>
          </div>

          {!isTimeUnknown && (
            <div className="flex items-center gap-3 bg-neutral-900/60 p-4 border border-neutral-800">
              <Clock className="w-5 h-5 text-neutral-400" />
              <input
                type="time"
                value={birthTime}
                onChange={(e) => setBirthTime(e.target.value)}
                className="bg-transparent text-xl font-mono text-white outline-none w-full cursor-pointer"
              />
            </div>
          )}

          <div
            onClick={() => setIsTimeUnknown(!isTimeUnknown)}
            className="flex items-center gap-3 cursor-pointer select-none text-xs text-neutral-400 hover:text-white"
          >
            <div className={`w-4 h-4 border border-neutral-500 flex items-center justify-center ${isTimeUnknown ? 'bg-white text-black' : ''}`}>
              {isTimeUnknown && '✓'}
            </div>
            <span>I don't know my exact birth time (Approximate chart used)</span>
          </div>

          <button
            onClick={() => setStep(5)}
            className="w-full btn-costar-primary"
          >
            Continue
          </button>
        </div>
      )}

      {/* STEP 5: BIRTH LOCATION SCREEN */}
      {step === 5 && (
        <div className="my-auto space-y-6">
          <div>
            <span className="text-xs uppercase font-mono text-neutral-500 tracking-widest">Step 04 / 05</span>
            <h2 className="text-3xl font-serif uppercase tracking-wide mt-2">Where were you born?</h2>
            <p className="text-xs text-neutral-400 mt-1">Used to calculate exact horizon angles and latitude coordinates.</p>
          </div>

          <div className="relative">
            <MapPin className="w-5 h-5 text-neutral-400 absolute left-3 top-3.5" />
            <input
              type="text"
              value={locationSearch}
              onChange={(e) => setLocationSearch(e.target.value)}
              placeholder="Search city..."
              className="w-full bg-neutral-900 border border-neutral-800 pl-11 pr-4 py-3 text-sm font-sans outline-none focus:border-white"
            />
          </div>

          <div className="border border-neutral-800 max-h-48 overflow-y-auto divide-y divide-neutral-900 bg-neutral-950">
            {CITIES_MOCK.filter(c => `${c.city}, ${c.country}`.toLowerCase().includes(locationSearch.toLowerCase())).map((c, i) => (
              <div
                key={i}
                onClick={() => {
                  setSelectedLocation(c);
                  setLocationSearch(`${c.city}, ${c.country}`);
                }}
                className={`p-3 text-xs flex justify-between cursor-pointer hover:bg-neutral-900 ${selectedLocation.city === c.city ? 'bg-neutral-900 font-bold text-white' : 'text-neutral-400'}`}
              >
                <span>{c.city}, {c.country}</span>
                <span className="font-mono text-neutral-600">{c.lat.toFixed(2)}°, {c.lng.toFixed(2)}°</span>
              </div>
            ))}
          </div>

          <button
            onClick={() => setStep(6)}
            className="w-full btn-costar-primary"
          >
            Continue
          </button>
        </div>
      )}

      {/* STEP 6: CONFIRMATION SCREEN */}
      {step === 6 && (
        <div className="my-auto space-y-8">
          <div>
            <span className="text-xs uppercase font-mono text-neutral-500 tracking-widest">Step 05 / 05</span>
            <h2 className="text-3xl font-serif uppercase tracking-wide mt-2">Confirm details</h2>
            <p className="text-xs text-neutral-400 mt-1">Verify your cosmic footprint before calculation.</p>
          </div>

          <div className="bg-neutral-950 border border-neutral-800 p-6 space-y-4 font-mono text-xs">
            <div className="flex justify-between border-b border-neutral-900 pb-2">
              <span className="text-neutral-500 uppercase">NAME</span>
              <span className="text-white font-bold">{name}</span>
            </div>
            <div className="flex justify-between border-b border-neutral-900 pb-2">
              <span className="text-neutral-500 uppercase">DATE OF BIRTH</span>
              <span className="text-white">{birthDate}</span>
            </div>
            <div className="flex justify-between border-b border-neutral-900 pb-2">
              <span className="text-neutral-500 uppercase">TIME OF BIRTH</span>
              <span className="text-white">{isTimeUnknown ? 'Unknown (Approximate)' : birthTime}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-neutral-500 uppercase">LOCATION</span>
              <span className="text-white">{selectedLocation.city}, {selectedLocation.country}</span>
            </div>
          </div>

          <div className="space-y-3">
            <button
              onClick={handleStartChartCalculation}
              className="w-full btn-costar-primary"
            >
              Create My Chart
            </button>
            <button
              onClick={() => setStep(2)}
              className="w-full btn-costar-secondary"
            >
              Edit Details
            </button>
          </div>
        </div>
      )}

      {/* STEP 7: ANIMATED CHART CALCULATION */}
      {step === 7 && (
        <div className="my-auto text-center space-y-8 animate-pulse-slow">
          <div className="w-24 h-24 mx-auto rounded-full border border-neutral-600 flex items-center justify-center text-4xl font-serif animate-spin-slow">
            ☸
          </div>
          <div>
            <h3 className="text-2xl font-serif uppercase tracking-widest text-neutral-300">
              Calculating blueprint...
            </h3>
            <p className="text-xs font-mono text-neutral-500 mt-2 uppercase tracking-wider">
              Aligning position for: <span className="text-white font-bold">{calculatingPlanet}</span>
            </p>
          </div>
        </div>
      )}

      {/* STEP 8: NOTIFICATION PERMISSION SCREEN */}
      {step === 8 && (
        <div className="my-auto text-center space-y-8 animate-fade-in">
          <div className="w-16 h-16 mx-auto rounded-full border border-neutral-700 flex items-center justify-center">
            <Sparkles className="w-8 h-8 text-white" />
          </div>
          <div>
            <h2 className="text-3xl font-serif uppercase tracking-wide">Stay connected</h2>
            <p className="text-xs text-neutral-400 mt-2 leading-relaxed max-w-xs mx-auto">
              Receive short, stark daily insights when cosmic transits cross your natal chart.
            </p>
          </div>

          <div className="bg-neutral-950 border border-neutral-800 p-4 text-left font-mono text-xs space-y-2">
            <div className="text-neutral-400">DAILY NOTIFICATION PREVIEW</div>
            <div className="text-white font-sans font-medium">"Your relationships require raw honesty today. Stop assuming answers."</div>
          </div>

          <div className="space-y-3">
            <button
              onClick={handleFinishOnboarding}
              className="w-full btn-costar-primary flex items-center justify-center gap-2"
            >
              <ShieldCheck className="w-4 h-4" />
              <span>Enable Daily Insights</span>
            </button>
            <button
              onClick={handleFinishOnboarding}
              className="w-full btn-costar-secondary"
            >
              Skip for Now
            </button>
          </div>
        </div>
      )}

      {/* Footer Branding */}
      <div className="text-center text-[10px] font-mono text-neutral-700 uppercase tracking-widest pt-4">
        CO-STAR INSPIRED ASTROLOGY ARCHITECTURE
      </div>
    </div>
  );
};
