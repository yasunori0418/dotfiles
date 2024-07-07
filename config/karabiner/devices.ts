import {
  type ArrowKeyCode,
  arrowKeyCodes,
  type ControlOrSymbolKeyCode,
  controlOrSymbolKeyCodes,
  type DeviceIdentifier,
  type FunctionKeyCode,
  functionKeyCodes,
  type LetterKeyCode,
  letterKeyCodes,
  type ModifierKeyCode,
  modifierKeyCodes,
  type NumberKeyCode,
  numberKeyCodes,
  type PcKeyboardKeyCode,
  pcKeyboardKeyCodes,
} from "./deps.ts";

export const AppleBuiltInKeyboard: DeviceIdentifier = {
  vendor_id: 1452,
  product_id: 832,
  is_keyboard: true,
  is_built_in_keyboard: true,
};

export const appleBuiltInKeyboardKeyCodes: Array<
  | ArrowKeyCode
  | ControlOrSymbolKeyCode
  | FunctionKeyCode
  | LetterKeyCode
  | ModifierKeyCode
  | NumberKeyCode
  | PcKeyboardKeyCode
> = [
  ...arrowKeyCodes,
  ...controlOrSymbolKeyCodes,
  ...functionKeyCodes,
  ...letterKeyCodes,
  ...modifierKeyCodes,
  ...numberKeyCodes,
  ...pcKeyboardKeyCodes,
];

export const TouchBarUserDevice: DeviceIdentifier = {
  vendor_id: 1452,
  product_id: 34304,
  is_touch_bar: true,
};

export const KeychronK8: DeviceIdentifier = {
  vendor_id: 1452,
  product_id: 591,
  is_keyboard: true,
};

export const HHKBProfessionalHybridTypeS: DeviceIdentifier = {
  vendor_id: 1278,
  product_id: 33,
  is_keyboard: true,
};

export const KensingtonSlimBladePro: DeviceIdentifier = {
  vendor_id: 1149,
  product_id: 32982,
  is_pointing_device: true,
};
