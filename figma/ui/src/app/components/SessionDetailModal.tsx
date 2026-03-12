import { X, Trash2, Clock, Calendar } from "lucide-react";

export function SessionDetailModal({ session, onClose }: { session: any; onClose: () => void }) {
  return (
    <>
      {/* Backdrop */}
      <div
        className="fixed inset-0 z-40 bg-black/50 transition-opacity backdrop-blur-sm"
        onClick={onClose}
      />

      {/* Bottom Sheet Content */}
      <div
        className="fixed bottom-0 left-0 z-50 w-full transform rounded-t-[28px] bg-[#1B1B2E] p-6 shadow-[0_-10px_40px_rgba(0,0,0,0.5)] transition-transform duration-300 sm:left-1/2 sm:-ml-[195px] sm:w-[390px]"
      >
        {/* Drag Handle */}
        <div className="mb-6 flex w-full justify-center">
          <div className="h-1 w-12 rounded-full bg-[#3A3A55]" />
        </div>

        {/* Header */}
        <div className="mb-8 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-[#2D2560]">
              <span className="text-xl font-bold text-[#9D93EF]">{session.subject.charAt(0)}</span>
            </div>
            <h2 className="text-[28px] font-semibold text-[#E8E8FF]">{session.subject}</h2>
          </div>
          <button
            onClick={onClose}
            className="rounded-full bg-[#212134] p-2 text-[#B0AECF] transition-colors hover:text-[#E8E8FF] focus:outline-none focus:ring-2 focus:ring-[#6C5CE7]/40"
          >
            <X size={20} />
          </button>
        </div>

        {/* Details List */}
        <div className="space-y-4">
          <div className="flex items-center justify-between rounded-xl bg-[#212134] p-4">
            <div className="flex items-center gap-3 text-[#B0AECF]">
              <Calendar size={18} />
              <span className="text-sm font-medium">Date</span>
            </div>
            <span className="text-sm font-semibold text-[#E8E8FF]">{session.date}</span>
          </div>

          <div className="flex items-center justify-between rounded-xl bg-[#212134] p-4">
            <div className="flex items-center gap-3 text-[#B0AECF]">
              <Clock size={18} />
              <span className="text-sm font-medium">Time</span>
            </div>
            <span className="font-['JetBrains_Mono'] text-sm text-[#E8E8FF]">
              {session.startTime} - {session.endTime}
            </span>
          </div>

          <div className="flex items-center justify-between rounded-xl bg-[#212134] p-4">
            <div className="flex items-center gap-3 text-[#B0AECF]">
              <Clock size={18} />
              <span className="text-sm font-medium">Duration</span>
            </div>
            <span className="rounded-md bg-[#003D33] px-2 py-1 font-['JetBrains_Mono'] text-sm font-medium text-[#33DDBB]">
              {session.duration}
            </span>
          </div>

          {/* Notes */}
          <div className="flex flex-col gap-2 rounded-xl bg-[#212134] p-4">
            <label className="text-[12px] font-medium text-[#B0AECF]">Notes</label>
            <textarea
              className="w-full resize-none bg-transparent text-sm text-[#E8E8FF] placeholder-[#3A3A55] focus:outline-none focus:ring-0"
              rows={3}
              defaultValue={session.notes || ""}
              placeholder="No notes for this session."
            />
          </div>
        </div>

        {/* Action Buttons */}
        <div className="mt-8 flex flex-col gap-3">
          <button className="flex w-full items-center justify-center gap-2 rounded-xl border border-[#3A3A55] py-4 text-[#FF4D6D] transition-colors hover:bg-[#FF4D6D]/10 focus:outline-none focus:ring-4 focus:ring-[#FF4D6D]/40">
            <Trash2 size={20} />
            <span className="font-semibold">Delete Session</span>
          </button>
        </div>
      </div>
    </>
  );
}