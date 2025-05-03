import type { Denops, Entrypoint } from "jsr:@denops/core@^7.0.1";
import { is, ensure } from "jsr:@core/unknownutil@^4.3.0";

export const main: Entrypoint = (denops: Denops) => {
  denops.dispatcher = {
    async hello(mes: unknown) {
      const messages = ensure(mes, is.String);
      await denops.cmd('echo "Hello Denops! mes:" messages', {
        messages,
      });
    },
  };
};
