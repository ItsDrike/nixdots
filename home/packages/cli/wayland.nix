{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf osConfig.myOptions.home-manager.wms.isWayland {
    home.packages = with pkgs; [
      wl-clipboard # clipboard interactions
      grim # grab images
      slurp # select a region
      wf-recorder # screen recording

      # Grabs text from screenshot image
      (pkgs.writeShellApplication {
        name = "ocr";
        runtimeInputs = with pkgs; [tesseract grim slurp coreutils];
        text = ''
          echo "Generating a random ID..."
          id=$(tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 6 | head -n 1 || true)
          echo "Image ID: $id"

          echo "Taking screenshot..."
          grim -g "$(slurp -w 0)" /tmp/ocr-"$id".png

          echo "Running OCR..."
          tesseract /tmp/ocr-"$id".png - | wl-copy
          echo -en "File saved to /tmp/ocr-'$id'.png\n"


          echo "Sending notification..."
          notify-send "OCR " "Text copied!"

          echo "Cleaning up..."
          rm /tmp/ocr-"$id".png -vf
        '';
      })
    ];
  };
}
