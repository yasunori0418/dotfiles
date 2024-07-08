import * as k from "karabiner_ts";
import { toHideApp } from "./utils.ts";
import {
  AppleBuiltInKeyboard,
  appleBuiltInKeyboardKeyCodes,
  HHKBProfessionalHybridTypeS,
  KeychronK8,
} from "./devices.ts";

k.writeToProfile("Default", [
  disableBuiltInKeyboard(),
  swapCapsLockToCtrl(),
  startupWezterm(),
]);

function swapCapsLockToCtrl() {
  return k.rule("swapping caps_lock and left_control")
    .condition(k.ifDevice([AppleBuiltInKeyboard, KeychronK8]))
    .manipulators([
      k.map("caps_lock").to("left_control"),
      k.map("left_control").to("caps_lock"),
      k.map({ key_code: "caps_lock", modifiers: { mandatory: ["left_shift"] } })
        .toNone(),
    ]);
}

function disableBuiltInKeyboard() {
  const disableMappingRules = appleBuiltInKeyboardKeyCodes.map((keyCode) => {
    return k.map(keyCode).toNone();
  });
  return k.rule(
    "disable built in apple keyboard when connection another keyboards.",
  )
    .condition(
      k.ifDevice(AppleBuiltInKeyboard),
      k.ifDeviceExists([KeychronK8, HHKBProfessionalHybridTypeS]),
    ).manipulators(disableMappingRules);
}

function startupWezterm() {
  const hideOrStartWezterm = k.withMapper(
    [
      toHideApp("WezTerm"),
      k.toApp("WezTerm"),
    ] as const,
  );
  const weztermStarter = hideOrStartWezterm((event, i) =>
    k.withCondition(
      ...[k.ifApp("wezterm")].map((c) => i === 0 ? c : c.unless()),
    )([
      k.map({
        key_code: "comma",
        modifiers: { mandatory: ["control"] },
      }).to(event),
      //i3 like
      //k.map({
      //  key_code: "return_or_enter",
      //  modifiers: { mandatory: ["command"] }
      //})
    ])
  );
  return k.rule("toggle wezterm by Command+return").manipulators([
    weztermStarter,
  ]);
}
