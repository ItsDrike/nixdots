{pkgs, ...}: let
  scriptPkgs = import ./bin {inherit pkgs;};
in {
  programs.git = {
    aliases = {
      quickclone = "clone --single-branch --depth=1";
      bareclone = "!sh -c 'git clone --bare \"$0\" \"$1\"/.bare; echo \"gitdir: ./.bare\" > \"$1/.git\"'";
      bareinit = "!sh -c 'git init --bare \"$0\"/.bare; echo \"gitdir: ./.bare\" > \"$0/.git\"'";
      cleanup = "!default_branch=$(git remote show origin | awk '/HEAD branch/ {print $NF}'); git remote prune origin && git checkout -q $default_branch && git for-each-ref refs/heads/ '--format=%(refname:short)' | while read branch; do mergeBase=$(git merge-base $default_branch $branch) && [[ $(git cherry $default_branch $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == '-'* ]] && git branch -D $branch; done";

      m = "merge";
      f = "fetch";

      p = "push";
      pu = "!git push --set-upstream origin `git symbolic-ref --short HEAD`";
      pf = "push --force";
      pl = "pull";

      s = "status --short --branch";
      ss = "status";

      ch = "checkout";
      chb = "checkout -b";

      undo = "reset --soft HEAD~";
      redo = "reset HEAD@{1}";
      unstage = "restore --staged";

      c = "commit";
      ca = "commit --ammend";
      ci = "commit --interactive";
      cm = "commit --message";
      cv = "commit --verbose";

      a = "add";
      aa = "add --all";
      ap = "add --patch";
      au = "add --update";

      d = "diff";
      dc = "diff --cached";
      ds = "diff --staged";
      dw = "diff --word-diff";
      dcm = "!sh -c 'git diff $0~ $0'";
      linediff = "!sh -c 'git diff --unified=0 $1 $2 | grep -Po \"(?<=^\\+)(?!\\+\\+).*\" '";

      b = "branch";
      ba = "branch --all";
      bd = "branch --delete";
      bD = "branch --delete --force";
      bm = "branch --move";
      bM = "branch --move --force";
      bb = "!${scriptPkgs.better-git-branch}/bin/better-git-branch";

      r = "rebase";
      ri = "rebase -i";
      rc = "rebase --continue";

      l = "log --oneline --decorate --all --graph";
      lp = "log --patch";
      lo = "log --pretty=oneline --abbrev-commit --graph";
      lg = "log --all --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --";
      loog = "log --format=fuller --show-signature --all --color --decorate --graph";

      make-patch = "diff --no-prefix --relative";

      set-upstream = "!git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`";

      fixup-picker = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";

      staash = "stash --all";
      stash-staged = "!sh -c 'git stash --keep-index; git stash push -m \"staged\" --keep-index; git stash pop stash@{1}'";

      reauthor-all = "rebase --root -r --exec 'git commit --amend --no-edit --reset-author --no-verify'";

      find-merge = "!sh -c 'commit=$0 && branch=\${1:-HEAD} && (git rev-list $commit..$branch --ancestry-path | cat -n; git rev-list $commit..$branch --first-parent | cat -n) | sort -k2 -s | uniq -f1 -d | sort -n | tail -1 | cut -f2'";
      show-merge = "!sh -c 'merge=$(git find-merge $0 $1) && [ -n \"$merge\" ] && git show $merge'";

      tracked-files = "ls-tree --full-tree --name-only -r HEAD";
      tracked-text-files = "!git tracked-files | while IFS= read -r file; do mime_type=$(file -b --mime-type \"$file \"); [[ $mime_type == text/* ]] && echo \"$file \"; done";
      total-lines = "!git tracked-text-files | xargs cat | wc -l";
      total-files = "!git tracked-files | wc -l";
      total-commits = "!git log --oneline | wc -l";
      comitter-lines = "!git log --author=\"$1\" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf \"added lines: %s, removed lines: %s, total lines: %s\\n\", add, subs, loc }' #";
    };
  };
}
