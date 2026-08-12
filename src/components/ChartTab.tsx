import React, { useState } from 'react';
import { NatalChart, PlanetPosition, HousePlacement } from '../types/astrology';
import { NatalChartWheel } from './NatalChartWheel';
import { ZODIAC_SYMBOLS } from '../services/astrologyEngine';
import { BookOpen, Info, ChevronRight } from 'lucide-react';

interface ChartTabProps {
  chart: NatalChart;
}

const EDU_ARTICLES = [
  { title: 'What is the Sun?', text: 'Your Sun sign represents core identity, ego, fundamental vitality, and conscious purpose.' },
  { title: 'What is the Moon?', text: 'Your Moon sign represents your private emotional self, instinctual reactions, memory, and safety needs.' },
  { title: 'What is Rising (Ascendant)?', text: 'Your Ascendant is the sign rising on the eastern horizon at your birth moment. It shapes your first impressions and physical filter.' },
  { title: 'What are Houses?', text: 'The chart is split into 12 houses representing distinct areas of life—from self-identity (1st) to public career (10th).' },
  { title: 'What are Aspects?', text: 'Aspects are geometric angles between planets (Trine, Square, Opposition) that reveal harmony or friction between psychological drivers.' }
];

export const ChartTab: React.FC<ChartTabProps> = ({ chart }) => {
  const [selectedPlanet, setSelectedPlanet] = useState<PlanetPosition | null>(null);
  const [selectedHouse, setSelectedHouse] = useState<HousePlacement | null>(null);
  const [selectedEdu, setSelectedEdu] = useState<typeof EDU_ARTICLES[0] | null>(null);

  return (
    <div className="space-y-8 pb-24 animate-fade-in">
      
      {/* Title Header */}
      <div className="text-center border-b border-neutral-800 pb-4 space-y-2">
        <span className="text-[10px] font-mono text-neutral-500 uppercase tracking-widest">COSMIC BLUEPRINT</span>
        <h2 className="text-3xl font-serif uppercase tracking-wider text-white">Your Natal Chart</h2>
        
        <div className="flex justify-center gap-2 pt-2 flex-wrap">
          <span className="badge-costar">☉ {chart.sunSign}</span>
          <span className="badge-costar">☽ {chart.moonSign}</span>
          <span className="badge-costar">ASC {chart.risingSign}</span>
        </div>
      </div>

      {/* Interactive Canvas Chart Wheel */}
      <div className="costar-card bg-neutral-950 flex flex-col items-center justify-center p-4 relative">
        <div className="text-[10px] font-mono text-neutral-500 uppercase tracking-widest mb-4">
          INTERACTIVE 360° WHEEL • TAP PLANETS TO INSPECT
        </div>
        <NatalChartWheel
          chart={chart}
          size={320}
          onPlanetSelect={(planet) => setSelectedPlanet(planet)}
        />
      </div>

      {/* Planet Placements List */}
      <div className="space-y-3">
        <div className="flex justify-between items-center text-xs font-mono text-neutral-500 uppercase tracking-widest">
          <span>PLANET PLACEMENTS</span>
          <span>SIGN & HOUSE</span>
        </div>

        <div className="border border-neutral-800 divide-y divide-neutral-900 bg-neutral-950">
          {chart.planets.map((planet, idx) => (
            <div
              key={idx}
              onClick={() => setSelectedPlanet(planet)}
              className="p-3 flex justify-between items-center cursor-pointer hover:bg-neutral-900 transition-colors"
            >
              <div className="flex items-center gap-3">
                <span className="font-serif text-lg text-white w-6 text-center">{planet.symbol}</span>
                <div>
                  <div className="text-xs font-mono font-bold text-white uppercase">{planet.name}</div>
                  <div className="text-[10px] font-mono text-neutral-500">{planet.meaning.substring(0, 42)}...</div>
                </div>
              </div>

              <div className="text-right font-mono text-xs">
                <div className="text-white font-medium">{ZODIAC_SYMBOLS[planet.sign]} {planet.sign}</div>
                <div className="text-[10px] text-neutral-500">{planet.degree}° • House {planet.house}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* 12 Houses Grid */}
      <div className="space-y-3">
        <div className="text-xs font-mono text-neutral-500 uppercase tracking-widest">
          12 HOUSES SYSTEM
        </div>

        <div className="grid grid-cols-2 gap-3 font-mono text-xs">
          {chart.houses.map((house, idx) => (
            <div
              key={idx}
              onClick={() => setSelectedHouse(house)}
              className="costar-card bg-neutral-950 p-3 hover:border-neutral-700 cursor-pointer space-y-1"
            >
              <div className="flex justify-between text-neutral-500 text-[10px]">
                <span>{house.name.toUpperCase()}</span>
                <span>{ZODIAC_SYMBOLS[house.sign]}</span>
              </div>
              <div className="text-white font-bold">{house.sign}</div>
              <div className="text-[10px] text-neutral-400 truncate">{house.theme}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Astrology Education Cards */}
      <div className="space-y-3 pt-2">
        <div className="flex items-center gap-2 text-xs font-mono text-neutral-500 uppercase tracking-widest">
          <BookOpen className="w-3.5 h-3.5" />
          <span>ASTROLOGY EDUCATION</span>
        </div>

        <div className="border border-neutral-800 divide-y divide-neutral-900 bg-neutral-950">
          {EDU_ARTICLES.map((article, idx) => (
            <div
              key={idx}
              onClick={() => setSelectedEdu(article)}
              className="p-3.5 flex justify-between items-center cursor-pointer hover:bg-neutral-900 text-xs font-mono"
            >
              <span className="text-white">{article.title}</span>
              <ChevronRight className="w-4 h-4 text-neutral-500" />
            </div>
          ))}
        </div>
      </div>

      {/* Planet Detail Modal */}
      {selectedPlanet && (
        <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-end sm:items-center justify-center p-4">
          <div className="bg-neutral-950 border border-neutral-800 max-w-md w-full p-6 space-y-6 text-white font-sans animate-slide-up">
            <div className="flex justify-between items-start border-b border-neutral-800 pb-4">
              <div>
                <span className="text-xs font-mono text-neutral-500 uppercase">PLANET ANALYSIS</span>
                <h3 className="text-2xl font-serif uppercase tracking-wide mt-1 flex items-center gap-2">
                  <span>{selectedPlanet.symbol}</span>
                  <span>{selectedPlanet.name} in {selectedPlanet.sign}</span>
                </h3>
              </div>
              <button
                onClick={() => setSelectedPlanet(null)}
                className="text-neutral-400 hover:text-white text-xl font-mono"
              >
                ✕
              </button>
            </div>

            <div className="space-y-3 font-mono text-xs">
              <div className="bg-neutral-900 p-3 border border-neutral-800 space-y-1">
                <div className="text-neutral-400 uppercase text-[10px]">POSITION DETAILS</div>
                <div>Sign: <span className="text-white font-bold">{selectedPlanet.sign}</span> ({selectedPlanet.degree}°)</div>
                <div>House: <span className="text-white font-bold">{selectedPlanet.house}th House</span></div>
                {selectedPlanet.isRetrograde && (
                  <div className="text-amber-400 font-bold">● Retrograde Motion</div>
                )}
              </div>

              <div>
                <h4 className="text-neutral-400 uppercase text-[10px] tracking-wider mb-1">CORE MEANING</h4>
                <p className="font-sans text-neutral-300 leading-relaxed text-xs">{selectedPlanet.meaning}</p>
              </div>

              <div>
                <h4 className="text-neutral-400 uppercase text-[10px] tracking-wider mb-1">PSYCHOLOGICAL EXPRESSION</h4>
                <p className="font-sans text-neutral-300 leading-relaxed text-xs">
                  Your {selectedPlanet.name} in {selectedPlanet.sign} shapes your approach to relationships and personal growth.
                  It highlights a desire for directness, authentic boundaries, and relentless self-refinement.
                </p>
              </div>
            </div>

            <button
              onClick={() => setSelectedPlanet(null)}
              className="w-full btn-costar-primary"
            >
              Close Details
            </button>
          </div>
        </div>
      )}

      {/* House Detail Modal */}
      {selectedHouse && (
        <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-end sm:items-center justify-center p-4">
          <div className="bg-neutral-950 border border-neutral-800 max-w-md w-full p-6 space-y-6 text-white font-sans animate-slide-up">
            <div className="flex justify-between items-start border-b border-neutral-800 pb-4">
              <div>
                <span className="text-xs font-mono text-neutral-500 uppercase">HOUSE ANALYSIS</span>
                <h3 className="text-2xl font-serif uppercase tracking-wide mt-1">
                  {selectedHouse.name} ({selectedHouse.sign})
                </h3>
              </div>
              <button
                onClick={() => setSelectedHouse(null)}
                className="text-neutral-400 hover:text-white text-xl font-mono"
              >
                ✕
              </button>
            </div>

            <div className="space-y-3 font-mono text-xs">
              <div className="bg-neutral-900 p-3 border border-neutral-800">
                <div className="text-neutral-400 uppercase text-[10px]">HOUSE THEME</div>
                <div className="text-white font-bold text-sm">{selectedHouse.theme}</div>
              </div>

              <div>
                <h4 className="text-neutral-400 uppercase text-[10px] tracking-wider mb-1">INTERPRETATION</h4>
                <p className="font-sans text-neutral-300 leading-relaxed text-xs">
                  With {selectedHouse.sign} governing your {selectedHouse.name}, this domain of your life is characterized by
                  thoughtful evaluation, high standards, and intense dedication.
                </p>
              </div>
            </div>

            <button
              onClick={() => setSelectedHouse(null)}
              className="w-full btn-costar-primary"
            >
              Close
            </button>
          </div>
        </div>
      )}

      {/* Education Article Modal */}
      {selectedEdu && (
        <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-end sm:items-center justify-center p-4">
          <div className="bg-neutral-950 border border-neutral-800 max-w-md w-full p-6 space-y-6 text-white font-sans animate-slide-up">
            <div className="flex justify-between items-start border-b border-neutral-800 pb-4">
              <div>
                <span className="text-xs font-mono text-neutral-500 uppercase">ASTROLOGY 101</span>
                <h3 className="text-2xl font-serif uppercase tracking-wide mt-1">{selectedEdu.title}</h3>
              </div>
              <button
                onClick={() => setSelectedEdu(null)}
                className="text-neutral-400 hover:text-white text-xl font-mono"
              >
                ✕
              </button>
            </div>

            <p className="font-sans text-xs text-neutral-300 leading-relaxed">{selectedEdu.text}</p>

            <button
              onClick={() => setSelectedEdu(null)}
              className="w-full btn-costar-primary"
            >
              Understood
            </button>
          </div>
        </div>
      )}

    </div>
  );
};
