use config

if (which smpt | length) == 0 {
  use installer
  installer smpt download
}

mkdir ~/.cache/smpt
smpt init nu | save -f ~/.cache/smpt/init.nu
source ~/.cache/smpt/init.nu

alias c = clear
alias ca = cargo
alias q = exit
alias v = nvim
alias t = tmux -u
alias f = fzf
alias lg = lazygit
alias g = git
alias gi = cd ($"(grm root)/(grm list | fzf)" | str replace "\n" "")
alias b = cd ..
alias bb = cd ../..
alias ls = ls -a
alias ll = ls -la
