# debug
# set -x
# PS4='+ $(date "+%s.%N")\011 '

[[ $- != *i* ]] && return

export BASHRC_SOURCED=1

if [ -z "$PROFILE_SOURCED" ] && [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'
HISTTIMEFORMAT='%F %T '
export HISTCONTROL='erasedups:ignoreboth'
export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTIGNORE='history:?:??:cd ..'

command -v fzf >/dev/null && eval "$(fzf --bash)"
command -v zoxide >/dev/null && eval "$(zoxide init bash)"
command -v mise >/dev/null && eval "$(mise activate bash)"

# If there are multiple matches for completion, Tab should cycle through them
bind 'TAB:menu-complete'
# And Shift-Tab should cycle backwards
bind '"\e[Z": menu-complete-backward'

# Display a list of the matching files
bind 'set show-all-if-ambiguous on'

# Perform partial (common) completion on the first Tab press, only start
# cycling full results on the second Tab press (from bash version 5)
bind 'set menu-complete-display-prefix on'

# Cycle through history based on characters already typed on the line
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Keep Ctrl-Left and Ctrl-Right working when the above are used
bind '"\e[1;5C":forward-word'
bind '"\e[1;5D":backward-word'

if [[ -n "$HOMEBREW_PREFIX" && -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
  . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
elif [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi

alias l='eza -la'
alias la='eza -la'
alias ll='ls -lah'
alias v='nvim'
alias di='docker buildx imagetools inspect'

function et() {
  eza -alT --git -I'.git|node_modules|.mypy_cache|.pytest_cache|.venv' --color=always $argv | less -R
}

alias et1='et -L1'
alias et2='et -L2'
alias et3='et -L3'

# git aliases
alias gfa='git fetch --all --prune'
alias gm='git merge'
alias gst='git status'
alias gco='git checkout'
alias gb='git branch -v'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gp!='git push --force-with-lease'

alias mx='mise exec'
alias mr='mise run'

alias tf='terraform'

# NOTE: slow load ble [[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --noattach

GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWDIRTYSTATE=true
for git_prompt in \
  ${HOMEBREW_PREFIX:+"$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh"} \
  /usr/share/git/completion/git-prompt.sh
do
  if [[ -r "$git_prompt" ]]; then
    . "$git_prompt"
    break
  fi
done
if ! type -t __git_ps1 >/dev/null; then
  __git_ps1() { :; }
fi

# Colors from Tokyo Night Moon
PROMPT_BLUE='38;2;130;170;255'    # #82aaff
PROMPT_RED='38;2;255;117;127'     # #ff757f
PROMPT_GREEN='38;2;195;232;141'   # #c3e88d
PROMPT_YELLOW='38;2;255;199;119'  # #ffc777
PROMPT_MAGENTA='38;2;192;153;255' # #c099ff
PROMPT_FG='38;2;200;211;245'      # #c8d3f5

prompt_status() {
  if [ $? -ne 0 ]; then
    printf "%b" "\001\033[${PROMPT_RED}m\002😿 ${?}\001\033[0m\002"
  fi
}

COLORS=(
  '38;2;200;211;245'  # foreground (c8d3f5)
  '38;2;45;63;118'    # selection (2d3f76)
  '38;2;99;109;166'   # comment (636da6)
  '38;2;255;117;127'  # red (ff757f)
  '38;2;255;150;108'  # orange (ff966c)
  '38;2;255;199;119'  # yellow (ffc777)
  '38;2;195;232;141'  # green (c3e88d)
  '38;2;252;167;234'  # purple (fca7ea)
  '38;2;134;225;252'  # cyan (86e1fc)
  '38;2;192;153;255'  # pink (c099ff)
)

shuffle_array() {
  local i j tmp
  for (( i=${#COLORS[@]} - 1; i > 0; i-- )); do
    j=$(( RANDOM % (i + 1) ))
    tmp="${COLORS[i]}"
    COLORS[i]="${COLORS[j]}"
    COLORS[j]="$tmp"
  done
}

shuffle_array

colorized_path() {
  local pwd_path="${PWD/#$HOME/\~}"

  if [[ $pwd_path == "/" ]]; then
    printf "%b" "\001\033[${COLORS[0]}m\002/\001\033[0m\002"
    return
  fi

  if [[ $pwd_path == "~" ]]; then
    printf "%b" "\001\033[${COLORS[0]}m\002~\001\033[0m\002"
    return
  fi

  local colored_path=""
  IFS='/' read -ra parts <<< "$pwd_path"

  local color_index=0
  local num_colors=${#COLORS[@]}

  # If the first element is empty, it means the path is absolute (starts with /).
  if [[ -z "${parts[0]}" ]]; then
    colored_path="\001\033[${COLORS[color_index]}m\002/"
    ((color_index++))
  else
    colored_path="\001\033[${COLORS[color_index]}m\002${parts[0]}"
    ((color_index++))
  fi

  for part in "${parts[@]:1}"; do
    # Skip empty parts (which might happen with trailing slashes)
    if [[ -z "$part" ]]; then
      continue
    fi

    local color="${COLORS[((color_index % num_colors))]}"
    colored_path+="\001\033[0m\002/\001\033[${color}m\002${part}"
    ((color_index++))
  done

  colored_path+="\001\033[0m\002"
  printf "%b" "$colored_path"
}

case "$(uname -s)" in
  Darwin) PROMPT_OS_ICON='' ;;
  Linux)  PROMPT_OS_ICON='' ;;
  *)      PROMPT_OS_ICON='$' ;;
esac

PS1='$(__git_ps1 "\001\033[${PROMPT_YELLOW}m\002  %s \001\033[0m\002")'
PS1+='$(prompt_status) $(colorized_path)\n'
PS1+='\001\033[${PROMPT_GREEN}m\002${PROMPT_OS_ICON} \001\033[${PROMPT_MAGENTA}m\002\001\033[0m\002 '
