{
  description = "Spaceblimp firmware";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11-small";
    # This input uses the commit from this PR:
    # https://github.com/NixOS/nixpkgs/pull/477552
    #
    # After that PR merges, we can switch to using the latest version
    # of nixpkgs
    nixpkgs-tmp.url = "git+https://github.com/NixOS/nixpkgs?rev=e3d47242b5a84a6e87316874d1e00888ff69993b";
  };

  outputs =
    { self, nixpkgs, nixpkgs-tmp }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      pkgs-tmp = import nixpkgs-tmp { system = "x86_64-linux"; };
    in
    let
      devshell = pkgs.mkShell {
        buildInputs = [
          pkgs.rustup
          pkgs.espflash
          pkgs-tmp.espup
        ];
        shellHook = ''
          if ! [ -f espidf.sh ]; then
            echo "Installing dependencies using rustup; this might take a while..."
            # The purpose of `--log-level warn` is to hide the info log message
            # where `espup` tells the user to `source espidf.sh`.
            if ! espup install -f espidf.sh -t all --log-level warn; then
              echo "ERROR: Failed to install dependencies"
              exit 1
            fi
          fi
          if ! source espidf.sh; then
            echo "ERROR: The espidf.sh script failed"
            exit 1
          fi
        '';
      };
    in
    {
      devShells.x86_64-linux.default = devshell;

      # TODO: actually build our project
      packages.x86_64-linux.default = devshell;
    };
}
