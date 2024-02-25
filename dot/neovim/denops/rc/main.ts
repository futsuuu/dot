import * as path from "https://deno.land/std@0.217.0/path/mod.ts";

import type { Denops } from "https://deno.land/x/denops_std@v6.1.0/mod.ts";
import * as fn from "https://deno.land/x/denops_std@v6.1.0/function/nvim/mod.ts";
import { ensure, is } from "https://deno.land/x/unknownutil@v3.16.3/mod.ts";
import { GzipStream } from "https://deno.land/x/compress@v0.4.6/gzip/mod.ts";

export function main(denops: Denops) {
  denops.dispatcher = {
    async downloadJisyo() {
      const dataDir: string = ensure(
        await fn.stdpath(denops, "data"),
        is.String,
      );
      const compressed = path.join(dataDir, "SKK-JISYO.L.gz");
      const target = path.join(dataDir, "SKK-JISYO.L");

      const res = await fetch("https://skk-dev.github.io/dict/SKK-JISYO.L.gz");
      const blob = await res.blob();
      await Deno.writeFile(compressed, blob.stream());

      const gzip = new GzipStream();
      await gzip.uncompress(compressed, target);
      await notify(denops, "downloaded and extracted into SKK-JISYO.L");
    },
  };
}

async function notify(denops: Denops, msg: string) {
  await denops.call(
    "luaeval",
    "vim.notify(_A, nil, { group = 'denops', annote = 'denops' })",
    msg,
  );
}
