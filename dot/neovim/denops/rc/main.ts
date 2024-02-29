import { path } from "../../../deps/std.ts";
import { Denops, nvimFn } from "../../../deps/denops.ts";
import { ensure, GzipStream, is } from "../../../deps/utils.ts";

export function main(denops: Denops) {
  denops.dispatcher = {
    async downloadJisyo() {
      const dataDir: string = ensure(
        await nvimFn.stdpath(denops, "data"),
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
