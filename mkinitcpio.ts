export function generateConfig(conf: {
  modules: string[];
  binaries: string[];
  files: string[];
  hooks: string[];
  compression?: "zstd" | "gzip" | "bzip2" | "lzma" | "xz" | "lzop" | "lz4";
  compressionOptions?: string[];
  modulesDecompress?: boolean;
}) {
  let s = `\
MODULES=(${conf.modules.join(" ")})
BINARIES=(${conf.binaries.join(" ")})
FILES=(${conf.files.join(" ")})
HOOKS=(${conf.hooks.join(" ")})
`;
  if (conf.compression !== undefined) {
    s += `COMPRESSION="${conf.compression}"\n`;
  }
  if (conf.compressionOptions !== undefined) {
    s += `COMPRESSION_OPTIONS=(${conf.compressionOptions.join(" ")})\n`;
  }
  if (conf.modulesDecompress !== undefined) {
    s += `MODULES_DECOMPRESS="${conf.modulesDecompress ? "yes" : "no"}"\n`;
  }
  return s;
}

export type Preset = {
  kver?: string;
  config?: string;
  image?: string;
  uki?: string;
  cmdline?: string;
  splash?: string;
  kerneldest?: string;
  options?: string;
};

export function generatePreset({ all, presets }: {
  all: Omit<Preset, "image" | "uki" | "options">;
  presets: Record<string, Preset>;
}) {
  let s = "";
  for (const [key, val] of sortedEntries(all)) {
    s += `ALL_${key}=${val}\n`;
  }
  const sortedPresets = sortedEntries(presets);
  s += `PRESETS=(${sortedPresets.map(([k]) => k).join(" ")})\n`;
  for (const [presetName, preset] of sortedPresets) {
    for (const [key, val] of sortedEntries(preset)) {
      s += `${presetName}_${key}=${val}\n`;
    }
  }
  return s;
}

export function generateKernelParams(
  paramsList: Record<
    string,
    | true
    | string
    | Record<string, true | string>
  >[],
) {
  const ss = [];
  for (const params of paramsList) {
    for (const [key, val] of sortedEntries(params)) {
      if (val === true) {
        ss.push(key);
        continue;
      }
      if (typeof val === "string") {
        ss.push(`${key}=${val}`);
        continue;
      }
      for (const [childKey, childVal] of sortedEntries(val)) {
        if (childVal === true) {
          ss.push(childKey);
        } else {
          ss.push(`${key}.${childKey}=${childVal}`);
        }
      }
    }
  }
  return ss.join(" ");
}

function sortedEntries<T>(rec: { [s: string]: T }) {
  return Object.entries<T>(rec).sort(([a], [b]) => a.localeCompare(b));
}
