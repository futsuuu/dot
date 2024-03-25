import { Config, Text } from "../config.ts";
import { HOME_DIR } from "../path.ts";

const curl: Config = {
  enabled: () => !!HOME_DIR,
  files: () => [
    new Text(
      [HOME_DIR!, ".curlrc"],
      ["show-error", 'referer = ";auto"', 'write-out = "\\n"'].join("\n"),
    ),
  ],
};

export default curl;
