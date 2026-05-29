{ config, lib, ... }:
with lib;
{
  config = mkIf config.programs.firefox.enable {
    programs.firefox = {
      profiles.default = {
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
