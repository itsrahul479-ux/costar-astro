import React, { useState } from 'react';
import { DailyInsight, NatalChart } from '../types/astrology';
import { Sparkles, ArrowRight, ChevronRight, Share2, Calendar, Zap, AlertCircle } from 'lucide-react';

interface YouTabProps {
  insight: DailyInsight;
  chart: NatalChart;
  userName: string;
  onOpenAiChat: () => void;
}

export const YouTab: React.FC<YouTabProps> = ({ insight, chart, userName, onOpenAiChat }) => {
  const [showDetailModal, setShowDetailModal] = useState<boolean>(false);
  const [copiedShare, setCopiedShare] = useState<boolean>(false);

  const handleShare = () => {
    navigator.clipboard.writeText(`"${insight.mainQuote}" — ${userName}'s Co-Star Daily Insight`);
    setCopiedShare(true);
    setTimeout(() => setCopiedShare(false), 2000);
  };

  return (
    <div className="space-y-6 pb-20 animate-fade-in">
      
      {/* Date Header */}
      <div className="flex justify-between items-end border-b border-neutral-800 pb-3">
        <div>
          <span className="text-[10px] font-mono text-neutral-500 uppercase tracking-widest">TODAY</span>
          <h2 className="text-2xl font-serif uppercase tracking-wider text-white mt-0.5">
            {new Date().toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}
          </h2>
        </div>
        <div className="badge-costar">
          <span>{chart.sunSign} SUN</span>
        </div>
      </div>

      {/* Main Quote Hero Card (Co-Star signature stark design) */}
      <div className="costar-card space-y-6 bg-neutral-950 border-neutral-800 relative overflow-hidden">
        <div className="text-[10px] font-mono text-neutral-500 uppercase tracking-widest flex items-center justify-between">
          <span>YOUR DAY</span>
          <span>● TODAY</span>
        </div>
        
        <h1 className="text-3xl font-serif leading-tight font-light text-white tracking-wide">
          "{insight.mainQuote}"
        </h1>

        <p className="text-xs text-neutral-400 font-sans leading-relaxed border-l-2 border-white pl-3">
          {insight.subQuote}
        </p>

        <div className="flex items-center justify-between pt-2 border-t border-neutral-900">
          <button
            onClick={() => setShowDetailModal(true)}
            className="text-xs font-mono uppercase tracking-wider text-white flex items-center gap-1.5 hover:underline"
          >
            <span>Read Detailed Breakdown</span>
            <ChevronRight className="w-3.5 h-3.5" />
          </button>
          <button
            onClick={handleShare}
            className="text-neutral-400 hover:text-white p-2 transition-colors"
            title="Share daily insight"
          >
            <Share2 className="w-4 h-4" />
          </button>
        </div>
        {copiedShare && (
          <div className="absolute top-2 right-2 bg-white text-black text-[10px] font-mono px-2 py-0.5 rounded">
            Copied to clipboard
          </div>
        )}
      </div>

      {/* Power & Challenge Section */}
      <div className="grid grid-cols-2 gap-4">
        {/* Power Card */}
        <div className="costar-card bg-neutral-950 space-y-3">
          <div className="flex items-center gap-2 text-xs font-mono text-neutral-400 uppercase tracking-wider border-b border-neutral-900 pb-2">
            <Zap className="w-3.5 h-3.5 text-white" />
            <span>Power</span>
          </div>
          <ul className="space-y-1.5 text-xs font-mono">
            {insight.areasOfPower.map((power, idx) => (
              <li key={idx} className="flex items-center gap-2 text-white">
                <span className="text-neutral-600 text-[10px]">●</span>
                <span>{power}</span>
              </li>
            ))}
          </ul>
        </div>

        {/* Challenge Card */}
        <div className="costar-card bg-neutral-950 space-y-3">
          <div className="flex items-center gap-2 text-xs font-mono text-neutral-400 uppercase tracking-wider border-b border-neutral-900 pb-2">
            <AlertCircle className="w-3.5 h-3.5 text-neutral-400" />
            <span>Challenge</span>
          </div>
          <ul className="space-y-1.5 text-xs font-mono">
            {insight.areasOfChallenge.map((chal, idx) => (
              <li key={idx} className="flex items-center gap-2 text-neutral-300">
                <span className="text-neutral-600 text-[10px]">●</span>
                <span>{chal}</span>
              </li>
            ))}
          </ul>
        </div>
      </div>

      {/* Current Energy Level Meters */}
      <div className="costar-card bg-neutral-950 space-y-4">
        <div className="text-xs font-mono text-neutral-400 uppercase tracking-wider border-b border-neutral-900 pb-2">
          Current Energy Distribution
        </div>

        <div className="space-y-3 font-mono text-xs">
          <div>
            <div className="flex justify-between text-neutral-400 mb-1">
              <span>RELATIONSHIPS</span>
              <span className="text-white">{insight.energyLevels.relationships}%</span>
            </div>
            <div className="w-full bg-neutral-900 h-1.5">
              <div className="bg-white h-1.5" style={{ width: `${insight.energyLevels.relationships}%` }} />
            </div>
          </div>

          <div>
            <div className="flex justify-between text-neutral-400 mb-1">
              <span>CAREER & PURPOSE</span>
              <span className="text-white">{insight.energyLevels.career}%</span>
            </div>
            <div className="w-full bg-neutral-900 h-1.5">
              <div className="bg-white h-1.5" style={{ width: `${insight.energyLevels.career}%` }} />
            </div>
          </div>

          <div>
            <div className="flex justify-between text-neutral-400 mb-1">
              <span>CREATIVITY</span>
              <span className="text-white">{insight.energyLevels.creativity}%</span>
            </div>
            <div className="w-full bg-neutral-900 h-1.5">
              <div className="bg-white h-1.5" style={{ width: `${insight.energyLevels.creativity}%` }} />
            </div>
          </div>

          <div>
            <div className="flex justify-between text-neutral-400 mb-1">
              <span>SELF & VITALITY</span>
              <span className="text-white">{insight.energyLevels.self}%</span>
            </div>
            <div className="w-full bg-neutral-900 h-1.5">
              <div className="bg-white h-1.5" style={{ width: `${insight.energyLevels.self}%` }} />
            </div>
          </div>
        </div>
      </div>

      {/* Ask the AI Stars Prompt Card */}
      <div
        onClick={onOpenAiChat}
        className="costar-card bg-neutral-900 hover:bg-neutral-800 cursor-pointer flex items-center justify-between transition-all"
      >
        <div className="space-y-1">
          <div className="flex items-center gap-2 text-xs font-mono text-white uppercase tracking-wider">
            <Sparkles className="w-3.5 h-3.5" />
            <span>Ask the Stars</span>
          </div>
          <p className="text-xs text-neutral-400">Have a specific question about your chart or current transits?</p>
        </div>
        <ArrowRight className="w-4 h-4 text-white" />
      </div>

      {/* Historical Timeline */}
      <div className="space-y-3 pt-2">
        <div className="text-xs font-mono text-neutral-500 uppercase tracking-widest">
          Recent Timeline
        </div>
        
        <div className="border border-neutral-900 divide-y divide-neutral-900 bg-neutral-950 font-mono text-xs">
          <div className="p-3 flex justify-between items-center text-neutral-300">
            <div>
              <span className="text-white font-bold">TODAY</span> — Self & Relationships
            </div>
            <ChevronRight className="w-3.5 h-3.5 text-neutral-500" />
          </div>
          <div className="p-3 flex justify-between items-center text-neutral-500">
            <div>
              <span>YESTERDAY</span> — Routine & Boundaries
            </div>
            <ChevronRight className="w-3.5 h-3.5 text-neutral-700" />
          </div>
          <div className="p-3 flex justify-between items-center text-neutral-500">
            <div>
              <span>2 DAYS AGO</span> — Career & Communication
            </div>
            <ChevronRight className="w-3.5 h-3.5 text-neutral-700" />
          </div>
        </div>
      </div>

      {/* Detailed Reading Modal */}
      {showDetailModal && (
        <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-end sm:items-center justify-center p-4">
          <div className="bg-neutral-950 border border-neutral-800 max-w-md w-full max-h-[85vh] overflow-y-auto p-6 space-y-6 font-sans text-white animate-slide-up">
            <div className="flex justify-between items-start border-b border-neutral-800 pb-4">
              <div>
                <span className="text-xs font-mono text-neutral-500 uppercase">FULL READING</span>
                <h3 className="text-2xl font-serif uppercase tracking-wide mt-1">Today's Insight</h3>
              </div>
              <button
                onClick={() => setShowDetailModal(false)}
                className="text-neutral-400 hover:text-white text-xl font-mono"
              >
                ✕
              </button>
            </div>

            <div className="space-y-4 text-xs font-sans leading-relaxed text-neutral-300">
              <div>
                <h4 className="font-mono uppercase text-white tracking-wider mb-1">LOVE & RELATIONSHIPS</h4>
                <p>{insight.details.love}</p>
              </div>

              <div>
                <h4 className="font-mono uppercase text-white tracking-wider mb-1">WORK & AMBITION</h4>
                <p>{insight.details.work}</p>
              </div>

              <div>
                <h4 className="font-mono uppercase text-white tracking-wider mb-1">CREATIVITY & INTUITION</h4>
                <p>{insight.details.creativity}</p>
              </div>

              <div>
                <h4 className="font-mono uppercase text-white tracking-wider mb-1">SOCIAL DYNAMICS</h4>
                <p>{insight.details.social}</p>
              </div>

              <div>
                <h4 className="font-mono uppercase text-white tracking-wider mb-1">SELF & REST</h4>
                <p>{insight.details.self}</p>
              </div>

              <div className="bg-neutral-900 border border-neutral-800 p-3 mt-4">
                <h4 className="font-mono uppercase text-white tracking-wider mb-1 text-[10px]">COSMIC ADVICE</h4>
                <p className="text-neutral-300 italic">{insight.details.advice}</p>
              </div>
            </div>

            <button
              onClick={() => setShowDetailModal(false)}
              className="w-full btn-costar-primary"
            >
              Close Breakdown
            </button>
          </div>
        </div>
      )}

    </div>
  );
};
