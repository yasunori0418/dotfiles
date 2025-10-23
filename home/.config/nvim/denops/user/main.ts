import {
  type Denops,
  echoerrCommand,
  ensure,
  type Entrypoint,
  is,
  TextLineStream,
} from "./deps.ts";

export const main: Entrypoint = (denops: Denops) => {
  denops.dispatcher = {
    async hello(mes: unknown) {
      const messages = ensure(mes, is.String);
      await denops.cmd('echo "Hello Denops! mes:" messages', {
        messages,
      });
    },
    async codex(prompt: unknown) {
      const messages = ensure(prompt, is.String);
      const { pipeOut, wait, finalize } = echoerrCommand(denops, "codex", {
        args: ["-q", messages, "--json"],
      });
      try {
        pipeOut.pipeThrough(new TextLineStream()).pipeTo(
          new WritableStream({
            write: (chunk) => {
              console.log(chunk)
            },
          }),
        );
      } finally {
        await wait;
        await finalize();
      }
    },
  };
};
