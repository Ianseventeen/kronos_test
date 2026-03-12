import { Outlet, NavLink, useLocation } from "react-router";
import { HomeIcon, TimerIcon, Clock, Settings } from "lucide-react";

export function Layout() {
  const location = useLocation();

  // Hide bottom nav if we are on the active timer screen (which will be a route state or specific path)
  // For simplicity, let's keep it visible or pass a context. We'll handle full screen in Timer.tsx itself via fixed overlay if active.

  return (
    <div className="flex h-screen w-full items-center justify-center bg-black/80 font-['Inter']">
      <div className="relative flex h-full w-full flex-col overflow-hidden bg-[#0C0C15] text-[#E8E8FF] shadow-2xl sm:h-[844px] sm:w-[390px] sm:rounded-[40px] sm:border-8 sm:border-gray-900">
        {/* Main Content Area */}
        <main className="flex-1 overflow-y-auto overflow-x-hidden pb-[88px]">
          <Outlet />
        </main>

        {/* Bottom Navigation */}
        <nav className="absolute bottom-0 w-full rounded-t-[24px] border-t border-[#3A3A55] bg-[#1B1B2E] pb-6 pt-4 sm:rounded-b-[32px]">
          <div className="flex items-center justify-around px-2">
            <NavItem to="/home" icon={<HomeIcon size={24} />} label="Home" />
            <NavItem to="/timer" icon={<TimerIcon size={24} />} label="Timer" />
            <NavItem to="/history" icon={<Clock size={24} />} label="History" />
            <NavItem to="/settings" icon={<Settings size={24} />} label="Settings" />
          </div>
        </nav>
      </div>
    </div>
  );
}

function NavItem({ to, icon, label }: { to: string; icon: React.ReactNode; label: string }) {
  return (
    <NavLink
      to={to}
      className={({ isActive }) =>
        `flex flex-col items-center gap-1 p-2 transition-colors ${
          isActive ? "text-[#9D93EF]" : "text-[#B0AECF] hover:text-[#E8E8FF]"
        }`
      }
    >
      {icon}
      <span className="text-[10px] font-medium">{label}</span>
    </NavLink>
  );
}