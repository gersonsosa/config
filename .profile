export EDITOR=nvim
export LANG=en_US.UTF-8
export LANGUAGE=en_US
export LC_CTYPE='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export LC_MESSAGES='en_US.UTF-8'

export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.local/bin"

# optionals
export PATH="$PATH:/Users/gersonsosa/Library/Application Support/JetBrains/Toolbox/scripts"
export PATH=/Users/gersonsosa/.opencode/bin:$PATH

. "$HOME/.cargo/env"
eval "$(/opt/homebrew/bin/brew shellenv)"

test -f "/Library/Scripts/elastic-env.sh" && . "/Library/Scripts/elastic-env.sh"

if [[ "$SHELL" =~ "bash" ]]; then
  [ -f ~/.bashrc ] && source ~/.bashrc
fi
