{
	description = "Spaceblimp firmware";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.11-small";
		rust-nix = {
			url = "github:nix-community/fenix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs =
		{
			self,
			nixpkgs,
			rust-nix,
		}:
		let
			pkgs = import nixpkgs { system = "x86_64-linux"; };
			rustPlatform = pkgs.rustPlatform;
			driver = rustPlatform.buildRustPackage {
				pname = "foo";

				version = "0.1.0";

				src = ./.;

				buildInputs = [ ];

				checkFlags = [ ];

				cargoLock.lockFile = ./Cargo.lock;
			};
		in
		let
			devshell = pkgs.mkShell {
				buildInputs = [
					pkgs.rustc
					pkgs.cargo
				];
			};

		in
		{
			devShells.x86_64-linux.default = devshell;

			packages.x86_64-linux.default = devshell;
		};
}
