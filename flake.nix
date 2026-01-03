{
  description = "A supercharged cd wrapper with aliases and TUI.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        buildSfind = {
          src,
          version,
        }:
          pkgs.buildGoModule {
            pname = "sfind";
            inherit version src;
            vendorHash = "sha256-3LL9r3xDPFRSFz9T32h9gt3lkbctO5XntnClkpbJWOg="; # Update if source changes
            ldflags = [
              "-s"
              "-w"
              "-X main.version=${version}"
            ];
            nativeBuildInputs = [pkgs.installShellFiles];
            postInstall = ''
              mv $out/bin/srn-find $out/bin/sfind
            '';
            postFixup = ''
              installShellCompletion --fish ${src}/completions/sfind.fish
              installShellCompletion --zsh ${src}/completions/sfind.zsh
              installShellCompletion --bash ${src}/completions/sfind.bash
            '';
          };

        cleanedSource = pkgs.lib.cleanSourceWith {
          src = ./.;
          filter = path: type: let
            baseName = baseNameOf path;
          in
            baseName == ".version" || pkgs.lib.cleanSourceFilter path type;
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go
            golangci-lint
            cmake
            goreleaser
          ];
        };

        packages.default = buildSfind {
          src = cleanedSource;
          version = let
            versionFile = "${cleanedSource}/.version";
          in
            pkgs.lib.escapeShellArg (
              if builtins.pathExists versionFile
              then builtins.readFile versionFile
              else self.shortRev or "dev"
            );
        };

        apps.default = flake-utils.lib.mkApp {drv = self.packages.${system}.default;};
      }
    );
}
