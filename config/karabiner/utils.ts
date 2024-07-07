import * as k from "karabiner_ts";
import { $ } from "@david/dax";

export function toHideApp(name: string) {
  return k.to$(
    `osascript -e 'tell application "System Events" to set visible of process "${name}" to false'`,
  );
}

/** Get the bundle identifier of the application by name.
 * Refer: https://github.com/ryoppippi/dotfiles/blob/main/karabiner/utils.ts#L11-L27
 */
export async function extractIdentifer(
  appName: string,
): Promise<string | undefined> {
  const appPath = $.path(`/Applications/${appName}.app`);

  if (!await appPath.exists()) {
    throw new Error(`Application ${appName} not found`);
  }

  /* output is like `kMDItemCFBundleIdentifier = "com.apple.Safari"` */
  const output = await $`mdls -name kMDItemCFBundleIdentifier ${appPath}`
    .text();

  /** output is like `com.apple.Safari` */
  const identifer = output.match(/"(.*)"/)?.[1];

  return identifer;
}
