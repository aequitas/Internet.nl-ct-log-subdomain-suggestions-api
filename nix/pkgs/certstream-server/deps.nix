{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    bunt = buildMix rec {
      name = "bunt";
      version = "0.2.0";

      src = fetchHex {
        pkg = "bunt";
        version = "${version}";
        sha256 = "7af5c7e09fe1d40f76c8e4f9dd2be7cebd83909f31fee7cd0e9eadc567da8353";
      };

      beamDeps = [];
    };

    certifi = buildRebar3 rec {
      name = "certifi";
      version = "2.5.2";

      src = fetchHex {
        pkg = "certifi";
        version = "${version}";
        sha256 = "3b3b5f36493004ac3455966991eaf6e768ce9884693d9968055aeeeb1e575040";
      };

      beamDeps = [ parse_trans ];
    };

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.8.0";

      src = fetchHex {
        pkg = "cowboy";
        version = "${version}";
        sha256 = "4643e4fba74ac96d4d152c75803de6fad0b3fa5df354c71afdd6cbeeb15fac8a";
      };

      beamDeps = [ cowlib ranch ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
      version = "2.9.1";

      src = fetchHex {
        pkg = "cowlib";
        version = "${version}";
        sha256 = "e4175dc240a70d996156160891e1c62238ede1729e45740bdd38064dad476170";
      };

      beamDeps = [];
    };

    credo = buildMix rec {
      name = "credo";
      version = "1.5.1";

      src = fetchHex {
        pkg = "credo";
        version = "${version}";
        sha256 = "0b219ca4dcc89e4e7bc6ae7e6539c313e738e192e10b85275fa1e82b5203ecd7";
      };

      beamDeps = [ bunt file_system jason ];
    };

    decimal = buildMix rec {
      name = "decimal";
      version = "2.0.0";

      src = fetchHex {
        pkg = "decimal";
        version = "${version}";
        sha256 = "34666e9c55dea81013e77d9d87370fe6cb6291d1ef32f46a1600230b1d44f577";
      };

      beamDeps = [];
    };

    easy_ssl = buildMix rec {
      name = "easy_ssl";
      version = "1.3.0";

      src = fetchHex {
        pkg = "easy_ssl";
        version = "${version}";
        sha256 = "ce8fcb7661442713a94853282b56cee0b90c52b983a83aa6af24686d301808e1";
      };

      beamDeps = [];
    };

    excoveralls = buildMix rec {
      name = "excoveralls";
      version = "0.13.3";

      src = fetchHex {
        pkg = "excoveralls";
        version = "${version}";
        sha256 = "cc26f48d2f68666380b83d8aafda0fffc65dafcc8d8650358e0b61f6a99b1154";
      };

      beamDeps = [ hackney jason ];
    };

    file_system = buildMix rec {
      name = "file_system";
      version = "0.2.10";

      src = fetchHex {
        pkg = "file_system";
        version = "${version}";
        sha256 = "41195edbfb562a593726eda3b3e8b103a309b733ad25f3d642ba49696bf715dc";
      };

      beamDeps = [];
    };

    hackney = buildRebar3 rec {
      name = "hackney";
      version = "1.16.0";

      src = fetchHex {
        pkg = "hackney";
        version = "${version}";
        sha256 = "3bf0bebbd5d3092a3543b783bf065165fa5d3ad4b899b836810e513064134e18";
      };

      beamDeps = [ certifi idna metrics mimerl parse_trans ssl_verify_fun ];
    };

    honeybadger = buildMix rec {
      name = "honeybadger";
      version = "0.15.0";

      src = fetchHex {
        pkg = "honeybadger";
        version = "${version}";
        sha256 = "f160b050e09bd9775e170a8832385bad45b3d202f9317d5c4f36b9da18584725";
      };

      beamDeps = [ hackney jason telemetry ];
    };

    httpoison = buildMix rec {
      name = "httpoison";
      version = "1.7.0";

      src = fetchHex {
        pkg = "httpoison";
        version = "${version}";
        sha256 = "975cc87c845a103d3d1ea1ccfd68a2700c211a434d8428b10c323dc95dc5b980";
      };

      beamDeps = [ hackney ];
    };

    idna = buildRebar3 rec {
      name = "idna";
      version = "6.0.1";

      src = fetchHex {
        pkg = "idna";
        version = "${version}";
        sha256 = "a02c8a1c4fd601215bb0b0324c8a6986749f807ce35f25449ec9e69758708122";
      };

      beamDeps = [ unicode_util_compat ];
    };

    instruments = buildMix rec {
      name = "instruments";
      version = "1.1.3";

      src = fetchHex {
        pkg = "instruments";
        version = "${version}";
        sha256 = "1502a9a1668d6b4056d8fe023c0006d50d0f032b6788cdc3b725bb44dd77d6f6";
      };

      beamDeps = [ recon statix ];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.2.2";

      src = fetchHex {
        pkg = "jason";
        version = "${version}";
        sha256 = "18a228f5f0058ee183f29f9eae0805c6e59d61c3b006760668d8d18ff0d12179";
      };

      beamDeps = [ decimal ];
    };

    metrics = buildRebar3 rec {
      name = "metrics";
      version = "1.0.1";

      src = fetchHex {
        pkg = "metrics";
        version = "${version}";
        sha256 = "69b09adddc4f74a40716ae54d140f93beb0fb8978d8636eaded0c31b6f099f16";
      };

      beamDeps = [];
    };

    mimerl = buildRebar3 rec {
      name = "mimerl";
      version = "1.2.0";

      src = fetchHex {
        pkg = "mimerl";
        version = "${version}";
        sha256 = "f278585650aa581986264638ebf698f8bb19df297f66ad91b18910dfc6e19323";
      };

      beamDeps = [];
    };

    number = buildMix rec {
      name = "number";
      version = "1.0.3";

      src = fetchHex {
        pkg = "number";
        version = "${version}";
        sha256 = "dd397bbc096b2ca965a6a430126cc9cf7b9ef7421130def69bcf572232ca0f18";
      };

      beamDeps = [ decimal ];
    };

    parse_trans = buildRebar3 rec {
      name = "parse_trans";
      version = "3.3.0";

      src = fetchHex {
        pkg = "parse_trans";
        version = "${version}";
        sha256 = "17ef63abde837ad30680ea7f857dd9e7ced9476cdd7b0394432af4bfc241b960";
      };

      beamDeps = [];
    };

    pobox = buildRebar3 rec {
      name = "pobox";
      version = "1.2.0";

      src = fetchHex {
        pkg = "pobox";
        version = "${version}";
        sha256 = "25d6fcdbe4fedbbf4bcaa459fadee006e75bb3281d4e6c9b2dc0ee93c51920c4";
      };

      beamDeps = [];
    };

    ranch = buildRebar3 rec {
      name = "ranch";
      version = "1.7.1";

      src = fetchHex {
        pkg = "ranch";
        version = "${version}";
        sha256 = "451d8527787df716d99dc36162fca05934915db0b6141bbdac2ea8d3c7afc7d7";
      };

      beamDeps = [];
    };

    recon = buildRebar3 rec {
      name = "recon";
      version = "2.3.6";

      src = fetchHex {
        pkg = "recon";
        version = "${version}";
        sha256 = "f55198650a8ec01d3efc04797abe550c7d023e7ff8b509f373cf933032049bd8";
      };

      beamDeps = [];
    };

    ssl_verify_fun = buildRebar3 rec {
      name = "ssl_verify_fun";
      version = "1.1.6";

      src = fetchHex {
        pkg = "ssl_verify_fun";
        version = "${version}";
        sha256 = "bdb0d2471f453c88ff3908e7686f86f9be327d065cc1ec16fa4540197ea04680";
      };

      beamDeps = [];
    };

    statix = buildMix rec {
      name = "statix";
      version = "1.2.1";

      src = fetchHex {
        pkg = "statix";
        version = "${version}";
        sha256 = "7f988988fddcce19ae376bb8e47aa5ea5dabf8d4ba78d34d1ae61eb537daf72e";
      };

      beamDeps = [];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "0.4.2";

      src = fetchHex {
        pkg = "telemetry";
        version = "${version}";
        sha256 = "2d1419bd9dda6a206d7b5852179511722e2b18812310d304620c7bd92a13fcef";
      };

      beamDeps = [];
    };

    unicode_util_compat = buildRebar3 rec {
      name = "unicode_util_compat";
      version = "0.5.0";

      src = fetchHex {
        pkg = "unicode_util_compat";
        version = "${version}";
        sha256 = "d48d002e15f5cc105a696cf2f1bbb3fc72b4b770a184d8420c8db20da2674b38";
      };

      beamDeps = [];
    };
  };
in self
