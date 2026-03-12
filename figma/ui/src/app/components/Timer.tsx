import { useState, useEffect } from "react";
import { CloudOff, Play, Pause, Square } from "lucide-react";

const TAGS = ["Flutter", "English", "LLMs", "Math", "Reading"];

export function Timer() {
  const [isActive, setIsActive] = useState(false);
  const [isPaused, setIsPaused] = useState(false);
  const [subject, setSubject] = useState("");
  const [seconds, setSeconds] = useState(0);

  useEffect(() => {
    let interval: NodeJS.Timeout | null = null;
    if (isActive && !isPaused) {
      interval = setInterval(() => {
        setSeconds((s) => s + 1);
      }, 1000);
    } else if (interval) {
      clearInterval(interval);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [isActive, isPaused]);

  const handleStart = () => {
    if (!subject) setSubject("Untitled Session");
    setIsActive(true);
    setSeconds(0);
    setIsPaused(false);
  };

  const handlePause = () => setIsPaused(!isPaused);
  
  const handleFinish = () => {
    setIsActive(false);
    setSeconds(0);
    setSubject("");
  };

  const formatTime = (totalSeconds: number) => {
    const h = Math.floor(totalSeconds / 3600);
    const m = Math.floor((totalSeconds % 3600) / 60);
    const s = totalSeconds % 60;
    return `${h.toString().padStart(2, "0")}:${m.toString().padStart(2, "0")}:${s.toString().padStart(2, "0")}`;
  };

  if (isActive) {
    return (
      <div className="absolute inset-0 z-50 flex flex-col bg-[#0C0C15] px-6 pb-24 pt-16">
        {/* Status Bar Area */}
        <div className="absolute left-6 top-8 flex items-center text-[#FFAA00] opacity-80">
          <CloudOff size={18} />
          <span className="ml-2 text-xs font-medium">Offline</span>
        </div>

        {/* Header Content */}
        <div className="mt-16 flex flex-col items-center justify-center space-y-3">
          <span className="text-[28px] font-semibold text-[#9D93EF]">{subject}</span>
          <div className="flex items-center gap-2 rounded-full bg-[#003D33] px-3 py-1">
            <span className={`h-2 w-2 rounded-full bg-[#33DDBB] ${!isPaused ? 'animate-pulse' : ''}`} />
            <span className="text-xs font-bold tracking-wider text-[#33DDBB]">LIVE</span>
          </div>
        </div>

        {/* Timer Display */}
        <div className="flex flex-1 items-center justify-center">
          <span className="font-['JetBrains_Mono'] text-[57px] font-light tracking-tight text-[#E8E8FF]">
            {formatTime(seconds)}
          </span>
        </div>

        {/* Action Buttons */}
        <div className="flex w-full gap-4 px-4">
          <button
            onClick={handlePause}
            className="flex flex-1 items-center justify-center gap-2 rounded-xl border border-[#3A3A55] py-4 text-[#9D93EF] transition-all hover:bg-[#212134] focus:outline-none focus:ring-4 focus:ring-[#6C5CE7]/40"
          >
            {isPaused ? <Play size={20} /> : <Pause size={20} />}
            <span className="font-medium">{isPaused ? "Resume" : "Pause"}</span>
          </button>
          <button
            onClick={handleFinish}
            className="flex flex-1 items-center justify-center gap-2 rounded-xl bg-[#00C9A7] py-4 text-[#003D33] transition-all hover:bg-[#33DDBB] focus:outline-none focus:ring-4 focus:ring-[#00C9A7]/40"
          >
            <Square size={20} fill="currentColor" />
            <span className="font-semibold">Finish</span>
          </button>
        </div>

        {/* Notes (Collapsed) */}
        <div className="mt-8 px-4">
          <textarea
            placeholder="Add notes... (optional)"
            className="w-full resize-none rounded-xl bg-[#1B1B2E] p-4 text-sm text-[#E8E8FF] placeholder-[#B0AECF] focus:outline-none focus:ring-2 focus:ring-[#6C5CE7]/40"
            rows={1}
            onFocus={(e) => (e.target.rows = 4)}
            onBlur={(e) => {
              if (!e.target.value) e.target.rows = 1;
            }}
          />
        </div>
      </div>
    );
  }

  return (
    <div className="flex h-full flex-col px-6 pt-16">
      <h1 className="mb-8 text-[28px] font-semibold text-[#E8E8FF]">New Session</h1>

      {/* Input Field */}
      <div className="mb-6">
        <input
          type="text"
          value={subject}
          onChange={(e) => setSubject(e.target.value)}
          placeholder="What are you studying?"
          className="w-full rounded-xl border border-[#3A3A55] bg-[#1B1B2E] p-4 text-base text-[#E8E8FF] placeholder-[#B0AECF] focus:outline-none focus:ring-2 focus:ring-[#6C5CE7]/40"
        />
      </div>

      {/* Tag Suggestions */}
      <div className="mb-16 hide-scrollbar flex w-full overflow-x-auto">
        <div className="flex gap-3">
          {TAGS.map((tag) => (
            <button
              key={tag}
              onClick={() => setSubject(tag)}
              className="whitespace-nowrap rounded-lg bg-[#212134] px-4 py-2 text-[12px] font-medium text-[#B0AECF] transition-colors hover:bg-[#2D2560] hover:text-[#E8E8FF] focus:outline-none focus:ring-2 focus:ring-[#6C5CE7]/40"
            >
              {tag}
            </button>
          ))}
        </div>
      </div>

      {/* Big Start Button */}
      <div className="flex flex-1 items-center justify-center">
        <button
          onClick={handleStart}
          className="group relative flex h-20 w-20 items-center justify-center rounded-full bg-[#00C9A7] text-[#003D33] shadow-[0_0_32px_rgba(0,201,167,0.3)] transition-transform hover:scale-105 hover:bg-[#33DDBB] focus:outline-none focus:ring-4 focus:ring-[#00C9A7]/50"
        >
          <Play size={32} fill="currentColor" className="ml-1" />
        </button>
      </div>

      {/* Last Session Info */}
      <div className="mt-auto flex items-center justify-between rounded-xl bg-[#1B1B2E] p-4 text-sm">
        <div className="flex flex-col">
          <span className="text-[12px] font-medium text-[#B0AECF]">Last Session</span>
          <span className="font-semibold text-[#E8E8FF]">Flutter</span>
        </div>
        <span className="font-['JetBrains_Mono'] text-[#B0AECF]">1h 15m</span>
      </div>
    </div>
  );
}