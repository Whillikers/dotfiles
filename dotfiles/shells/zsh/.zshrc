# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/shells/zsh//.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# ~/.config/shells/zsh/.zshrc
# Startup commands for interactive zsh sessions.
#

### Start with generic interactive shell config
source ~/.config/shells/generic/interactive.sh

### Suffix aliases to "open with X"
alias -s pdf=okular
alias -s {svg,gif}=chromium
alias -s {jpg,jpeg,JPG,JPEG,png,pnm,tif,tiff,bmp}="feh -d --draw-tinted"
alias -s {mp3,wav,ogg,avi,h264,mp4,mpg,mpeg}=vlc
alias -s xcf=gimp

### Shell settings
# Share history file amongst all zsh sessions, ignoring duplicates
setopt append_history share_history histignorealldups

# Use extended glob options
setopt extendedglob

# Error when a glob doesn't match
setopt nomatch

# Get updates from background processes immediately
setopt notify

# cd into directories by name
setopt autocd

# No beeping
unsetopt beep

# "emacs-style" input
bindkey -e

# Bind ctrl-r to history search
bindkey "^r" history-incremental-search-backward

### Completion settings
# The following lines were added by compinstall
zstyle :compinstall filename '${HOME}/.config/shells/zsh/.zshrc'

autoload -Uz compinit
compinit -d ${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}
# End of lines added by compinstall

#
# Antigen manages plugins.
#
source /usr/share/zsh/share/antigen.zsh

### Set up oh-my-zsh
antigen use oh-my-zsh

# We'll update manually
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

# Try to correct unrecognized command names and filenames
ENABLE_CORRECTION=false

# Speed up VCS status checks
DISABLE_UNTRACKED_FILES_DIRTY=true

### Set up plugins
antigen bundles <<EOBUNDLES
    # Add colors to man pages, and the "colored" prefix to try to color other pages
    colored-man-pages

    # Autocompletion support
    docker
    gcloud
    gitfast
    pip
    ripgrep

    # fasd integration
    fasd

    # Suggest commands as you type
    zsh-users/zsh-autosuggestions

    # Syntax highlighting in the shell
    zdharma/fast-syntax-highlighting

    # Fish-style up-arrow history searching
    zsh-users/zsh-history-substring-search

    # Add more completion definitions
    zsh-users/zsh-completions
EOBUNDLES

### zsh-autosuggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Speed up pasting by disabling autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# fasd
export _FASD_DATA=${XDG_DATA_HOME}/fasd

# Powerlevel10K theme
antigen theme romkatv/powerlevel10k

# Apply changes
antigen apply

### colored-man-pages
# bold & blinking mode
less_termcap[mb]="${fg_bold[blue]}"
less_termcap[md]="${fg_bold[blue]}"
# underlining
less_termcap[us]="${fg_bold[yellow]}"
# standout mode
less_termcap[so]="${fg_bold[black]}${bg[green]}"

### fast-syntax-highlighting
FAST_HIGHLIGHT_STYLES[path]='fg=blue'
FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=blue,bold'
FAST_HIGHLIGHT_STYLES[globbing]='fg=magenta,bold'
FAST_HIGHLIGHT_STYLES[history-expansion]='fg=magenta,bold'
FAST_HIGHLIGHT_STYLES[mathvar]='fg=magenta,bold'

# Async highlighting for faster remote connections
FAST_HIGHLIGHT[use_async]=1

### Powerlevel10k prompt
# Load the prompt
[[ ! -f ~/.config/shells/zsh/.p10k.zsh ]] || source ~/.config/shells/zsh/.p10k.zsh

### zsh-history-substring-search
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='standout'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=black'
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

### Pyenv completion
source /usr/share/zsh/site-functions/_pyenv

### Restore clobbered vim alias
alias v='PYENV_VERSION=system nvim'
