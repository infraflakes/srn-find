# Serein Find

Serein is a simple find wrapper with more self explanatory flags.

## Installation

### For NixOS/Home Manager Configurations

If you manage your system or user environment with NixOS or Home Manager flakes, you can add `srn-find` as an input to your configuration.

1.  **Add `srn-find` as an input in your `flake.nix`:**

    ```nix
    {
      description = "Your personal NixOS/Home Manager configuration";

      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        srn-find = {
          url = "github:infraflakes/srn-find";
          inputs.nixpkgs.follows = "nixpkgs";
        };
      };

      outputs = { self, nixpkgs, home-manager, srn-find, ... } @ inputs: {
        # ... your existing outputs
      };
    }
    ```

2.  **Install the CLI in your NixOS or Home Manager configuration:**

    The flake provides a `default` package.

    **Option A: Install System-Wide (NixOS Configuration)**

    ```nix
    # In your configuration.nix (or a NixOS module)
    { config, pkgs, lib, ... }:

    {
      environment.systemPackages = with pkgs; [
        # Reference it from the srn-find flake input
        inputs.srn-find.packages.${pkgs.stdenv.hostPlatform.system}.default

      ];

      # ... other system configurations
    }
    ```

    **Option B: Install via Home Manager (User-Specific)**

    ```nix
    # In your Home Manager configuration (e.g., ~/.config/home-manager/home.nix)
    { config, pkgs, ... }:

    {
      home.packages = [
        # Reference it from the srn-find flake input
        inputs.srn-find.packages.${pkgs.stdenv.hostPlatform.system}.default

      ];

      # ... other Home Manager options
    }
    ```

### Binary Distribution (For Non-Nix Users)

For users not using Nix, the CLI can be downloaded as a single executable binary.

1.  **Download the latest release:**
    Visit the [GitHub Releases page](https://github.com/infraflakes/srn-find/releases) and download the wanted binary.

2.  **Make the binary executable:**
    ```bash
    chmod +x sfind
    ```

3.  **Move the binary to your PATH (optional but recommended):**
    ```bash
    sudo mv sfind /usr/local/bin/
    ```

4. **Generate shell functions for the cli to work:**
    Add these to your shell config:

    Bash:
    ```
    eval "$(sfind init bash)"
    ```

    Zsh:
    ```
    eval "$(sfind init zsh)"
    ```

    Fish:
    ```
    sfind init fish | source
    ```

### Manual Installation (from source)

If you have a Go environment set up, you can build from source.

1.  **Clone the repo:**
    ```bash
    git clone https://github.com/infraflakes/srn-find
    cd srn-find
    ```

2.  **Build the binary:**
    The included `Makefile` provides an easy way to build the application:
    ```bash
    make build
    ```
    Alternatively, you can use the standard Go command:
    ```bash
    CGO_ENABLED=0 go build -o sfind .
    ```

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

