import { Cloud, CloudUpload } from "lucide-react";
import { BarChart, Bar, ResponsiveContainer, Cell, XAxis } from "recharts";
import { Link } from "react-router";

const data = [
  { day: "M", mins: 120 },
  { day: "T", mins: 90 },
  { day: "W", mins: 180 },
  { day: "T", mins: 60 },
  { day: "F", mins: 222 }, // Today (3h 42m)
  { day: "S", mins: 0 },
  { day: "S", mins: 0 },
];

export function Home() {
  const isSynced = true; // Simulating synced state

  return (
    <div className="flex h-full flex-col px-6 pb-24 pt-12">
      {/* Header */}
      <div className="mb-8 flex items-center justify-between">
        <h1 className="text-[28px] font-semibold text-[#E8E8FF]">Good evening, Daniel</h1>
        <div
          className={`flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-medium ${
            isSynced ? "bg-[#003D33] text-[#33DDBB]" : "bg-[#FFAA00]/20 text-[#FFAA00]"
          }`}
        >
          {isSynced ? <Cloud size={14} strokeWidth={2.5} /> : <CloudUpload size={14} />}
          <span>{isSynced ? "Synced" : "Pending"}</span>
        </div>
      </div>

      {/* Hero Card */}
      <div className="mb-6 flex flex-col items-center justify-center rounded-2xl bg-[#1B1B2E] p-8 shadow-sm">
        <div className="relative flex h-40 w-40 items-center justify-center">
          {/* Background Ring */}
          <svg className="absolute h-full w-full rotate-[-90deg]" viewBox="0 0 100 100">
            <circle
              cx="50"
              cy="50"
              r="44"
              fill="transparent"
              stroke="#2D2560"
              strokeWidth="8"
            />
            {/* Progress Ring */}
            <circle
              cx="50"
              cy="50"
              r="44"
              fill="transparent"
              stroke="#6C5CE7"
              strokeWidth="8"
              strokeLinecap="round"
              strokeDasharray="276.46" // 2 * PI * 44
              strokeDashoffset={276.46 * (1 - 0.7)} // 70% complete
              className="transition-all duration-1000 ease-out"
            />
          </svg>
          <div className="flex flex-col items-center">
            <span className="text-sm font-medium text-[#B0AECF]">Today</span>
            <span className="font-['JetBrains_Mono'] text-3xl font-light text-[#E8E8FF]">
              3h 42m
            </span>
          </div>
        </div>
      </div>

      {/* Weekly Chart */}
      <div className="mb-8 flex-1 rounded-2xl bg-[#1B1B2E] p-6">
        <h2 className="mb-4 text-base font-medium text-[#E8E8FF]">This Week</h2>
        <div className="h-40 w-full">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data} margin={{ top: 0, right: 0, left: 0, bottom: 0 }}>
              <XAxis 
                dataKey="day" 
                axisLine={false} 
                tickLine={false} 
                tick={{ fill: '#B0AECF', fontSize: 12 }}
                dy={10}
              />
              <Bar dataKey="mins" radius={[4, 4, 4, 4]} barSize={24}>
                {data.map((entry, index) => (
                  <Cell
                    key={`cell-${index}`}
                    fill={index === 4 ? "#33DDBB" : "#2D2560"} // index 4 is Friday (Today)
                  />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Start Button */}
      <div className="mt-auto">
        <Link
          to="/timer"
          className="flex w-full items-center justify-center rounded-xl bg-[#6C5CE7] py-4 text-base font-semibold text-white shadow-lg shadow-[#6C5CE7]/20 transition-all hover:bg-[#9D93EF] focus:outline-none focus:ring-4 focus:ring-[#6C5CE7]/40"
        >
          Start a new session
        </Link>
      </div>
    </div>
  );
}