import { useState } from "react";
import { Cloud, CloudUpload, FileWarning, Search, SearchX } from "lucide-react";
import { SessionDetailModal } from "./SessionDetailModal";

interface Session {
  id: string;
  subject: string;
  date: string;
  duration: string;
  isSynced: boolean;
  notes?: string;
  startTime: string;
  endTime: string;
}

const mockSessions: Session[] = [
  {
    id: "1",
    subject: "Flutter",
    date: "Today",
    startTime: "18:00",
    endTime: "19:20",
    duration: "1h 20m",
    isSynced: true,
    notes: "Worked on the new authentication flow. Fixed a bug with token refresh.",
  },
  {
    id: "2",
    subject: "Reading",
    date: "Today",
    startTime: "14:00",
    endTime: "14:45",
    duration: "45m",
    isSynced: true,
  },
  {
    id: "3",
    subject: "Math",
    date: "Yesterday",
    startTime: "09:00",
    endTime: "11:00",
    duration: "2h 00m",
    isSynced: false,
    notes: "Calculus practice problems.",
  },
];

const FILTERS = ["All", "This week", "Unsynced"];

export function History() {
  const [activeFilter, setActiveFilter] = useState("All");
  const [selectedSession, setSelectedSession] = useState<Session | null>(null);

  const filteredSessions = mockSessions.filter((session) => {
    if (activeFilter === "Unsynced") return !session.isSynced;
    return true; // Simple logic for demo
  });

  return (
    <div className="flex h-full flex-col px-6 pt-12">
      {/* Header */}
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-[28px] font-semibold text-[#E8E8FF]">Study History</h1>
      </div>

      {/* Filter Chips */}
      <div className="mb-8 flex gap-3 overflow-x-auto hide-scrollbar">
        {FILTERS.map((filter) => (
          <button
            key={filter}
            onClick={() => setActiveFilter(filter)}
            className={`whitespace-nowrap rounded-lg px-4 py-2 text-[12px] font-medium transition-colors ${
              activeFilter === filter
                ? "bg-[#6C5CE7] text-white"
                : "bg-[#212134] text-[#B0AECF] hover:bg-[#2D2560] hover:text-[#E8E8FF]"
            } focus:outline-none focus:ring-2 focus:ring-[#6C5CE7]/40`}
          >
            {filter}
          </button>
        ))}
      </div>

      {/* Session List */}
      <div className="flex-1 overflow-y-auto hide-scrollbar space-y-4 pb-24">
        {filteredSessions.length === 0 ? (
          <div className="flex h-full flex-col items-center justify-center text-center text-[#B0AECF]">
            <SearchX size={48} className="mb-4 text-[#3A3A55]" />
            <p className="text-base font-medium">No sessions found.</p>
            <p className="text-sm">Start your first one!</p>
          </div>
        ) : (
          filteredSessions.map((session) => (
            <div
              key={session.id}
              onClick={() => setSelectedSession(session)}
              className="flex cursor-pointer items-center justify-between rounded-2xl bg-[#1B1B2E] p-4 shadow-sm transition-transform active:scale-[0.98] hover:bg-[#212134] focus:outline-none focus:ring-2 focus:ring-[#6C5CE7]/40"
              tabIndex={0}
            >
              {/* Left: Avatar/Icon */}
              <div className="flex items-center gap-4">
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-[#2D2560]">
                  <span className="text-lg font-bold text-[#9D93EF]">{session.subject.charAt(0)}</span>
                </div>
                {/* Center: Details */}
                <div className="flex flex-col">
                  <span className="text-base font-bold text-[#E8E8FF]">{session.subject}</span>
                  <span className="text-[12px] text-[#B0AECF]">{session.date} • {session.startTime}</span>
                </div>
              </div>

              {/* Right: Duration & Sync Status */}
              <div className="flex items-center gap-3">
                <div className="rounded-md bg-[#003D33] px-2 py-1">
                  <span className="font-['JetBrains_Mono'] text-[12px] font-medium text-[#33DDBB]">
                    {session.duration}
                  </span>
                </div>
                {session.isSynced ? (
                  <Cloud size={16} className="text-[#33DDBB]" />
                ) : (
                  <CloudUpload size={16} className="text-[#FFAA00]" />
                )}
              </div>
            </div>
          ))
        )}
      </div>

      {/* Bottom Sheet Modal */}
      {selectedSession && (
        <SessionDetailModal
          session={selectedSession}
          onClose={() => setSelectedSession(null)}
        />
      )}
    </div>
  );
}