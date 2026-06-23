{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      buildLib = pkgs.callPackage ./build { };

      linuxConfigs = pkgs.callPackage ./configs/kernel.nix {
        enableBPF = false;
        enableRust = false;
        enableKdf = false;
      };

      inherit (linuxConfigs) kernelArgs kernelConfig;

      configModule = buildLib.buildKernelConfigModule {
        inherit (kernelConfig)
          structuredExtraConfig
          ;
        inherit nixpkgs;
      };

      # Config file derivation
      configfile = buildLib.buildKernelConfig {
        inherit (kernelConfig)
          generateConfigFlags
          ;
        inherit configModule kernel nixpkgs;
      };

      # Kernel derivation.
      kernelDrv = buildLib.buildKernel {
        inherit (kernelArgs)
          src
          modDirVersion
          version
          kernelPatches
          ;

        inherit configModule configfile nixpkgs;
      };

      linuxDev = pkgs.linuxPackagesFor kernelDrv;
      kernel = linuxDev.kernel;

      buildCModule = buildLib.buildCModule {
        inherit kernel;
      };

      myNetworkDriver = buildCModule {
        name = "my-network-driver";
        src = ./modules/helloworld;
      }; 

      initramfs = buildLib.buildInitramfs {
        inherit kernel;
        modules = [myNetworkDriver];

        extraBin = {
          strace = "${pkgs.strace}/bin/strace";
        };

        storePaths = [
          pkgs.foot.terminfo
        ];
      };

      runQemu = buildLib.buildQemuCmd { inherit kernel initramfs; };
      runGdb = buildLib.buildGdbCmd { inherit kernel; modules = [ myNetworkDriver ]; };

      devShell =
        let
          nativeBuildInputs =
            with pkgs;
            [
              bear
              git
              gdb
              qemu
              pahole
              just
              runQemu
              runGdb
            ];

          buildInputs = [ ];
        in
        pkgs.mkShell {
          inherit buildInputs nativeBuildInputs;
          KERNEL = kernel.dev;
          KERNEL_VERSION = kernel.modDirVersion;
          KERNEL_IMG_DIR = kernel;
        };
    in
    {
      lib = {
        builders = import ./build/default.nix;
      };

      packages.${system} = {
        inherit
          initramfs
          kernelDrv
          kernel
          myNetworkDriver
          runGdb
          runQemu
          ;
        kernelConfig = configfile;
      };

      devShells.${system}.default = devShell;
    };
}
