import { ensureDir } from "std/fs";
import { stringify as ini } from "std/ini";
import * as path from "std/path";
import { stringify as toml } from "std/toml";
import { stringify as yaml } from "std/yaml";

import { $ } from "dax";

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
    await ensureDir(path.dirname(this.path));
    await Deno.writeTextFile(this.path, this.content);
    console.log(this.path);
  }
}

export { ConfigFile as Text };

export class Ini extends ConfigFile {
  constructor(configPath: string | string[], obj: Record<string, unknown>) {
    super(configPath, ini(obj));
  }
}

export class Toml extends ConfigFile {
  constructor(configPath: string | string[], obj: Record<string, unknown>) {
    super(configPath, toml(obj));
  }
}

export class Yaml extends ConfigFile {
  constructor(configPath: string | string[], obj: Record<string, unknown>) {
    super(configPath, yaml(obj));
  }
}

export class Git extends ConfigFile {
  constructor(
    configPath: string | string[],
    obj: Record<string, Record<string, string | string[]>>,
  ) {
    super(
      configPath,
      ini(obj, {
        // deno-lint-ignore no-explicit-any
        replacer: (key: string, value: any, _section?: string) => {
          if (!Array.isArray(value)) {
            return `"${value}"`;
          }
          let result = "";
          value.forEach((v, i) => {
            if (i === 0) {
              result += `"${v}"`;
            } else {
              result += `\n${key}="${v}"`;
            }
          });
          return result;
        },
      }),
    );
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

type SystemdService = {
  Unit: {
    Description?: string;
    Documentation?: string;
    After?: string;
    Before?: string;
    Requires?: string;
    Wants?: string;
    Conflicts?: string;
  };
  Service: {
    Type: "simple" | "forking" | "oneshot" | "dbus" | "notify" | "idle";
    ExecStart: string;
    ExecStop?: string;
    ExecReload?: string;
    Restart: "always" | "no" | "one-success" | "on-failure";
    RestartSec?: number;
  };
  Install: {
    WantedBy?: string;
    RequiredBy?: string;
  };
};

export class Systemd extends ConfigFile {
  name: string;

  constructor(name: string, unit: SystemdService) {
    super(Deno.makeTempFileSync(), ini(unit));
    this.name = name;
  }

  async write() {
    await Deno.writeTextFile(this.path, this.content);
    const unitFile = `/etc/systemd/system/${this.name}.service`;
    await $`sudo cp ${this.path} ${unitFile}`;
    await $`sudo systemctl daemon-reload`;
    await $`sudo systemctl enable --now ${this.name}.service`;
    console.log(unitFile);
  }
}
