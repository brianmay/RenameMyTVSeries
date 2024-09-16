{
  description = "zoiper5 package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = {
    self,
    nixpkgs,
  }: {
    packages.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      src = pkgs.fetchurl {
        url = "https://www.tweaking4all.com/downloads/video/RenameMyTVSeries-2.0.10-Linux64bit.tar.gz";
        sha256 = "sha256-PlSkIKtWJHDZ0JIG2NU1H5o3dpkhvf9FOCefgwYfa6E=";
      };
      pkg = pkgs.stdenv.mkDerivation {
        pname = "RenameMyTVSeries";
        version = "2.0.10";

        src = src;

        nativeBuildInputs = [pkgs.autoPatchelfHook];

        buildInputs = [
          pkgs.atk
          pkgs.cairo
          pkgs.gtk2
          pkgs.libnotify
          pkgs.pango
          pkgs.sqlite
          pkgs.openssl
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
        '';

        meta = {
          description = "A tool to rename tv series episodes";
          homepage = "https://www.tweaking4all.com/home-theatre/rename-my-tv-series-v2/";
          # license = licenses.unfree;
          platforms = pkgs.lib.platforms.linux;
          architectures = ["x86"];
        };
      };
    in
      pkg;
  };
}
