# fix bug with atheros network card
# http://askubuntu.com/questions/678145/my-wifi-qualcomm-atheros-device-168c0041-rev-20-doesnt-show-up-and-work-in
# fix gulp watch error
# echo fs.inotify.max_user_watches=582222 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
# ubuntu dark aubergine color: #2C001E rgb(45, 0, 30)


export NVM_DIR="/Users/andy/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# include Golang stuff
if [ -d "$HOME/Go" ]; then
  export GOPATH="$HOME/Go"
  PATH="$GOPATH/bin:$PATH"
fi

# use the version of Git i installed with homebrew instead of the one that came with the OS
if brew --prefix git >/dev/null 2>&1; then
  PATH="$(brew --prefix git)/bin:$PATH"
fi

# Greet me with a triforce and other stuff
echo -e "\033[1;93m           /\            "
echo -e "          /  \           "
echo -e "         /    \          "
echo -e "        /      \         "
echo -e "       /        \        "
echo -e "      /__________\       "
echo -e "     /\__________/\      "
echo -e "    /  \        /  \     "
echo -e "   /    \      /    \    "
echo -e "  /      \    /      \   "
echo -e " /        \  /        \  "
echo -e "/__________\/__________\ "
echo -e "\__________/\__________/ "
echo -e "\033[0m"
echo "Welcome, $USER! It's $(date)."
echo "You're logged in at $(hostname), using $OSTYPE."
echo; echo

# Load git completions
git_completion_script=/usr/local/etc/bash_completion.d/git-completion.bash
git_prompt_script=/usr/local/etc/bash_completion.d/git-prompt.sh
test -s $git_completion_script && source $git_completion_script
test -s $git_prompt_script && source $git_prompt_script

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# A more colorful prompt
# resets the color to default color
c_reset='\[\e[0m\]'
co_white='\e[0m'
# sets the color to purple
c_purple='\[\e[1;35m\]'
# sets the color to cyan
c_cyan='\[\e[1;36m\]'
# sets the color to yellow
c_yellow='\[\e[0;93m\]'
# sets the color to green
c_green='\[\e[1;32m\]'
# sets the color to red
c_red='\[\e[1;31m\]'
co_red='\e[0;31m'

gems="💎💎💎"
christmas="🎁 🎁"
halloween="🎃 👻"
new_years_eve="🎉 🎊"
cinco_de_mayo="🍺🍸🍷"
st_patricks_day="🍀 🍺"
birthday="🎁 🎂 🎈"
valentines="💚💙💜"

prompt="$gems"
[[ $(date +%e) = 14 && $(date +%m) = 2  ]] && prompt="$valentines"
[[ $(date +%e) = 17 && $(date +%m) = 3  ]] && prompt="$st_patricks_day"
[[ $(date +%e) = 5  && $(date +%m) = 5  ]] && prompt="$cinco_de_mayo"
[[ $(date +%e) = 22 && $(date +%m) = 8  ]] && prompt="$birthday"
[[ $(date +%e) = 31 && $(date +%m) = 10 ]] && prompt="$halloween"
[[ $(date +%e) = 25 && $(date +%m) = 12 ]] && prompt="$christmas"
[[ $(date +%e) = 31 && $(date +%m) = 12 ]] && prompt="$new_years_eve"

# PROMPT_COMMAND is a variable whose value is some code that gets evaluated each time the prompt awaits input
# PS1 is the variable for the prompt you see when terminal is awaiting input
PROMPT_COMMAND='
PS1="$(venv)$(format_pwd)$(git_prompt) ${prompt} ${c_reset} ";
echo -ne "\033]0;$(basename $(pwd))\007";
if [[ vim = $(history 1 | awk '"'"'{print $2}'"'"') ]] && [ -d .git ]; then
  git status --short
fi'
export PS2='... '

format_pwd() {
  wd=$(pwd)
  short_wd=${wd/\/Users\/andy/\~}
  first_char=$(echo $short_wd | cut -c 1-1)
  if [[ $first_char != '~' ]]; then
    short_wd="${c_reset}\e[0;0;40m💀 ${c_purple}${short_wd}${c_reset}"
  fi
  echo -e "${c_purple}${short_wd}"
}

venv() {
  if [[ $VIRTUAL_ENV ]]; then
    echo -e "\[\e[0;32m\]🐍 "
  fi
}


# determines if the git branch you are on is clean or dirty and colors accordingly
git_prompt() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  # Grab working branch name
  branch=$(__git_ps1)
  # Clean or dirty branch
  if [[ $(git diff) ]]; then
    git_icon="${c_red}✗"
  elif [[ $(git status --short) ]]; then
    git_icon="${c_yellow}📤"
  else
    git_icon="${c_green}✓"
  fi
  echo "${c_cyan}${branch:0:${#branch} - 1}${git_icon}${c_cyan})${c_reset}"
}

# Colors ls should use for folders, files, symlinks etc, see `man ls` and
# search for LSCOLORS
export LSCOLORS=ExGxFxdxCxDxDxaccxaeex

# Force grep to always use the color option and show line numbers
export GREP_OPTIONS='--color=always'


# Set atom as the default editor
[[ $(which atom) ]] && export EDITOR=atom


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir -A --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

cd() { builtin cd "$@"; ll; }
pushd() { builtin pushd "$@"; ll; }
mkcd() { mkdir -p "$1" && cd "$1"; }
te() { touch "$1"; e "$1"; }

if [[ $(which pygmentize) ]]; then
  # overwrite cat command so that it uses pygments instead
  cat() {
    pygmentize $@ 2>/dev/null # silence errors
    [[ $? != 0 ]] && /bin/cat $@ # if an error occurs, fall back to the regular cat
  }
fi

#full recursive directory listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#extract most known archives
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.xz)    tar xvfJ $1    ;;
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


#   ----------------
#   NETWORKING
#   ----------------

alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs


export PYTHONSTARTUP=$HOME/.pythonrc.py
