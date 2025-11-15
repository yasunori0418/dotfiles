import { afterEach, beforeEach, describe, it } from "@std/testing/bdd";
import { expect } from "@std/expect";
import { existsSync } from "@std/fs";
import { join } from "@std/path";
import { findDirectories } from "./utils.ts";

describe("findDirectories", () => {
  const cwd = Deno.cwd();
  const testDir = join(cwd, "test_dir");

  beforeEach(() => {
    Deno.mkdirSync(testDir);
    Deno.chdir(cwd);
  });

  afterEach(() => {
    if (existsSync(testDir, { isDirectory: true })) {
      Deno.removeSync(testDir, { recursive: true });
    }
  });

  it("case 1", async () => {
    // given
    [
      join(testDir, "abc"),
      join(testDir, "def"),
      join(testDir, "vwxyz"),
      join(testDir, "ghi", "jkl"),
      join(testDir, "mno", "pqr", "stu"),
    ].forEach((path) => {
      Deno.mkdirSync(path, { recursive: true });
    });
    Deno.chdir(testDir);

    // when
    const result = await findDirectories(testDir);

    // then
    expect(result).toStrictEqual([
      "abc/",
      "def/",
      "ghi/",
      "ghi/jkl/",
      "mno/",
      "mno/pqr/",
      "mno/pqr/stu/",
      "vwxyz/",
    ]);
  });
  it.skip("case home directory", async () => {
    const homeDir = Deno.env.get("HOME") as string;
    Deno.chdir(homeDir);
    const result = await findDirectories(homeDir);
    console.log(homeDir, result);
  });
});
