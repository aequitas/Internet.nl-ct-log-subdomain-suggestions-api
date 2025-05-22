{ pkgs ? import <nixpkgs> {}, ... }:
let
  # erlang = pkgs.beam.interpreters.erlangR24;
  # elixir = beamPackagesPrev.elixir_1_10;
  # beamPackagesPrev = (pkgs.beam.packagesWith erlang);
  # beamPackages = beamPackagesPrev // rec {
  #   beam = beamPackagesPrev.beam;
  #   inherit erlang elixir;
  #   rebar3 = beamPackagesPrev.rebar3;
  #   hex = beamPackagesPrev.hex.override { inherit elixir; };
  #   buildMix = beamPackagesPrev.buildMix.override {
  #     inherit elixir erlang hex;
  #   };
  #   mixRelease = beamPackagesPrev.mixRelease.override { inherit erlang elixir; };
  # };
  # beamPackages = pkgs.beam.packages.erlangR24.beamPackages;
  # lib = pkgs.lib;
  # easy_ssl = pkgs.beamPackages.buildMix {
  #   name = "easy_ssl";
  #   version = "1.4.0";

  #   src = pkgs.fetchFromGitHub {
  #     owner = "CaliDog";
  #     repo = "EasySSL";
  #     rev = "87ece602a3510ad60b7bba1755b6a32d5eb1141b";
  #     sha256 = "sha256-UNw8DTY7HJrjYlnQQRU0+8n4c0Ef2hN3C/2WQZr8u2c=";
  #   };
  #   beamDeps = [ ];
  # };



in pkgs.beamPackages.mixRelease rec {
  pname = "certstream-server";
  version = "1.6.0";
  removeCookie = false;
  src = pkgs.fetchFromGitHub {
    owner = "Chaz6";
    repo = pname;
    rev = "60de7000901e5eb246d2e83c908678b43e5a60c8";
    hash = "sha256-jrVgPb8Iu/lZLLQ/zLNZepUt/09iQaptvcatvbe048A=";
  };

  mixNixDeps = import ./deps.nix { inherit (pkgs) lib beamPackages;};

}
