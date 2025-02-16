# zig-io-benchmark -- Benchmark for Zig std readers/writers
# Copyright (C) 2024 Archit Gupta <archit@accelbread.com>
# SPDX-License-Identifier: MIT-0

{
  description = "Benchmark for Zig std readers/writers.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flakelight-zig.url = "github:accelbread/flakelight-zig";
    zig-master-flake.url = "github:accelbread/zig-master-flake";
  };
  outputs = { flakelight-zig, zig-master-flake, ... }@inputs:
    flakelight-zig ./. {
      inherit inputs;
      withOverlays = [ zig-master-flake.overlays.override-zig ];
      license = "MIT-0";
      zigFlags = [ "--release" ];
    };
}
