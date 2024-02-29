import { flag } from "./convert/mod.ts";
import { fs, path } from "./deps/std.ts";
import { $ } from "./deps/utils.ts";

const configFile = await $`bat --config-file`.text();
await fs.ensureDir(path.dirname(configFile));

await Deno.writeTextFile(
  configFile,
  flag({
    theme: "TwoDark",
    style: ["numbers", "changes", "header"],
    color: "always",
  }),
);
