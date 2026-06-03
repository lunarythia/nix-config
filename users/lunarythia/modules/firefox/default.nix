{ config, lib, pkgs, ... }:
with lib;
{
  config = mkIf config.programs.firefox.enable {
    programs.firefox = {
      profiles.default = {
        search = {
          force = true;
          default = "ddg";
          engines = {
            amazondotcom-us.metaData.hidden = true;
            bing.metaData.hidden = true;
            ebay.metaData.hidden = true;
            perplexity.metaData.hidden = true;

            nix-options = {
              name = "Nix Options";
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            nix-packages = {
              name = "Nix Packages";
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [{ template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }];
              iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
              definedAliases = [ "@nw" ];
            };
          };
        };

        settings = {
          "browser.bookmarks.file" = config.sops.secrets.ff-bookmarks.path;
          "browser.places.importBookmarksHTML" = true;

          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.toolbars.bookmarks.visibility" = "newtab";
          
          "sidebar.main.tools" = "syncedtabs,history,bookmarks";

          "browser.translations.automaticallyPopup" = false;
          "browser.translations.neverTranslateLanguages" = "en,zh-Hant";
          
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "expand-on-hover";

          "signon.rememberSignons" = false;
          
          "browser.uiCustomization.state" = builtins.toJSON {
            "placements" = {
              "widget-overflow-fixed-list" = [];
              "nav-bar" = [
                "sidebar-button"
                "back-button"
                "forward-button"
                "stop-reload-button"
                "home-button"
                "customizableui-special-spring1"
                "vertical-spacer"
                "urlbar-container"
                "customizableui-special-spring2"
                "downloads-button"
                "fxa-toolbar-menu-button"
                "unified-extensions-button"
                "ublock0_raymondhill_net-browser-action"
                "firefox-view-button"
                "alltabs-button"
                "reset-pbm-toolbar-button"
              ];
              "TabsToolbar" = [];
              "vertical-tabs" = [
                "tabbrowser-tabs"
              ];
              "PersonalToolbar" = [
                "personal-bookmarks"
              ];
            };
            "currentVersion" = 24;
            "newElementCount" = 3;
          };
        };
      };

      policies = {
        ExtensionSettings = let
          extension = { shortId, uuid, defaultArea ? "menupanel", privateBrowsing ? false }: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed"; # or force_installed
              default_area = defaultArea;
              private_browsing = privateBrowsing;
            };
          };
        in
          builtins.listToAttrs [
            (extension {
              shortId = "ublock-origin";
              uuid = "uBlock0@raymondhill.net";
              defaultArea = "navbar";
              privateBrowsing = true;
            })
            (extension {
              shortId = "adaptive-tab-bar-colour";
              uuid = "ATBC@EasonWong";
            })
            (extension {
              shortId = "keepassxc-browser";
              uuid = "keepassxc-browser@keepassxc.org";
              privateBrowsing = true;
            })
            (extension {
              shortId = "return-youtube-dislikes";
              uuid = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
            })
            (extension {
              shortId = "seelie-companion";
              uuid = "companion@seelie.me";
            })
          ];
      };
    };
  };
}
