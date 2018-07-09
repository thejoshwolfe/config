# additional bash things that are common on every computer i run bash on

# bash configuration
HISTCONTROL=ignoreboth
shopt -s histappend
HISTFILESIZE=1000000000
HISTSIZE=1000000
PROMPT_COMMAND='history -a'
# if you run `bash` from a bash prompt, then the above limits are ignored,
# and your history is truncated. So in addition to the increased limits,
# also move the history file. That way, if the configuration is ignored,
# it will clobber the unused default file.
HISTFILE=$HOME/.bash_history_large

# vars
export EDITOR="vim"

if [ -z "$UTIL_LOCATION" ]; then
    # default util location
    UTIL_LOCATION="$(readlink -f "$(dirname "$(readlink -f "$BASH_SOURCE")")"/../util)"
fi
if [ -d "$UTIL_LOCATION" ]; then
    export PATH="$PATH:$UTIL_LOCATION"
fi

# convenience aliases
alias prgs="progress"
alias unprgs="prgs unfoo -v"
alias un="unprgs"
alias dush="du -sh"
alias real-df="df -hT -x tmpfs -x debugfs -x devtmpfs -x ecryptfs"
alias wget="wget --content-disposition --no-check-certificate"
alias ls="ls --color=auto"
alias lsa="ls -A"
alias mv="mv -i"
alias pse="ps -e | grep"
alias grepp="grep -RIPs --color=auto"
alias cpv="prgs cp -rv"
alias rmv="prgs rm -rfv"
alias vim="$(which gvim &> /dev/null && echo -n g)vim -p"
ccd() { mkdir -p "$@" && cd "$@"; }
cdd() { cd "$(dirname "$@")"; }
alias torrent-start="screen -m -S torrent transmission-cli -D -U -w ~/torrent/"
alias lesscolor="less -RXF"
alias what-ubuntu-am-i="lsb_release -a"
alias kill-steam-game='kill -9 $(ps -ef | grep -P "[g]ameoverlayui" | findall " -pid (\d+)")'
stfu-make() { make -s "$@" 2>&1 | head; }
cd-real() { cd "$(readlink -f "$(abs $1)")"; }
alias gdb="gdb -quiet"
background() {
    "$@" &> /dev/null &
}
waituntil() { waitforit bash -c "date +%H:%M | grep $1"; }
wolfebin-from-clipboard() { gtkclip -p | wolfebin put - "$@"; }
wolfebin-to-clipboard() { wolfebin get -o - "$@" | gtkclip; }
alias flush_swap="sudo swapoff -a && sudo swapon -a"

# git aliases
alias gs="git status"
alias gc="git add -A && git commit -m"
alias gd="git diff"
alias gdcached="gd --cached"
alias gdwords="gd --color-words --word-diff-regex='\\w+|.'"
alias gdcachedwords="gdwords --cached"
alias gl="git log --graph --stat"
alias glp="gl -p"
alias glpwords="glp --color-words --word-diff-regex='\\w+|.'"
gitpull() { git pull && git submodule update --init --recursive; }
alias gitfetch="git fetch --all --prune --tags"
alias gitclone="git clone --recursive"
github() { gitclone git@github.com:$1.git; }
githome() { gitclone git@home:$1.git; }
function git-new-branch() {
    # usage: git-new-branch branchname
    git push origin $(git commit-tree -m "" $(git mktree <&-) <&-):refs/heads/$1 || return 1
    git checkout -b $1
    git push --set-upstream --force-with-lease origin $1
}

# it's cold in here
alias burn-cpu="while true; do :; done"
# common typos
alias dc="cd"
alias sl="ls"
alias lslslslslslslslslslslslslslslsls="ls"

# ssh utils
publish-to-server() {
    rsync -vuza --exclude=".*" --exclude="node_modules" --delete --delete-excluded ./ server:public_http/$(basename $(pwd))/
    ssh server find public_http \\\( -type f -exec chmod 664 {} + \\\) -o \\\( -type d -exec chmod 777 {} + \\\)
}
upload() {
    # make stdout just the url with no newline so that you can | gtkclip
    scp "$1" server:public_http/ >&2
    echo -n "http://wolfesoftware.com/$(python -c 'import sys,urllib; print(urllib.quote(sys.argv[1]))' "$(basename "$1")")"
    echo >&2
}
# when all other attempts fail to keep idle ssh connections open,
# run this function in the background to periodically wiggle the
# cursor. This will corrupt your terminal experience only when the
# cursor is in the rightmost column of the terminal.
# TODO: save/restore cursor position instead of wiggle?
keep_ssh_alive() {
    python -c 'import sys,time;all((sys.stdout.write("\x1b[1C\x1b[1D"),sys.stdout.flush())for _ in iter((lambda:time.sleep(100)),1))' &
}
publish-to-s3() {
    s3cmd sync -P --no-preserve --delete-removed --add-header="Cache-Control: max-age=0, must-revalidate" "$@"
}

# svn
if [ -f "$UTIL_LOCATION/svn-color/svn-color.sh" ]; then
    source $UTIL_LOCATION/svn-color/svn-color.sh
    svnlog() { svn log "$@" | lesscolor; }
    svndiff() { svn diff --no-diff-deleted "$@" | lesscolor; }
    svnst() { svn st -u --ignore-externals "$@" | lesscolor; }
    svnblame() { svn blame "$@" | lesscolor; }
fi

# OS-specific
if [ "$OSTYPE" = "cygwin" ] || [ "$OSTYPE" = "msys" ]; then
    # windows in cygwin or git bash
    alias killall="taskkill >/dev/null /f /im"
    alias homewin="cd \"$HOMEPATH\""
    alias x="cygstart"

    if [ "$OSTYPE" = "cygwin" ]; then
        # cygwin
        # show only cygdrives for cygwin's df
        alias real-df="df -hT | grep -P 'Mounted|cygdrive'"
    fi
else
    # linux
    alias x="xdg-open"
    alias dos2unix="fromdos"
    make_parallel() { make -j"$(nproc)" "$@"; }
fi
