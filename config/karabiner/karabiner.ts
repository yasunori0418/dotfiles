import { condition, map, rule, writeToProfile } from "./deps.ts";
import {
  AppleBuiltInKeyboard,
  appleBuiltInKeyboardKeyCodes,
  HHKBProfessionalHybridTypeS,
  KeychronK8,
} from "./devices.ts";

writeToProfile("Test", [
  disableBuiltInKeyboard(),
  swapCapsLockToCtrl(),
]);

function swapCapsLockToCtrl() {
  return rule("swapping caps_lock and left_control")
    .condition(condition.ifDevice([AppleBuiltInKeyboard, KeychronK8]))
    .manipulators([
      map("caps_lock").to("left_control"),
      map("left_control").to("caps_lock"),
    ]);
}

function disableBuiltInKeyboard() {
  const disableMappingRules = appleBuiltInKeyboardKeyCodes.map((keyCode) => {
    return map(keyCode).toNone();
  });
  return rule(
    "disable built in apple keyboard when connection another keyboards.",
  )
    .condition(
      condition.ifDevice(AppleBuiltInKeyboard),
      condition.ifDeviceExists([KeychronK8, HHKBProfessionalHybridTypeS]),
    ).manipulators(disableMappingRules);
}
