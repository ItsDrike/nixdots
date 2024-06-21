{ pkgs, ... }: {
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = false;
    extensions = with pkgs; [
      gh-dash # dashboard with pull requess and issues
      gh-eco # explore the ecosystem
      gh-cal # contributions calendar terminal viewer
      gh-notify # access and manage github notifications
    ];
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}
