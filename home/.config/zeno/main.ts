import { defineConfig } from "@yuki-yano/zeno";
import { define as completions } from "./src/completions.ts";
import { define as snippets } from "./src/snippets.ts";

export default defineConfig(() => {
  return { completions, snippets };
});
