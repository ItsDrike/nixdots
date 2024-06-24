{ lib, ... }: let
  inherit (lib) mkOption types;

  mkPreferenceCmdOption = name: commandDefault: mkOption {
    type = types.str;
    description = "The command to start your preferred ${name}.";
    default = commandDefault;
  };

  mkPreferenceDesktopOption = name: desktopDefault: mkOption {
    type = types.str;
    description = "The desktop (application) file for your preferred ${name}.";
    default = desktopDefault;
  };

  mkPreferenceOptions = name: commandDefault: desktopDefault: {
    command = mkPreferenceCmdOption name commandDefault; 
    desktop = mkPreferenceDesktopOption name desktopDefault;
  };
in 
{
  options.myOptions.home-manager.preferences = {
    browser = mkPreferenceOptions "browser" "firefox" "firefox.desktop";
    terminalEmulator = mkPreferenceOptions "terminal emulator" "kitty" "kitty.desktop";
    textEditor = mkPreferenceOptions "editor" "nvim" "nvim.desktop";
    fileManager = mkPreferenceOptions "file manager" "pcmanfm-qt" "pcmanfm-qt.desktop";
    imageViewer = mkPreferenceOptions "image viewer" "qimgv" "qimgv.desktop";
    mediaPlayer = mkPreferenceOptions "media player" "mpv" "mpv.desktop";
    archiveManager = mkPreferenceOptions "archive manager" "ark" "org.kde.ark.desktop";
    documentViewer = mkPreferenceOptions "document viewer" "firefox" "firefox.desktop"; # TODO: consider zathura (org.pwmt.zathura.desktop.desktop)
    emailClient = mkPreferenceOptions "email client" "firefox" "firefox.desktop";
    launcher.command = mkPreferenceCmdOption "launcher" "walker";
  };
}
