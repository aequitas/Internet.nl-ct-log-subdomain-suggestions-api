{ self }:
{ lib, config, pkgs, ... }:

let
  # shorthand for this module's configuration
  cfg = config.services.ctlssa;
  # current system for which package/module is built
  inherit (pkgs.stdenv.hostPlatform) system;

  db_name = "ctlssa";
  ctlssa_user = "ctlssa";
in {
  # define configurable options for this module
  options.services.ctlssa = {
    enable = lib.mkEnableOption "CTLSSA";
    port = lib.mkOption {
      type = lib.types.int;
      default = 8001;
      description = "The port on which the CTLSSA service will listen.";
    };
    allowedHosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "localhost" ];
      description = "The list of allowed hosts for the CTLSSA service.";
    };
  };

  # implement the module configuration
  config = lib.mkIf cfg.enable {
    # configure user/group using for postgresql authentication amount others
    users.users."${ctlssa_user}" = {
      isSystemUser = true;
      group = ctlssa_user;
    };
    users.groups."${ctlssa_user}" = { };

    # add the package to the system path for running management commands
    # TODO: wrap with environment variables for postgres config
    environment.systemPackages = [ self.packages."${system}".ctlssa ];

    # configure a uWSGI instance to run ctlssa
    services.uwsgi = {
      enable = true;
      # enable python
      plugins = [ "python3" ];
      # TODO: needed?
      capabilities = [
        "CAP_SETUID"
        "CAP_SETGID"
      ]
      ;
      instance = {
        type = "normal";
        master = true;
        http-socket = ":${toString config.services.ctlssa.port}";
        immediate-uid = ctlssa_user;
        immediate-gid = ctlssa_user;
        module = "ctlssa.app.wsgi";
        # add the ctlssa package and all its dependencies to the PYTHONPATH for this uwsgi instance
        pythonPackages = (x: [ self.packages."${system}".ctlssa ]);
        # configuration Django
        env = [
          "DJANGO_SETTINGS_MODULE=ctlssa.app.settings"
          "DEBUG=False"
          "CTLSSA_DJANGO_DATABASE=production"
          "CTLSSA_DB_ENGINE=postgresql_psycopg2"
          "CTLSSA_DB_HOST=/var/run/postgresql"
          "CTLSSA_ALLOWED_HOSTS=${builtins.concatStringsSep "," config.services.ctlssa.allowedHosts}"
        ];
      };
    };

    # TODO: need solution for PYTHONPATH -> makepythonpath or same approach as pythonPackages in uwsgi above?
    systemd.services.ctlssa-ingest = {
      enable = true;
      description = "Internet.nl Certificate Transparency Log Subdomain Suggestions Ingest";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        DJANGO_SETTINGS_MODULE = "ctlssa.app.settings";
        DEBUG = "False";
        CTLSSA_DJANGO_DATABASE = "production";
        CTLSSA_DB_ENGINE = "postgresql_psycopg2";
        # use postgresql socket path for connecting so we cn leverage unix user authentication
        CTLSSA_DB_HOST = "/var/run/postgresql";
        CTLSSA_CERTSTREAM_SERVER_URL=
        # PYTHONPATH = "${self.packages."${system}".ctlssa.pythonPath}";
      };
      serviceConfig = {
        User = ctlssa_user;
        ExecStartPre = "${self.packages.${system}.ctlssa}/bin/ctlssa migrate";
        ExecStart = "${self.packages.${system}.ctlssa}/bin/ctlssa ingest";
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ db_name ];
      ensureUsers = [{
        name = ctlssa_user;
        ensureDBOwnership = true;
      }];
    };
  };
}

#     serviceConfig = {
#       Type = "simple";
#       DynamicUser = true;
#       ExecPreStart = "${self.packages.${system}.ctlssa}/bin/ctlssa migrate";
#       ExecStart = "${pkgs.uwsgi}/bin/uwsgi";

#       Restart = "always";
#       RestartSec = 5;

#       UMask = "077";
#       NoNewPrivileges = true;
#       ProtectSystem = "strict";
#       ProtectHome = true;
#       PrivateTmp = true;
#       PrivateDevices = false;
#       DevicePolicy = "closed";
#       PrivateUsers = true;
#       ProtectHostname = true;
#       ProtectClock = true;
#       ProtectKernelTunables = true;
#       ProtectKernelModules = true;
#       ProtectKernelLogs = true;
#       ProtectControlGroups = true;
#       ProtectProc = "invisible";
#       ProcSubset = "pid";
#       RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
#       RestrictNamespaces = true;
#       LockPersonality = true;
#       MemoryDenyWriteExecute = true;
#       RestrictRealtime = true;
#       RestrictSUIDSGID = true;
#       RemoveIPC = true;
#       PrivateMounts = true;
#       SystemCallArchitectures = "native";
#       SystemCallFilter = [ "@system-service" "~@privileged" ];
#       CapabilityBoundingSet = null;
#     };
#   };
# };
