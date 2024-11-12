import type { Denops, Entrypoint } from "jsr:@denops/core";

export const main: Entrypoint = (denops: Denops) => {
  denops.dispatcher = {};
};
