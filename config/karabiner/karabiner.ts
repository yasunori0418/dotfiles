import * as k from "karabiner_ts";
import {
  AppleBuiltInKeyboard,
  appleBuiltInKeyboardKeyCodes,
  HHKBProfessionalHybridTypeS,
  KeychronK8,
} from "./devices.ts";

k.writeToProfile("Default", [
  disableBuiltInKeyboard(),
  swapCapsLockToCtrl(),
]);

function swapCapsLockToCtrl() {
  return k.rule("swapping caps_lock and left_control")
    .condition(k.ifDevice([AppleBuiltInKeyboard, KeychronK8]))
    .manipulators([
      k.map("caps_lock").to("left_control"),
      k.map("left_control").to("caps_lock"),
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
