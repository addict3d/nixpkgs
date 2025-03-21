{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    literalExpression
    ;

  cfg = config.services.meme-bingo-web;
in
{
  options = {
    services.meme-bingo-web = {
      enable = mkEnableOption ''
        a web app for the meme bingo, rendered entirely on the web server and made interactive with forms.

        Note: The application's author suppose to run meme-bingo-web behind a reverse proxy for SSL and HTTP/3
      '';

      package = mkPackageOption pkgs "meme-bingo-web" { };

      baseUrl = mkOption {
        description = ''
          URL to be used for the HTML \<base\> element on all HTML routes.
        '';
        type = types.str;
        default = "http://localhost:41678/";
        example = "https://bingo.example.com/";
      };
      address = mkOption {
        description = ''
          The address the webserver will bind to.
        '';
        type = types.str;
        default = "localhost";
        example = "::";
      };
      port = mkOption {
        description = ''
          Port to be used for the web server.
        '';
        type = types.port;
        default = 41678;
        example = 21035;
      };
      openFirewall = mkEnableOption ''
        Opens the specified port in the firewall.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.meme-bingo-web = {
      description = "A web app for playing meme bingos";
      wantedBy = [ "multi-user.target" ];

      environment = {
        MEME_BINGO_BASE = cfg.baseUrl;
        MEME_BINGO_ADDRESS = cfg.address;
        MEME_BINGO_PORT = toString cfg.port;
      };
      path = [ cfg.package ];

      serviceConfig = {
        User = "meme-bingo-web";
        Group = "meme-bingo-web";

        DynamicUser = true;

        ExecStart = "${cfg.package}/bin/meme-bingo-web";

        Restart = "always";
        RestartSec = 1;

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "/dev/random" ];
        InaccessiblePaths = [
          "/dev/shm"
          "/sys"
          "/run/dbus"
          "/run/user"
          "/run/nscd"
        ];
        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectSystem = "strict";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictFilesystems = [
          "@basic-api"
          "~sysfs"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        ExecPaths = [ "/nix/store" ];
        NoExecPaths = [ "/" ];
      };
    };
  };
}
