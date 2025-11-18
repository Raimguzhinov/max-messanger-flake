{
  description = "MAX Messenger Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pname = "MAX";
        version = "25.11.2";

        src = pkgs.fetchurl {
          url = "https://trk.mail.ru/c/wj6ww9";
          sha256 = "sha256-2Zlv2//2kWn4w2iSQn4GOL/6s9LVy/Skwgfy0O2mUC8=";
          # nix store prefetch-file --hash-type sha256 https://trk.mail.ru/c/wj6ww9
        };

        appimageContents = pkgs.appimageTools.extractType2 {
          inherit pname version src;
        };

        maxPkg = pkgs.appimageTools.wrapType2 rec {
          inherit pname version src;

          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/${pname}.desktop \
              $out/share/applications/${pname}.desktop

            install -m 444 -D ${appimageContents}/${pname}.png \
              $out/share/icons/hicolor/512x512/apps/${pname}.png

            substituteInPlace $out/share/applications/${pname}.desktop \
              --replace 'Exec=AppRun' 'Exec=${pname}'
          '';

          meta = with pkgs.lib; {
            description = "Быстрое и лёгкое приложение для общения и решения повседневных задач.";
            homepage = "https://max.ru";
            downloadPage = "https://download.max.ru/#desktop";
            license = licenses.unfree;
            maintainers = [ ];
            platforms = [ "${system}" ];
          };
        };
      in
      {
        packages.default = maxPkg;

        apps.default = {
          type = "app";
          program = "${maxPkg}/bin/${pname}";
        };
      }
    );
}
