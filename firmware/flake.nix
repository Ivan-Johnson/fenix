{
	description = "Spaceblimp firmware";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.11-small";
		fenix = {
			url = "github:nix-community/fenix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs =
		{
			self,
			nixpkgs,
			fenix,
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
		{
			devShells.x86_64-linux.default = pkgs.mkShell {
				buildInputs = [
					pkgs.arduino-cli
					pkgs.arduino-ide
					pkgs.avrdude
					pkgs.blender
					pkgs.pkgsCross.avr.buildPackages.gcc
					(pkgs.python3.withPackages (python-pkgs: with python-pkgs; [ pyserial ]))
					pkgs.minicom
					pkgs.ravedude
					(fenix.packages.x86_64-linux.fromToolchainFile {
						file = ./rust-toolchain.toml;
						# sha256 = "sha256-z8J/GH7znPPg9kKvPirKcBeXqHikj1M7KB+anwsDx0M=";
						sha256 = "sha256-cQl292Ia+Crg9ps29Pv5ciufXd0b/HF7770/bOEDv+k="; # aria 2025-12-29T23:52:57-05:00
					})
				];
				RAVEDUDE_PORT = "/dev/ttyACM0";
			};

			packages.x86_64-linux.default = pkgs.hello;
		};
}
