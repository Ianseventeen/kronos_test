import { createBrowserRouter, Navigate } from "react-router";
import { Layout } from "./components/Layout";
import { Home } from "./components/Home";
import { Timer } from "./components/Timer";
import { History } from "./components/History";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Layout,
    children: [
      { index: true, element: <Navigate to="/home" replace /> },
      { path: "home", Component: Home },
      { path: "timer", Component: Timer },
      { path: "history", Component: History },
      { path: "settings", element: <div className="flex h-full items-center justify-center text-[#B0AECF]">Settings (WIP)</div> },
    ],
  },
]);