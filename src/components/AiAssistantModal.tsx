import React, { useState } from 'react';
import { NatalChart, ChatMessage } from '../types/astrology';
import { askAstrologyAI } from '../services/aiAssistantService';
import { Sparkles, Send, Bot, User } from 'lucide-react';

interface AiAssistantModalProps {
  chart: NatalChart;
  userName: string;
  onClose: () => void;
}

const SUGGESTED_QUESTIONS = [
  "Why do I struggle with relationships?",
  "What is my highest career calling?",
  "How will current planetary transits affect me?",
  "What does my Moon sign reveal about my emotions?"
];

export const AiAssistantModal: React.FC<AiAssistantModalProps> = ({ chart, userName, onClose }) => {
  const [messages, setMessages] = useState<ChatMessage[]>([
    {
      id: '1',
      sender: 'astrologer',
      text: `Greetings, ${userName}. I have analyzed your birth chart (${chart.sunSign} Sun, ${chart.moonSign} Moon, ${chart.risingSign} Rising). What aspect of your blueprint would you like to explore today?`,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    }
  ]);

  const [input, setInput] = useState<string>('');
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const handleSendMessage = async (textToSend?: string) => {
    const text = textToSend || input;
    if (!text.trim() || isLoading) return;

    const userMsg: ChatMessage = {
      id: Date.now().toString(),
      sender: 'user',
      text: text.trim(),
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    };

    setMessages((prev) => [...prev, userMsg]);
    if (!textToSend) setInput('');
    setIsLoading(true);

    try {
      const responseText = await askAstrologyAI(text, chart);
      const aiMsg: ChatMessage = {
        id: (Date.now() + 1).toString(),
        sender: 'astrologer',
        text: responseText,
        timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
      };
      setMessages((prev) => [...prev, aiMsg]);
    } catch (err) {
      console.error(err);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-end sm:items-center justify-center p-4">
      <div className="bg-neutral-950 border border-neutral-800 max-w-md w-full h-[85vh] flex flex-col justify-between p-6 text-white font-sans animate-slide-up">
        
        {/* Header */}
        <div className="flex justify-between items-start border-b border-neutral-800 pb-4">
          <div>
            <div className="flex items-center gap-2 text-xs font-mono text-neutral-400 uppercase">
              <Sparkles className="w-3.5 h-3.5 text-white" />
              <span>COSMIC AI ASTROLOGER</span>
            </div>
            <h3 className="text-2xl font-serif uppercase tracking-wide mt-1">Ask the Stars</h3>
          </div>
          <button
            onClick={onClose}
            className="text-neutral-400 hover:text-white text-xl font-mono"
          >
            ✕
          </button>
        </div>

        {/* Chat Messages */}
        <div className="flex-1 overflow-y-auto my-4 space-y-4 pr-1 font-sans text-xs">
          {messages.map((msg) => (
            <div
              key={msg.id}
              className={`flex gap-3 ${msg.sender === 'user' ? 'justify-end' : 'justify-start'}`}
            >
              {msg.sender === 'astrologer' && (
                <div className="w-7 h-7 rounded-full bg-neutral-900 border border-neutral-700 flex items-center justify-center font-serif text-sm flex-shrink-0">
                  ✶
                </div>
              )}

              <div
                className={`p-3 max-w-[80%] border space-y-1 ${
                  msg.sender === 'user'
                    ? 'bg-white text-black border-white font-medium'
                    : 'bg-neutral-900 text-neutral-200 border-neutral-800'
                }`}
              >
                <p className="leading-relaxed">{msg.text}</p>
                <div
                  className={`text-[9px] font-mono text-right ${
                    msg.sender === 'user' ? 'text-neutral-600' : 'text-neutral-500'
                  }`}
                >
                  {msg.timestamp}
                </div>
              </div>

              {msg.sender === 'user' && (
                <div className="w-7 h-7 rounded-full bg-white text-black flex items-center justify-center font-mono text-xs font-bold flex-shrink-0">
                  {userName.charAt(0).toUpperCase()}
                </div>
              )}
            </div>
          ))}

          {isLoading && (
            <div className="flex gap-3 justify-start animate-pulse">
              <div className="w-7 h-7 rounded-full bg-neutral-900 border border-neutral-700 flex items-center justify-center font-serif text-sm">
                ✶
              </div>
              <div className="p-3 bg-neutral-900 border border-neutral-800 text-neutral-400 font-mono text-xs">
                Consulting transits & ephemeris...
              </div>
            </div>
          )}
        </div>

        {/* Suggested Prompt Chips */}
        {messages.length <= 2 && (
          <div className="flex gap-2 overflow-x-auto pb-3 scrollbar-none font-mono text-[10px]">
            {SUGGESTED_QUESTIONS.map((q, idx) => (
              <button
                key={idx}
                onClick={() => handleSendMessage(q)}
                className="flex-shrink-0 bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 text-neutral-300 px-2.5 py-1.5 rounded-full text-left"
              >
                {q}
              </button>
            ))}
          </div>
        )}

        {/* Input Bar */}
        <div className="flex items-center gap-2 border-t border-neutral-800 pt-3">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleSendMessage()}
            placeholder="Ask anything about your natal chart..."
            className="flex-1 bg-neutral-900 border border-neutral-800 p-3 text-xs text-white outline-none focus:border-white font-sans"
          />
          <button
            disabled={!input.trim() || isLoading}
            onClick={() => handleSendMessage()}
            className="bg-white text-black p-3 hover:opacity-90 disabled:opacity-40 transition-opacity"
          >
            <Send className="w-4 h-4" />
          </button>
        </div>

      </div>
    </div>
  );
};
