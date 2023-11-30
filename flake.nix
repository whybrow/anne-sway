{
  description = "Sway (window manager) configured for Anne";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rofi.url = "github:marcuswhybrow/rofi";
    volume.url = "github:marcuswhybrow/volume";
    brightness.url = "github:marcuswhybrow/brightness";
    waybar.url = "github:marcuswhybrow/waybar";
  };

  outputs = inputs: let 
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    assets = pkgs.stdenv.mkDerivation {
      name = "sway-assets";
      version = "unstable";
      src = ./assets;
      installPhase = ''
        mkdir --parents $out
        cp --recursive * $out
      '';
    };
    configText = import ./config.nix { inherit pkgs assets inputs; };
    config = pkgs.writeText "sway-config" configText;
    wrapper = pkgs.runCommand "sway-wrapper" {
      nativeBuildInputs = [ pkgs.makeWrapper ];
    } ''
      mkdir --parents $out/share/sway
      ln --symbolic ${config} $out/share/sway/config
      ln --symbolic ${assets} $out/share/sway/assets

      mkdir --parents $out/bin
      makeWrapper ${pkgs.sway}/bin/sway $out/bin/sway \
        --add-flags "--config $out/share/sway/config"
    '';
  in {
    packages.x86_64-linux.sway = pkgs.symlinkJoin {
      name = "sway";
      paths = [ wrapper pkgs.sway ]; # first ./bin/sway has precedence
    };

    packages.x86_64-linux.default = inputs.self.packages.x86_64-linux.sway;
  };
}
