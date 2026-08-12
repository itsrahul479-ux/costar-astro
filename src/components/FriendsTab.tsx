import React, { useState } from 'react';
import { Friend, NatalChart, CompatibilityReport } from '../types/astrology';
import { calculateCompatibility, ZODIAC_SYMBOLS } from '../services/astrologyEngine';
import { UserPlus, Share2, Heart, MessageSquare, Sparkles, Flame, ChevronRight, UserCheck } from 'lucide-react';

interface FriendsTabProps {
  userChart: NatalChart;
  friends: Friend[];
  onAddFriend: (friend: Friend) => void;
  onOpenPaywall: () => void;
}

export const FriendsTab: React.FC<FriendsTabProps> = ({
  userChart,
  friends,
  onAddFriend,
  onOpenPaywall
}) => {
  const [selectedFriend, setSelectedFriend] = useState<Friend | null>(friends[0] || null);
  const [showAddModal, setShowAddModal] = useState<boolean>(false);
  const [addTab, setAddTab] = useState<'username' | 'link' | 'manual'>('manual');

  // Manual Add state
  const [manualName, setManualName] = useState<string>('');
  const [manualDob, setManualDob] = useState<string>('1999-04-20');
  const [manualTime, setManualTime] = useState<string>('14:30');

  const activeCompat: CompatibilityReport | null = selectedFriend
    ? calculateCompatibility(userChart, selectedFriend.chart)
    : null;

  const handleCreateManualFriend = () => {
    if (!manualName.trim()) return;
    
    // Create friend chart
    const friendChart: NatalChart = {
      sunSign: 'Taurus',
      moonSign: 'Virgo',
      risingSign: 'Scorpio',
      planets: userChart.planets,
      houses: userChart.houses,
      aspects: userChart.aspects
    };

    const newFriend: Friend = {
      id: `friend_${Date.now()}`,
      name: manualName,
      username: `@${manualName.toLowerCase().replace(/\s+/g, '')}`,
      sunSign: 'Taurus',
      moonSign: 'Virgo',
      risingSign: 'Scorpio',
      birthProfile: {
        name: manualName,
        birthDate: manualDob,
        birthTime: manualTime,
        isTimeUnknown: false,
        birthCity: 'Mumbai',
        birthCountry: 'India',
        latitude: 19.076,
        longitude: 72.877,
        timezone: 'Asia/Kolkata'
      },
      chart: friendChart
    };

    onAddFriend(newFriend);
    setSelectedFriend(newFriend);
    setShowAddModal(false);
    setManualName('');
  };

  return (
    <div className="space-y-6 pb-24 animate-fade-in">
      
      {/* Header & Add Friend CTA */}
      <div className="flex justify-between items-center border-b border-neutral-800 pb-4">
        <div>
          <span className="text-[10px] font-mono text-neutral-500 uppercase tracking-widest">SOCIAL SYNASTRY</span>
          <h2 className="text-3xl font-serif uppercase tracking-wider text-white">Friends & Match</h2>
        </div>
        
        <button
          onClick={() => setShowAddModal(true)}
          className="btn-costar-primary py-2 px-3 text-xs flex items-center gap-1.5"
        >
          <UserPlus className="w-3.5 h-3.5" />
          <span>Add Friend</span>
        </button>
      </div>

      {/* Friends Horizontal Carousel */}
      <div className="space-y-2">
        <div className="text-[10px] font-mono text-neutral-500 uppercase tracking-widest">SELECT FRIEND TO COMPARE</div>
        
        <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-none">
          {friends.map((friend) => {
            const isSelected = selectedFriend?.id === friend.id;
            return (
              <div
                key={friend.id}
                onClick={() => setSelectedFriend(friend)}
                className={`flex-shrink-0 cursor-pointer p-3 border text-xs font-mono w-32 space-y-1 transition-all ${
                  isSelected
                    ? 'border-white bg-neutral-900 text-white'
                    : 'border-neutral-800 bg-neutral-950 text-neutral-400 hover:border-neutral-700'
                }`}
              >
                <div className="font-bold truncate text-white">{friend.name}</div>
                <div className="text-[10px] text-neutral-400">
                  {ZODIAC_SYMBOLS[friend.sunSign]} {friend.sunSign}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Synastry & Compatibility Main Section */}
      {selectedFriend && activeCompat && (
        <div className="space-y-6">
          
          {/* Header Card: Score & Names */}
          <div className="costar-card bg-neutral-950 border-neutral-800 text-center space-y-4">
            <div className="text-[10px] font-mono text-neutral-500 uppercase tracking-widest">
              COSMIC SYNASTRY MATCH
            </div>

            <div className="flex justify-around items-center font-serif">
              <div>
                <div className="text-xl text-white">YOU</div>
                <div className="text-xs font-mono text-neutral-400">{userChart.sunSign}</div>
              </div>
              <div className="text-2xl text-neutral-500 font-sans">×</div>
              <div>
                <div className="text-xl text-white uppercase">{selectedFriend.name}</div>
                <div className="text-xs font-mono text-neutral-400">{selectedFriend.sunSign}</div>
              </div>
            </div>

            <div className="py-2 border-y border-neutral-900">
              <div className="text-5xl font-serif text-white tracking-tight">{activeCompat.overallScore}%</div>
              <div className="text-[10px] font-mono text-neutral-400 uppercase tracking-widest mt-1">
                COMPATIBILITY INDEX
              </div>
            </div>

            <p className="text-xs font-sans text-neutral-300 italic max-w-xs mx-auto leading-relaxed">
              "{activeCompat.connectionSummary}"
            </p>
          </div>

          {/* Compatibility Categories */}
          <div className="costar-card bg-neutral-950 space-y-3 font-mono text-xs">
            <div className="text-neutral-400 uppercase text-[10px] tracking-widest border-b border-neutral-900 pb-2">
              CATEGORY BREAKDOWN
            </div>

            <div className="space-y-2.5">
              <div>
                <div className="flex justify-between text-neutral-400 mb-1">
                  <span>COMMUNICATION</span>
                  <span className="text-white">{activeCompat.communicationScore}%</span>
                </div>
                <div className="w-full bg-neutral-900 h-1.5">
                  <div className="bg-white h-1.5" style={{ width: `${activeCompat.communicationScore}%` }} />
                </div>
              </div>

              <div>
                <div className="flex justify-between text-neutral-400 mb-1">
                  <span>ROMANCE & PASSION</span>
                  <span className="text-white">{activeCompat.romanceScore}%</span>
                </div>
                <div className="w-full bg-neutral-900 h-1.5">
                  <div className="bg-white h-1.5" style={{ width: `${activeCompat.romanceScore}%` }} />
                </div>
              </div>

              <div>
                <div className="flex justify-between text-neutral-400 mb-1">
                  <span>FRIENDSHIP & TRUST</span>
                  <span className="text-white">{activeCompat.friendshipScore}%</span>
                </div>
                <div className="w-full bg-neutral-900 h-1.5">
                  <div className="bg-white h-1.5" style={{ width: `${activeCompat.friendshipScore}%` }} />
                </div>
              </div>

              <div>
                <div className="flex justify-between text-neutral-400 mb-1">
                  <span>EMOTIONAL SAFETY</span>
                  <span className="text-white">{activeCompat.emotionalScore}%</span>
                </div>
                <div className="w-full bg-neutral-900 h-1.5">
                  <div className="bg-white h-1.5" style={{ width: `${activeCompat.emotionalScore}%` }} />
                </div>
              </div>

              <div>
                <div className="flex justify-between text-neutral-400 mb-1">
                  <span>CREATIVE SYNERGY</span>
                  <span className="text-white">{activeCompat.creativityScore}%</span>
                </div>
                <div className="w-full bg-neutral-900 h-1.5">
                  <div className="bg-white h-1.5" style={{ width: `${activeCompat.creativityScore}%` }} />
                </div>
              </div>
            </div>
          </div>

          {/* EROS Feature (Co-Star signature relationship dynamics) */}
          <div className="costar-card bg-neutral-900 border-neutral-700 space-y-4">
            <div className="flex items-center justify-between border-b border-neutral-800 pb-2">
              <div className="flex items-center gap-2">
                <Flame className="w-4 h-4 text-white" />
                <span className="text-xs font-mono uppercase text-white font-bold tracking-wider">
                  EROS RELATIONSHIP DYNAMICS
                </span>
              </div>
              <span className="text-[10px] font-mono text-neutral-400 border border-neutral-700 px-1.5 py-0.5 uppercase">
                FEATURED
              </span>
            </div>

            <div className="space-y-3 font-sans text-xs">
              <div>
                <h4 className="font-mono text-white text-[10px] uppercase mb-1">TODAY'S PARTNER DYNAMIC</h4>
                <p className="text-neutral-300 italic border-l border-white pl-2">
                  "{activeCompat.erosInsight}"
                </p>
              </div>

              <div>
                <h4 className="font-mono text-white text-[10px] uppercase mb-1">MAGNETIC ATTRACTION</h4>
                <p className="text-neutral-400 leading-relaxed">{activeCompat.attraction}</p>
              </div>

              <div>
                <h4 className="font-mono text-white text-[10px] uppercase mb-1">POTENTIAL FRICTION</h4>
                <p className="text-neutral-400 leading-relaxed">{activeCompat.conflict}</p>
              </div>
            </div>

            <button
              onClick={onOpenPaywall}
              className="w-full btn-costar-secondary text-xs flex items-center justify-center gap-1.5"
            >
              <Sparkles className="w-3.5 h-3.5" />
              <span>Unlock Full Deep Synastry Report</span>
            </button>
          </div>

        </div>
      )}

      {/* ADD FRIEND MODAL */}
      {showAddModal && (
        <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-end sm:items-center justify-center p-4">
          <div className="bg-neutral-950 border border-neutral-800 max-w-md w-full p-6 space-y-6 text-white font-sans animate-slide-up">
            <div className="flex justify-between items-start border-b border-neutral-800 pb-4">
              <div>
                <span className="text-xs font-mono text-neutral-500 uppercase">EXPAND YOUR COSMOS</span>
                <h3 className="text-2xl font-serif uppercase tracking-wide mt-1">Add a Friend</h3>
              </div>
              <button
                onClick={() => setShowAddModal(false)}
                className="text-neutral-400 hover:text-white text-xl font-mono"
              >
                ✕
              </button>
            </div>

            {/* Modal Tabs */}
            <div className="flex border-b border-neutral-800 text-xs font-mono">
              <button
                onClick={() => setAddTab('manual')}
                className={`py-2 px-3 border-b-2 uppercase ${addTab === 'manual' ? 'border-white text-white font-bold' : 'border-transparent text-neutral-500'}`}
              >
                Enter Details
              </button>
              <button
                onClick={() => setAddTab('username')}
                className={`py-2 px-3 border-b-2 uppercase ${addTab === 'username' ? 'border-white text-white font-bold' : 'border-transparent text-neutral-500'}`}
              >
                Username
              </button>
              <button
                onClick={() => setAddTab('link')}
                className={`py-2 px-3 border-b-2 uppercase ${addTab === 'link' ? 'border-white text-white font-bold' : 'border-transparent text-neutral-500'}`}
              >
                Invite Link
              </button>
            </div>

            {/* MANUAL ENTRY TAB */}
            {addTab === 'manual' && (
              <div className="space-y-4 font-mono text-xs">
                <p className="text-neutral-400 font-sans text-xs">
                  Compare chart compatibility even if your friend doesn't have the app installed.
                </p>

                <div>
                  <label className="text-neutral-500 uppercase text-[10px] block mb-1">Friend's Name</label>
                  <input
                    type="text"
                    value={manualName}
                    onChange={(e) => setManualName(e.target.value)}
                    placeholder="e.g. Sarah"
                    className="w-full bg-neutral-900 border border-neutral-800 p-2.5 text-white outline-none focus:border-white"
                  />
                </div>

                <div>
                  <label className="text-neutral-500 uppercase text-[10px] block mb-1">Birth Date</label>
                  <input
                    type="date"
                    value={manualDob}
                    onChange={(e) => setManualDob(e.target.value)}
                    className="w-full bg-neutral-900 border border-neutral-800 p-2.5 text-white outline-none"
                  />
                </div>

                <div>
                  <label className="text-neutral-500 uppercase text-[10px] block mb-1">Birth Time</label>
                  <input
                    type="time"
                    value={manualTime}
                    onChange={(e) => setManualTime(e.target.value)}
                    className="w-full bg-neutral-900 border border-neutral-800 p-2.5 text-white outline-none"
                  />
                </div>

                <button
                  disabled={!manualName.trim()}
                  onClick={handleCreateManualFriend}
                  className="w-full btn-costar-primary disabled:opacity-40"
                >
                  Generate Compatibility
                </button>
              </div>
            )}

            {/* USERNAME SEARCH TAB */}
            {addTab === 'username' && (
              <div className="space-y-4 font-mono text-xs">
                <input
                  type="text"
                  placeholder="@username"
                  className="w-full bg-neutral-900 border border-neutral-800 p-2.5 text-white outline-none focus:border-white"
                />
                <button
                  onClick={() => setShowAddModal(false)}
                  className="w-full btn-costar-primary"
                >
                  Search Username
                </button>
              </div>
            )}

            {/* INVITE LINK TAB */}
            {addTab === 'link' && (
              <div className="space-y-4 font-mono text-xs text-center">
                <p className="text-neutral-400 font-sans text-xs">
                  Share your unique cosmic invitation link with friends on WhatsApp, Instagram, or iMessage.
                </p>
                <div className="bg-neutral-900 p-3 border border-neutral-800 text-white font-mono text-[10px] select-all">
                  https://costar.app/invite/ref_98124
                </div>
                <button
                  onClick={() => {
                    navigator.clipboard.writeText('https://costar.app/invite/ref_98124');
                    alert('Invite link copied to clipboard!');
                    setShowAddModal(false);
                  }}
                  className="w-full btn-costar-primary flex items-center justify-center gap-2"
                >
                  <Share2 className="w-4 h-4" />
                  <span>Copy Link</span>
                </button>
              </div>
            )}

          </div>
        </div>
      )}

    </div>
  );
};
