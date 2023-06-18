{
  config,
  inputs,
  self,
  profiles,
  ...
}: let
  usr =
    if (config.modules.system.username == null)
    then "isabel"
    else "${config.modules.system.username}";
in {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs self profiles;
    };
    users = {
      # home directory for the user
      ${usr} = ../home/${usr};
    };
  };
}