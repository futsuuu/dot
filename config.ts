import { fs, path, toml, yaml } from "./dot/deps/std.ts";

export interface Config {
  files: () => ConfigFile[] | Promise<ConfigFile[]>;
  enabled?: () => boolean | Promise<boolean>;
}

class ConfigFile {
  path: string;
  content: string;

  constructor(configPath: string | string[], content: string) {
    if (typeof configPath == "string") {
      this.path = configPath;
    } else {
      this.path = path.join(...configPath);
    }
    this.content = content;
  }

  async write() {
    await fs.ensureDir(path.dirname(this.path));
    await Deno.writeTextFile(this.path, this.content);
    console.log(this.path);
  }
}

export { ConfigFile as Text };

export class Toml extends ConfigFile {
  constructor(configPath: string | string[], obj: Record<string, unknown>) {
    super(configPath, toml.stringify(obj));
  }
}

export class Yaml extends ConfigFile {
  constructor(configPath: string | string[], obj: Record<string, unknown>) {
    super(configPath, yaml.stringify(obj));
  }
}

export class Flag extends ConfigFile {
  constructor(
    configPath: string | string[],
    obj: { [key: string]: string | string[] },
  ) {
    let content = "";
    for (const [key, value] of Object.entries(obj)) {
      content += "--" + key.replaceAll("_", "-") + "=";
      if (typeof value == "string") {
        content += value;
      } else {
        content += value.join(",");
      }
      content += "\n";
    }
    super(configPath, content);
  }
}
