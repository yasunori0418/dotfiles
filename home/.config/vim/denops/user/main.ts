import type {
  Denops,
  Entrypoint,
} from "https://deno.land/x/denops_std@v6.5.1/mod.ts";

export const main: Entrypoint = (denops: Denops) => {
  denops.dispatcher = {};
};
