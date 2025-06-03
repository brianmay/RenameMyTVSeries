{
  description = "Rename My TV Series package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs =
    {
      self,
      nixpkgs,
    }:
    {
      packages.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          lib = pkgs.lib;
          src = pkgs.fetchurl {
            url = "https://www.tweaking4all.com/downloads/betas/RenameMyTVSeries-2.1.8-QT5-beta-Linux-64bit-shared-ffmpeg.tar.gz";
            sha256 = "sha256-4QSP2lzilfeX8LcYUS+TNo0GR3260os4Xhe7OiZGFhM=";
            # sha256 = lib.fakeSha256;
          };
          pkg = pkgs.stdenv.mkDerivation {
            pname = "RenameMyTVSeries";
            version = "2.0.10";

            src = src;

            nativeBuildInputs = [
              pkgs.autoPatchelfHook
              pkgs.libsForQt5.wrapQtAppsHook
            ];

            buildInputs = [
              pkgs.atk
              pkgs.cairo
              pkgs.gtk2
              pkgs.libnotify
              pkgs.pango
              pkgs.sqlite
              pkgs.openssl
              pkgs.libqt5pas
            ];

            sourceRoot = ".";

            unpackPhase = ":";

            installPhase = ''
              mkdir -p "$out/opt"
              mkdir -p "$out/bin"
              tar -C "$out/opt" -xvf ${src}
              ln -s ../opt/RenameMyTVSeries "$out/bin"
            '';

            postFixup = ''
              patchelf --add-needed libcrypto.so "$out/opt/RenameMyTVSeries"
              wrapProgram $out/bin/RenameMyTVSeries \
                --prefix PATH : "${lib.makeBinPath [ pkgs.ffmpeg ]}"
            '';

            meta = {
              description = "A tool to rename tv series episodes";
              homepage = "https://www.tweaking4all.com/home-theatre/rename-my-tv-series-v2/";
              # license = licenses.unfree;
              platforms = pkgs.lib.platforms.linux;
              architectures = [ "x86" ];
            };
          };
        in
        pkg;
    };
}
