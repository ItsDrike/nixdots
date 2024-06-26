{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.qimgv;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qimgv
    ];

    xdg.configFile = {
      "qimgv/qimgv.conf".text = ''
        [General]
        JPEGSaveQuality=95
        absoluteZoomStep=false
        autoResizeLimit=90
        autoResizeWindow=false
        backgroundOpacity=1
        blurBackground=false
        confirmDelete=true
        confirmTrash=false
        cursorAutohiding=true
        defaultCropAction=0
        defaultFitMode=0
        defaultViewMode=0
        drawTransparencyGrid=false
        enableSmoothScroll=true
        expandImage=false
        expandLimit=2
        firstRun=false
        focusPointIn1to1Mode=1
        folderEndAction=0
        imageScrolling=1
        infoBarFullscreen=true
        infoBarWindowed=false
        jxlAnimation=false
        keepFitMode=false
        lastVerMajor=1
        lastVerMicro=2
        lastVerMinor=0
        loopSlideshow=false
        mpvBinary=/nix/store/sz3h6s8p2r22v76m0yr6fn3m663sms7r-mpv-with-scripts-0.37.0/bin/mpv
        openInFullscreen=false
        panelEnabled=true
        panelFullscreenOnly=true
        panelPosition=top
        panelPreviewsSize=140
        playVideoSounds=false
        scalingFilter=1
        showSaveOverlay=true
        slideshowInterval=3000
        smoothAnimatedImages=true
        smoothUpscaling=true
        sortingMode=0
        squareThumbnails=false
        thumbPanelStyle=1
        thumbnailCache=true
        thumbnailerThreads=4
        unloadThumbs=true
        useOpenGL=false
        usePreloader=true
        useSystemColorScheme=false
        videoPlayback=true
        windowTitleExtendedInfo=true
        zoomIndicatorMode=0
        zoomStep=0.20000000298023224

        [Controls]
        shortcuts="zoomIn=+", "frameStepBack=,", "zoomOut=-", "frameStep=.", "fitWindow=1", "scrollDown=2", "fitNormal=3", "scrollLeft=4", "scrollRight=6", "scrollUp=8", "exit=Alt+X", "folderView=Backspace", "crop=C", "copyFileClipboard=Ctrl+C", "showInDirectory=Ctrl+D", "zoomOut=Ctrl+Down", "rotateLeft=Ctrl+L", "seekVideoBackward=Ctrl+Left", "open=Ctrl+O", "print=Ctrl+P", "exit=Ctrl+Q", "rotateRight=Ctrl+R", "seekVideoForward=Ctrl+Right", "save=Ctrl+S", "copyPathClipboard=Ctrl+Shift+C", "saveAs=Ctrl+Shift+S", "zoomIn=Ctrl+Up", "pasteFile=Ctrl+V", "zoomOutCursor=Ctrl+WheelDown", "zoomInCursor=Ctrl+WheelUp", "discardEdits=Ctrl+Z", "s:trash with trash-cli=Del", "scrollDown=Down", "jumpToLast=End", "folderView=Enter", "closeFullScreenOrExit=Esc", "toggleFullscreen=F", "toggleFullscreen=F11", "renameFile=F2", "reloadImage=F5", "flipH=H", "jumpToFirst=Home", "toggleImageInfo=I", "toggleFullscreen=LMB_DoubleClick", "prevImage=Left", "moveFile=M", "contextMenu=Menu", "openSettings=P", "resize=R", "contextMenu=RMB", "nextImage=Right", "removeFile=Shift+Del", "toggleFullscreenInfoBar=Shift+F", "prevDirectory=Shift+Left", "nextDirectory=Shift+Right", "toggleFitMode=Space", "scrollUp=Up", "flipV=V", "nextImage=WheelDown", "prevImage=WheelUp", "prevImage=XButton1", "nextImage=XButton2", "toggleSlideshow=`", "toggleShuffle=~"

        [Scripts]
        script\1\name=trash with trash-cli
        script\1\value=@Variant(\0\0\0\x7f\0\0\0\aScript\0\0\0\0 \0t\0r\0\x61\0s\0h\0-\0p\0u\0t\0 \0%\0\x66\0i\0l\0\x65\0%\x1)
        script\size=1
      '';

      "qimgv/theme.conf".text = ''
        [Colors]
        accent=#8c9b81
        background=#1a1a1a
        background_fullscreen=#1a1a1a
        folderview=#242424
        folderview_topbar=#383838
        icons=#a4a4a4
        overlay=#1a1a1a
        overlay_text=#d2d2d2
        scrollbar=#5a5a5a
        text=#b6b6b6
        widget=#252525
        widget_border=#2c2c2c
      '';
    };
  };
}
