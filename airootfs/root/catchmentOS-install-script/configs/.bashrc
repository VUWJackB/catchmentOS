#
# ~/.bashrc
#

neofetch --source ~/.config/neofetch/art --ascii_colors 2 4

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

eval "$(starship init bash)"
