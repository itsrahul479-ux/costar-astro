import React, { useState } from 'react';
import { BirthProfile, NatalChart } from '../types/astrology';
import { User, Settings, Bell, Shield, Award, HelpCircle, LogOut, Moon, Sun, Lock } from 'lucide-react';

interface ProfileTabProps {
  profile: BirthProfile;
  chart: NatalChart;
  onOpenPaywall: () => void;
  onResetAccount: () => void;
  isLightMode: boolean;
  onToggleTheme: () => void;
}

export const ProfileTab: React.FC<ProfileTabProps> = ({
  profile,
  chart,
  onOpenPaywall,
  onResetAccount,
  isLightMode,
  onToggleTheme
}) => {
  const [dailyNotify, setDailyNotify] = useState<boolean>(true);
  const [relationshipNotify, setRelationshipNotify] = useState<boolean>(true);
  const [planetNotify, setPlanetNotify] = useState<boolean>(true);

  return (
    <div className="space-y-6 pb-24 animate-fade-in">
      
      {/* Profile Header */}
      <div className="text-center border-b border-neutral-800 pb-6 space-y-3">
        <div className="w-20 h-20 mx-auto rounded-full bg-neutral-900 border border-neutral-700 flex items-center justify-center text-3xl font-serif">
          {profile.name.charAt(0).toUpperCase()}
        </div>

        <div>
          <h2 className="text-3xl font-serif uppercase tracking-wider text-white">{profile.name}</h2>
          <p className="text-xs font-mono text-neutral-400 mt-1">
            Born {profile.birthDate} in {profile.birthCity}, {profile.birthCountry}
          </p>
        </div>

        {/* Big Three Badges */}
        <div className="flex justify-center gap-2 pt-1 font-mono text-xs">
          <div className="badge-costar">☉ {chart.sunSign} Sun</div>
          <div className="badge-costar">☽ {chart.moonSign} Moon</div>
          <div className="badge-costar">ASC {chart.risingSign} Rising</div>
        </div>
      </div>

      {/* Subscription Banner */}
      <div
        onClick={onOpenPaywall}
        className="costar-card bg-neutral-900 border-neutral-700 hover:border-white cursor-pointer flex items-center justify-between transition-all"
      >
        <div className="space-y-1">
          <div className="flex items-center gap-2 text-xs font-mono text-white uppercase tracking-wider">
            <Lock className="w-3.5 h-3.5 text-amber-400" />
            <span>UNLOCKED BASIC ACCESS</span>
          </div>
          <p className="text-xs text-neutral-400">Upgrade to Premium for full Synastry, Eros, & AI Astrology.</p>
        </div>
        <button className="btn-costar-primary py-1.5 px-3 text-[10px]">
          Upgrade
        </button>
      </div>

      {/* Preferences & Theme Toggle */}
      <div className="costar-card bg-neutral-950 space-y-4 font-mono text-xs">
        <div className="text-neutral-400 uppercase text-[10px] tracking-widest border-b border-neutral-900 pb-2">
          APP PREFERENCES
        </div>

        <div className="flex justify-between items-center">
          <span className="text-white">Appearance Theme</span>
          <button
            onClick={onToggleTheme}
            className="btn-costar-secondary py-1 px-3 text-[10px] flex items-center gap-1.5"
          >
            {isLightMode ? <Sun className="w-3 h-3" /> : <Moon className="w-3 h-3" />}
            <span>{isLightMode ? 'Light' : 'Monochrome Dark'}</span>
          </button>
        </div>
      </div>

      {/* Notifications Settings */}
      <div className="costar-card bg-neutral-950 space-y-4 font-mono text-xs">
        <div className="flex items-center gap-2 text-neutral-400 uppercase text-[10px] tracking-widest border-b border-neutral-900 pb-2">
          <Bell className="w-3.5 h-3.5" />
          <span>PUSH NOTIFICATION PREFERENCES</span>
        </div>

        <div className="space-y-3">
          <div className="flex justify-between items-center">
            <span className="text-white">Daily Cosmic Horoscope</span>
            <input
              type="checkbox"
              checked={dailyNotify}
              onChange={() => setDailyNotify(!dailyNotify)}
              className="accent-white w-4 h-4 cursor-pointer"
            />
          </div>

          <div className="flex justify-between items-center">
            <span className="text-white">Relationship & Eros Insights</span>
            <input
              type="checkbox"
              checked={relationshipNotify}
              onChange={() => setRelationshipNotify(!relationshipNotify)}
              className="accent-white w-4 h-4 cursor-pointer"
            />
          </div>

          <div className="flex justify-between items-center">
            <span className="text-white">Planetary Events & Transits</span>
            <input
              type="checkbox"
              checked={planetNotify}
              onChange={() => setPlanetNotify(!planetNotify)}
              className="accent-white w-4 h-4 cursor-pointer"
            />
          </div>
        </div>
      </div>

      {/* Birth Profile Summary */}
      <div className="costar-card bg-neutral-950 space-y-3 font-mono text-xs">
        <div className="text-neutral-400 uppercase text-[10px] tracking-widest border-b border-neutral-900 pb-2">
          BIRTH DATA REGISTRY
        </div>

        <div className="space-y-2 text-neutral-300">
          <div className="flex justify-between">
            <span className="text-neutral-500">BIRTH DATE</span>
            <span>{profile.birthDate}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-neutral-500">BIRTH TIME</span>
            <span>{profile.isTimeUnknown ? 'Unknown' : profile.birthTime}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-neutral-500">LOCATION</span>
            <span>{profile.birthCity}, {profile.birthCountry}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-neutral-500">COORDINATES</span>
            <span>{profile.latitude.toFixed(2)}°, {profile.longitude.toFixed(2)}°</span>
          </div>
        </div>
      </div>

      {/* Reset Account Button */}
      <div className="pt-2">
        <button
          onClick={onResetAccount}
          className="w-full border border-red-900/50 text-red-400 hover:bg-red-950/40 p-3 text-xs font-mono uppercase tracking-wider transition-colors flex items-center justify-center gap-2"
        >
          <LogOut className="w-4 h-4" />
          <span>Reset Birth Profile & Start Over</span>
        </button>
      </div>

    </div>
  );
};
