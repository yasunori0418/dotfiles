// import { expect } from "@std/expect";
import { getSettings } from "@yuki-yano/zeno";

Deno.test("debug", async () => {
  console.log(await getSettings());
});
