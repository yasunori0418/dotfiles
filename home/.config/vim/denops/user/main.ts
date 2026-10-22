import type { Denops, Entrypoint } from "jsr:@denops/core@8.0.1";

export const main: Entrypoint = (denops: Denops) => {
  denops.dispatcher = {};
};
