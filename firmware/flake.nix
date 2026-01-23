{
	description = "Spaceblimp firmware";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.11-small";
		rustnix = {
			url = "github:nix-community/fenix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs =
		{
			self,
			nixpkgs,
			rustnix,
		}:
		let
			pkgs = import nixpkgs { system = "x86_64-linux"; };
			rustPlatform = pkgs.rustPlatform;
		in
		let
			devshell = pkgs.mkShell {
				buildInputs = [
					(rustnix.packages.x86_64-linux.fromToolchainFile {
						file = ./rust-toolchain.toml;
						sha256 = "sha256-cQl292Ia+Crg9ps29Pv5ciufXd0b/HF7770/bOEDv+k=";
					})
				];
			};

		in
		{
			devShells.x86_64-linux.default = devshell;

			packages.x86_64-linux.default = devshell;
		};
}
