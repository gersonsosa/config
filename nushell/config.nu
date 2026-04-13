# config.nu
#
# Installed by:
# version  [] {  "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# Only for Nu itself
hide-env XDG_CONFIG_HOME
hide-env XDG_DATA_HOME

use std/util "path add"
$env.CARGO_HOME = ($env.HOME | path join ".cargo")
$env.config.buffer_editor = "nvim"
load-env { "EDITOR": "nvim", "VISUAL": "nvim" }
$env.config.show_banner = false

path add "/usr/local/bin"
path add "~/.local/bin"
path add "~/.opencode/bin"
path add "~/code/elastic/cloud-cli/main/bin/"
path add ($env.CARGO_HOME | path join "bin")

$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"
path add "/opt/homebrew/bin"
path add "/opt/homebrew/sbin"
$env.MANPATH = (($env.MANPATH? | default "") | prepend "/opt/homebrew/share/man")
$env.INFOPATH = (($env.INFOPATH? | default "") | path join "/opt/homebrew/share/info")

$env.PROMPT_COMMAND_RIGHT = {||
    let branch = (do -i { git rev-parse --abbrev-ref HEAD } | complete | get stdout | str trim)
    if $branch != "" and $branch != "HEAD" and $branch != "fatal: not a git repository (or any of the parent directories): .git" {
        $" ($branch)"
    } else {
        (date now | format date "%Y-%m-%d %H:%M:%S")
    }
}

alias v = nvim
alias vim = nvim
alias l = eza -la
alias la = eza -la
def ll [] { ls | sort-by type name -i | grid -c | str trim }
def uuidgen [] { ^uuidgen | tr A-F a-f }

def et [ --level: int, ...args ] {
  ^eza ...[
    "-alT"
    "--git"
    "-I" ".git|node_modules|.mypy_cache|.pytest_cache|.venv"
    "--color=always"
    "-L" $level
    ...$args
  ] | delta
}

alias et1 = et --level=1
alias et2 = et --level=2
alias et3 = et --level=3

alias gfa = git fetch --all --prune 
alias gm = git merge 
alias gst = git status 
alias gco = git checkout 
alias gb = git branch -v 
alias gp = git push 
alias gpf = git push --force-with-lease 
alias gp! = git push --force-with-lease 

if ($nu.home-dir | path join ".config" "nu_scripts" | path exists) { source ($nu.home-dir | path join ".config" "nu_scripts" "custom-completions" "git" "git-completions.nu") }
# source ($nu.default-config-dir | path join "scripts" "aws-helper.nu")

alias mx = mise exec 
alias mr = mise run 
alias tf = terraform 

# in config.nu
let vendor_dir = $nu.vendor-autoload-dirs | last
let mise_path = $vendor_dir | path join mise.nu

mkdir $vendor_dir
^mise activate nu | save $mise_path --force
