import { flag } from "./convert/mod.ts";
import { path } from "./deps/std.ts";

const homeDir = Deno.env.get("HOME");
const configDir = homeDir ? path.join(homeDir, ".config") : "/etc";
const config = flag({
  enable_features: "WaylandWindowDecorations",
  ozone_platform_hint: "auto",
  gtk_version: "4",
});

for (
  const name of [
    "electron-flags.conf",
    "code-flags.conf",
    "vivaldi-stable.conf",
  ]
) {
  await Deno.writeTextFile(path.join(configDir, name), config);
}
