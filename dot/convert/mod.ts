import * as std from "../deps/std.ts";

export const toml = std.toml.stringify;
export const yaml = std.yaml.stringify;

export function flag(obj: { [key: string]: string | string[] }): string {
  let result = "";
  for (const [key, value] of Object.entries(obj)) {
    result += "--" + key.replaceAll("_", "-") + "=";
    if (typeof value == "string") {
      result += value;
    } else {
      result += value.join(",");
    }
    result += "\n";
  }
  return result;
}
