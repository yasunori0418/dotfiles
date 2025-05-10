{ hostName, name, ... }:
{
  networking = {
    inherit hostName;
    computerName = "${hostName}-${name}";
  };
}
