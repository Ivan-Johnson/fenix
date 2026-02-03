{
	description = "Spaceblimp firmware";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.11-small";
	};

	outputs =
		{ self, nixpkgs }:
		let
			pkgs = import nixpkgs { system = "x86_64-linux"; };
		in
		let
			devshell = pkgs.mkShell {
				buildInputs = [ pkgs.espup ];
				# shellHook = ''
				# 	echo TODO run commands from SETUP.md?
				# '';
			};

		in
		{
			devShells.x86_64-linux.default = devshell;

			packages.x86_64-linux.default = devshell;
		};
}
