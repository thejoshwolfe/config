# bash things that are common on every computer i run bash on

# Bash stuff
HISTCONTROL=ignoreboth
# "unlimited" history
HISTFILESIZE=1000000000
HISTSIZE=1000000
# write to the history file as soon as possible,
# which is *after* each command completes.
# too bad we can't write to the history file when we hit enter.
shopt -s histappend
PROMPT_COMMAND='history -a'
# if you run `bash` from a bash prompt, then the above limits are ignored,
# and your history is truncated. So in addition to the increased limits,
# also move the history file. That way, if the configuration is ignored,
# it will clobber the unused default file.
HISTFILE=$HOME/.bash_history_large


# Linux/Cygwin stuff

# used by `git commit` without a -m argument
export EDITOR="vim"

# why doesn't which have a -q option like diff?
which-q() {
    # this has to be a function, not an alias,
    # or else the below usage won't work for some types of shell invocations
    which &> /dev/null "$@"
}
alias dush="du -sh"
alias real-df="df -hT -x tmpfs -x debugfs -x devtmpfs -x ecryptfs -x squashfs"
alias ls="ls --color=auto"
alias lsa="ls -A"
alias flush_swap="sudo swapoff -a && sudo swapon -a"
alias lesscolor="less -RXF"
make_parallel() {
    # use all the cores please
    make -j"$(nproc)" "$@"
}
if which-q fromdos; then
    alias dos2unix="fromdos"
fi
if which-q xdg-open; then
    alias x="xdg-open"
fi
if which-q explorer.exe && which-q cygpath; then
    x() {
        explorer.exe "$(cygpath -wa "$1")"
    }
fi
if which-q steam; then
    # because Factorio will violently crash the display driver if you try to quit the game cleanly
    kill-steam-game() { kill -9 "$(ps -ef | grep -P "[g]ameoverlayui" | findall " -pid (\d+)")"; }
fi

# --content-disposition respects the file name headers instead of using the url path
alias wget="wget --content-disposition"
# warn when mv would clobber a file
alias mv="mv -i"
alias grep="grep -I --color=auto"
grepp() { `which grep` -rIPs --color=always "$@" | lesscolor; }
grepb() { grepp "\b$(echo -n $(gtkclip -p))\b" "$@"; }
# always pass vim -p to use tabs instead of the weird sequential edit thing vim does by default.
if which-q gvim; then
    # prefer gvim if it's installed
    alias vim="gvim -p"
else
    alias vim="vim -p"
fi
ccd() { mkdir -p "$1" && cd "$1"; }
alias torrent-start="screen -m -S torrent transmission-cli -D -U -w ~/torrent/"
alias what-ubuntu-am-i="lsb_release -a"
alias cd-real="cd -P"
alias gdb="gdb -quiet"
# common typos
alias dc="cd"
alias sl="ls"
alias lslslslslslslslslslslslslslslsls="ls"
# Fun fact: every home appliance is a 100% efficient electric space heater.
alias burn-cpu="while true; do :; done"

# see https://github.com/thejoshwolfe/util
if [ -z "$UTIL_LOCATION" ]; then
    # guess that it's sitting next to this repo
    UTIL_LOCATION="$(readlink -f "$(dirname "$(readlink -f "$BASH_SOURCE")")"/../util)"
fi
if [ -d "$UTIL_LOCATION" ]; then
    export PATH="$PATH:$UTIL_LOCATION"
    alias prgs="progress"
    alias un="prgs unfoo -v"
fi

# see https://github.com/thejoshwolfe/whitespace_lint
if [ -z "$WHITESPACE_LINE_LOCATION" ]; then
    # guess that it's sitting next to this repo
    WHITESPACE_LINE_LOCATION="$(readlink -f "$(dirname "$(readlink -f "$BASH_SOURCE")")"/../whitespace_lint)"
fi
if [ -d "$WHITESPACE_LINE_LOCATION" ]; then
    export PATH="$PATH:$WHITESPACE_LINE_LOCATION"
fi

background() {
    "$@" &> /dev/null &
}

# when all other attempts fail to keep idle ssh connections open,
# run this function in the background to periodically wiggle the
# cursor. This will corrupt your terminal experience only when the
# cursor is in the rightmost column of the terminal.
# TODO: save/restore cursor position instead of wiggle?
keep_ssh_alive() {
    python -c 'import sys,time;all((sys.stdout.write("\x1b[1C\x1b[1D"),sys.stdout.flush())for _ in iter((lambda:time.sleep(100)),1))' &
}


# Git stuff

alias gs="git status"
alias sg="git status"
alias gd="git diff"
alias gdcached="gd --cached"
alias gdwords="gd --color-words --word-diff-regex='\\w+|.'"
alias gdcachedwords="gdwords --cached"
alias gl="git log --graph --stat"
alias glp="gl -p"
alias glpwords="glp --color-words --word-diff-regex='\\w+|.'"
alias gc="git add -A && git commit -m"
alias gitfetch="git fetch --prune --tags"
alias gitclone="git clone --recursive"
alias gitrevparse="git rev-parse --verify"

gitsubmodulesplease() {
    # make submodules be what they should be.
    # anything ignored by .gitignore is also ignored by this function.
    # after this function, `git status` should say nothing about submodules.

    # first blow away any local changes.
    # this can break `submodule update` if we don't do it first.
    git submodule foreach -q --recursive 'git clean -q -ffd' &&
    git submodule foreach -q --recursive 'git reset -q --hard HEAD' &&

    # this is necessary when a submodule's remote url is changed
    git submodule sync -q --recursive &&
    # checkout the proper commit
    git submodule update --recursive --init &&
    # blow away any local deviations from head:
    # 1. delete untracked files and directories.
    git submodule foreach -q --recursive 'git clean -q -ffd' &&
    # 2. revert local modifications to tracked files
    git submodule foreach -q --recursive 'git reset -q --hard HEAD'
    # The 'quotes' around the subcommands aren't necessary, except that
    # there appears to be a bug in `git submodule foreach` where any -q
    # given to the subcommand is gobbled up by the main git command and not passed on,
    # and the quotes work around that problem.
    # All software is terrible.
}

gitpull() {
    # this is actually *not* a git pull, because there is no `git fetch` here.
    # this function operates strictly offline.
    # call it after doing your own `git fetch` (or `gitfetch` defined above).

    # @{upstream} is the "origin/<branchname>" that is appropriate to "pull" from.
    # --ff-only means this will never create a merge commit.
    # if you're in a situation where you want to make a merge commit,
    # then do a `git merge @{upstream}` yourself.
    git merge '@{upstream}' --ff-only &&

    # and then submodules
    gitsubmodulesplease
}

gitforcepush() {
    # This is usually what i want instead of `git push`.
    # If you're on main (or whatever the primary branch is, e.g. "master"), this is just a `git push`.
    # If you're on a non-main branch, it is assumed that rebasing is common
    # (including amending, squashing, etc.), so you often need to force push.
    # Uses --force-with-lease which is better than --force,
    # but what i really want is --force-if-the-commits-im-blowing-away-are-also-by-me.

    REMOTE=${1-origin}

    if [ "$REMOTE/$(git rev-parse --verify --abbrev-ref HEAD 2>/dev/null)" == "$(git rev-parse --verify --abbrev-ref "$REMOTE/HEAD" 2>/dev/null)" ]; then
        # main branch
        git push "$REMOTE"
    else
        # non-main branch or not a git repo
        git push --force-with-lease "$REMOTE"
    fi
}

git-new-branch() {
    # Creates a local and remote branch with the given name only if they don't already exist.
    # The new branch will point to the current HEAD after it is created.
    # This function comes from here: https://stackoverflow.com/a/50403179/367916
    if [ "$#" != 1 ]; then
        echo 'usage: git-new-branch branchname' >&2
        return 1
    fi

    # `git mktree` and `git commit-tree` read stdin, so use `<%-` to close stdin for those processes.

    # The `git mktree` is idempotent and prints a sha1 of an empty tree.

    # The `git commit-tree` makes an empty commit with the empty tree, and importantly the commit has no parents.
    # The git commit-tree also prints a sha1, but it is not idempotent.
    # The commit has your `user.name` and a timestamp.
    # Furthermore, this commit goes into the .git directory as an orphaned commit.
    # Orphaned commits will eventually be garbage collected by git automatically; see git help gc.
    # The -m "" means the commit message will be empty.
    # But none of this matters too much, because this commit will be used once and immediately abandoned.

    # First, we push the empty commit to the given branch name at origin.
    # If the branch already exists, it is guaranteed to be rejected, because the empty commit has no parents,
    # therefore pushing it can't possibly cause a fast forward.
    # (And since the commit is generated anew on each invocation,
    # there's no chance that the commit is already in the remote repo anywhere.)
    git push origin "$(git commit-tree -m "" "$(git mktree <&-)" <&-)":refs/heads/"$1" &&
    # This creates a new local branch with the given name.
    git checkout -b "$1" &&
    # `--force-with-lease` means the remote branch will only be updated if it's still what we thought it was,
    # which is the empty commit we just pushed.
    git push --set-upstream --force-with-lease origin "$1"
}

github() {
    # for example `gitclone thejoshwolfe/util`
    gitclone git@github.com:$1.git;
}

# svn, because git is not the right tool for every job.
if [ -f "$UTIL_LOCATION/deps/svn-color/svn-color.sh" ]; then
    source $UTIL_LOCATION/deps/svn-color/svn-color.sh
    svnlog() { svn log "$@" | lesscolor; }
    svndiff() { svn diff --no-diff-deleted "$@" | lesscolor; }
    svnst() { svn st -u --ignore-externals "$@" | lesscolor; }
    svnblame() { svn blame "$@" | lesscolor; }
fi
if [ -f "$UTIL_LOCATION/../pvc/some_aliases.bash" ]; then
    source "$UTIL_LOCATION/../pvc/some_aliases.bash"
fi


# Other stuff

publish-to-s3() {
    s3cmd sync -P --no-preserve --add-header="Cache-Control: max-age=0, must-revalidate" "$@"
}

publish-to-s3-delete-removed() {
    publish-to-s3 --delete-removed "$@"
}

alias homegit='GIT_DIR=~/.homegitdir GIT_WORK_TREE=~ git'
init-homegit() {
    # This is like a clone but doesn't touch any files outside the git dir.
    homegit init -b main &&
    homegit config core.excludesFile ~/.homegitignore &&
    homegit remote add origin gitea@home:thejoshwolfe/homegit.git &&
    homegit fetch origin &&
    homegit reset origin/main &&
    homegit branch --set-upstream-to=origin/main main
}

# Nixos Stuff

save-nixos-config() {
    here="$(dirname "$(readlink -f "$BASH_SOURCE")")"
    # Copy in the configuration from the system.
    cp /etc/nixos/configuration.nix "$here"/nixos-configuration.nix &&
    # Stage the changes.
    git -C "$here" add nixos-configuration.nix &&
    # if there's nothing to commit, then we're done.
    { git -C "$here" diff --cached --quiet && return || true; } &&
    # Show the fleshbag human at the keyboard what they're committing.
    (git -C "$here" diff --cached --color=always | less -RX) &&
    # Enter a commit message through $EDITOR.
    # (Entering an empty message will exit 1 at this point.)
    git -C "$here" commit &&
    # Push
    git -C "$here" push
}

edit-nixos-config() {
    sudo sh -c 'vim /etc/nixos/configuration.nix && nixos-rebuild switch' &&
    save-nixos-config
}
