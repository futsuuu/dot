import { path } from "./dot/deps/std.ts";

const env = Deno.env.get;

export const HOME_DIR = env("HOME") || env("USERPROFILE");
export const CONFIG_DIR = env("XDG_CONFIG_HOME") ||
  (HOME_DIR ? path.join(HOME_DIR, ".config") : "/etc");
export const APPDATA = env("APPDATA") || CONFIG_DIR;
export const LOCALAPPDATA = env("LOCALAPPDATA") || CONFIG_DIR;
