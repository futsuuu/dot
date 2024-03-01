import { Config, Text } from "../config.ts";

const curl: Config = {
  files: () => [
    new Text(
      [
        Deno.env.get("HOME") || Deno.env.get("USERPROFILE") as string,
        ".curlrc",
      ],
      ["show-error", 'referer = ";auto"', 'write-out = "\\n"'].join("\n"),
    ),
  ],
};

export default curl;
