import { fs, ini, path, toml, yaml } from "./dot/deps/std.ts";

import { $ } from "./dot/deps/utils.ts";

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
    super(Deno.makeTempFileSync(), ini.stringify(unit));
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
