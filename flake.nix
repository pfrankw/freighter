{
  description = "Nix flake to build a custom OS using Buildroot (with fetched Buildroot)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";

    # Fetch Buildroot from GitHub - you can pin a commit or branch
    buildroot-src = {
      url = "github:buildroot/buildroot/2025.02.x"; # <-- Replace with a commit or tag if needed
      flake = false; # Important: Buildroot is not a flake
    };
  };

  outputs = { self, nixpkgs, flake-utils, buildroot-src, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        buildrootDeps = with pkgs; [
          bc
          bison
          flex
          gawk
          gcc
          gnumake
          ncurses.dev
          pkg-config
          libxcrypt
          perl
          unzip
          wget
          which
          cpio
          file
          rsync
          python3
          patch
        ] ++ pkgs.linux.nativeBuildInputs;

        buildrootDir = "${buildroot-src}";
      in {
        devShells.default = (pkgs.buildFHSEnv {
          name = "buildroot-shell";
          targetPkgs = pkgs: buildrootDeps;

          profile = ''
            echo "🔧 Welcome to the Buildroot Dev Shell"
            echo "📁 Buildroot source is located at:"
            echo "   ${buildrootDir}"

            # Optional: symlink it into your current dir
            if [ ! -e ./buildroot ]; then
              ln -s ${buildrootDir} ./buildroot
              echo "🔗 Symlinked buildroot → ./buildroot"
            fi

            # Automatically set the O environment variable (build output directory)
            if [ -z "$O" ]; then
              export O="$(pwd)/output"
              echo "📁 Setting Buildroot output directory: $O"
            fi

            echo "✅ Ready to run: cd buildroot && make menuconfig"
          '';
        }).env;
      }
    );
}
