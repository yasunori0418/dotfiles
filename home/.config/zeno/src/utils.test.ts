import { afterEach, beforeEach, describe, it } from "@std/testing/bdd";
import { expect } from "@std/expect";
import { existsSync } from "@std/fs";
import { join } from "@std/path";
import { findDirectories, listGitHubRuns } from "./utils.ts";

describe("listGitHubRuns", () => {
  it("整形結果がタブ区切りの6列になる", () => {
    // given
    const json = JSON.stringify([
      {
        databaseId: 29154793817,
        status: "completed",
        conclusion: "success",
        workflowName: "Dependency Graph",
        headBranch: "main",
        displayTitle: "Graph Update: pip",
      },
    ]);

    // when
    const result = listGitHubRuns(json);

    // then
    expect(result).toStrictEqual([
      "29154793817\tcompleted\tsuccess\tDependency Graph\tmain\tGraph Update: pip",
    ]);
  });

  it("先頭列が databaseId になる（callbackFunction / --preview の前提）", () => {
    // given
    const json = JSON.stringify([
      {
        databaseId: 123,
        status: "completed",
        conclusion: "failure",
        workflowName: "CI",
        headBranch: "topic",
        displayTitle: "fix: something",
      },
    ]);

    // when
    const result = listGitHubRuns(json)[0].split("\t");

    // then
    expect(result[0]).toBe("123");
    expect(result).toHaveLength(6);
  });

  it("run が無いときは空配列を返す", () => {
    expect(listGitHubRuns("[]")).toStrictEqual([]);
  });

  it("実行中の run は conclusion が null でも空文字列の列になる", () => {
    // given: gh は実行中の run に conclusion: null を返す
    const json = JSON.stringify([
      {
        databaseId: 123,
        status: "in_progress",
        conclusion: null,
        workflowName: "CI",
        headBranch: "topic",
        displayTitle: "fix: something",
      },
    ]);

    // when
    const result = listGitHubRuns(json);

    // then: 列数を保ったまま空欄になる（"null" という文字列にはしない）
    expect(result).toStrictEqual([
      "123\tin_progress\t\tCI\ttopic\tfix: something",
    ]);
    expect(result[0].split("\t")).toHaveLength(6);
  });

  describe("JSON として解釈できない入力", () => {
    it("不正な JSON は SyntaxError を投げる", () => {
      expect(() => listGitHubRuns("not json")).toThrow(SyntaxError);
    });

    it("空文字列は SyntaxError を投げる", () => {
      expect(() => listGitHubRuns("")).toThrow(SyntaxError);
    });
  });

  describe("JSON だが期待した形式ではない入力", () => {
    it("null は TypeError を投げる", () => {
      expect(() => listGitHubRuns("null")).toThrow(TypeError);
    });

    it("配列でないときは TypeError を投げる", () => {
      expect(() => listGitHubRuns('{"databaseId":1}')).toThrow(TypeError);
    });

    it("要素が null のときは TypeError を投げる", () => {
      expect(() => listGitHubRuns("[null]")).toThrow(TypeError);
    });
  });

  describe("形式は合っているが内容が想定外の入力", () => {
    // 現状の実装はここを検証せず、壊れた行をそのまま fzf へ渡す。
    // 意図した挙動ではなく既知の弱点であり、変化を検知するために固定しておく。
    it("フィールドが欠けていても列数だけ保った行を返す（値は空欄）", () => {
      // when
      const result = listGitHubRuns('[{"databaseId":1}]');

      // then
      expect(result).toStrictEqual(["1\t\t\t\t\t"]);
      expect(result[0].split("\t")).toHaveLength(6);
    });

    it("未知のフィールドは無視する", () => {
      // given
      const json = JSON.stringify([
        {
          databaseId: 1,
          status: "completed",
          conclusion: "success",
          workflowName: "CI",
          headBranch: "main",
          displayTitle: "title",
          unknownField: "ignored",
        },
      ]);

      // then
      expect(listGitHubRuns(json)).toStrictEqual([
        "1\tcompleted\tsuccess\tCI\tmain\ttitle",
      ]);
    });

    it("値がオブジェクトのときは [object Object] になる（既知の弱点）", () => {
      // given
      const json = JSON.stringify([
        {
          databaseId: { nested: 1 },
          status: "completed",
          conclusion: "success",
          workflowName: "CI",
          headBranch: "main",
          displayTitle: "title",
        },
      ]);

      // then: 先頭列が databaseId でなくなるため callbackFunction が壊れる
      expect(listGitHubRuns(json)[0].split("\t")[0]).toBe("[object Object]");
    });

    it("値にタブが含まれると列がずれる（既知の弱点）", () => {
      // given: displayTitle にタブが入った run
      const json = JSON.stringify([
        {
          databaseId: 1,
          status: "completed",
          conclusion: "success",
          workflowName: "CI",
          headBranch: "main",
          displayTitle: "before\tafter",
        },
      ]);

      // then: 6列のはずが7列になる
      expect(listGitHubRuns(json)[0].split("\t")).toHaveLength(7);
    });
  });
});

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
