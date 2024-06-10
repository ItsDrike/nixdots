{
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.browsers.schizofox;
in {
  imports = [inputs.schizofox.homeManagerModule];
  config = mkIf cfg.enable {
    programs.schizofox = {
      enable = true;

      theme = {
        font = "Inter";
        colors = {
          background-darker = "181825";
          background = "1e1e2e";
          foreground = "cdd6f4";
        };

        extraUserChrome = ''
          @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"); /* only needed once */

          /* full screen toolbars */
          #navigator-toolbox[inFullscreen] toolbar:not([collapsed="true"]) {
             visibility:visible!important;
          }
        '';
      };

      search = {
        defaultSearchEngine = "Brave";
        removeEngines = [ "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia" "LibRedirect" ];
        searxUrl = "https://searx.be";
        searxQuery = "https://searx.be/search?q={searchTerms}&categories=general";

        addEngines = [
          {
            Name = "Brave";
            Description = "Brave search";
            Alias = "!brave";
            Method = "GET";
            URLTemplate = "https://search.brave.com/search?q={searchTerms}";
          }
          {
              Name = "NixOS Packages";
              Description = "NixOS Unstable package search";
              Alias = "!np";
              Method = "GET";
              URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
          }
          {
              Name = "NixOS Options";
              Description = "NixOS Unstable option search";
              Alias = "!no";
              Method = "GET";
              URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
          }
          {
              Name = "NixOS Wiki";
              Description = "NixOS Wiki search";
              Alias = "!nw";
              Method = "GET";
              URLTemplate = "https://nixos.wiki/index.php?search={searchTerms}";
          }
          {
              Name = "Home Manager Options";
              Description = "Home Manager option search";
              Alias = "!hm";
              Method = "GET";
              URLTemplate = "https://mipmip.github.io/home-manager-option-search?query={searchTerms}";
          }
          {
            Name = "MyNixOS";
            Description = "All-In-One NixOS Search (options (including home-manager), packages, categories, flakes) ";
            Alias = "!nn";
            Method = "GET";
            URLTemplate = "https://mynixos.com/search?q={searchTerms}";
          }
          {
              Name = "Arch Wiki";
              Description = "Arch Wiki search";
              Alias = "!aw";
              Method = "GET";
              URLTemplate = "https://wiki.archlinux.org/index.php?search={searchTerms}";
          }
          {
              Name = "Gentoo Wiki";
              Description = "Gentoo Wiki search";
              Alias = "!gw";
              Method = "GET";
              URLTemplate = "https://wiki.gentoo.org/index.php?search={searchTerms}";
          }
          {
              Name = "Debian Wiki";
              Description = "Debian Wiki search";
              Alias = "!dw";
              Method = "GET";
              URLTemplate = "https://wiki.debian.org/FrontPage?action=fullsearch&value={searchTerms}";
          }
        ];
      };

      security = {
        sanitizeOnShutdown = false; # TODO: check
        sandbox = true;
        noSessionRestore = false; # TODO: check
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
      };

      misc = {
        drm.enable = true;
        disableWebgl = false;
      };

      extensions = {
        simplefox.enable = false; # simplified UI, keyboard controled
        darkreader.enable = true;
        extraExtensions = let
          mkUrl = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";

          extensions = [
            {
              id = "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}";
              name = "auto-tab-discard";
            }
            {
              id = "sponsorBlocker@ajay.app";
              name = "sponsorblock";
            }
            {
              id = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
              name = "bitwarden-password-manager";
            }
            {
              id = "{9f043cd9-bcc0-4ea0-9407-9e6274c2182d}";
              name = "videospeed";
            }
          ];

          extraExtensions = builtins.foldl' (acc: ext: acc // {ext.id = { install_url = mkUrl ext.name;};}) {} extensions;
        in extraExtensions;
      };
    };
  };
}

