{
  time = {
    timeZone = "Asia/Tokyo";
    # NixOS 単独運用のため RTC は UTC。ローカル時刻だと起動直後に +9h ずれる
    hardwareClockInLocalTime = false;
  };
}
