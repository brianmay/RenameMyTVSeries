{
  description = "Rename My TV Series package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

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
            url = "https://www.tweaking4all.com/downloads/video/RenameMyTVSeries-2.3.12-GTK-Linux-x64-shared-ffmpeg.tar.xz";
            sha256 = "sha256-pESWXTju6HMdtZhr4gRvyIGrDnMW2XXKjFWdJy7B+4w=";
          };
          pkg = pkgs.stdenv.mkDerivation {
            pname = "RenameMyTVSeries";
            version = "2.3.12";

            src = src;

            nativeBuildInputs = [
              pkgs.autoPatchelfHook
              pkgs.makeWrapper
            ];

            buildInputs = [
              pkgs.gtk2
              pkgs.glib
              pkgs.gdk-pixbuf
              pkgs.pango
              pkgs.cairo
              pkgs.atk
              pkgs.sqlite
              pkgs.libnotify
              pkgs.libX11
              pkgs.openssl
              pkgs.ffmpeg_7
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
                --prefix PATH : "${lib.makeBinPath [ pkgs.ffmpeg_7 ]}"
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