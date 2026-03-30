export PATH="$HOME/.local/bin:$PATH"

autoload -U colors && colors
PROMPT='%B%F{#afeeee}%n%F{#00ffff}@%F{#f0ffff}%m %F{#00ffff}%~ %F{#ffffff}%#%f '

HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=50000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z A-Z}={A-Z a-z}'
zmodload zsh/complist

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
