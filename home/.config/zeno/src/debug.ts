// import { expect } from "@std/expect";
import { getSettings } from "@yuki-yano/zeno";

Deno.test(async function debug() {
  console.log(await getSettings());
});
