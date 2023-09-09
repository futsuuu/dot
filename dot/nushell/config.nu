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
alias gi = cd ($"(ghq root)/(ghq list | fzf)" | str replace "\n" "")
alias b = cd ..
alias bb = cd ../..
alias ls = ls -a
alias ll = ls -la

def-env select_nvim_appname [] {
  $env.NVIM_APPNAME = ($env.NVIM_APPNAME? | default "nvim")

  print $"current: ($env.NVIM_APPNAME)"

  let config_dir = if $nu.os-info.name == "windows" { $env.LOCALAPPDATA } else { $env.XDG_CONFIG_HOME }

  let nvim_configs = (ls $config_dir | par-each { |entry|
    if $entry.type not-in ["dir", "symlink"] {
      return
    }
    if (ls $entry.name
      | where { |e| ($e.name | path basename) in ["init.vim", "init.lua"] }
      | length
    ) == 1 {
      return ($entry.name | path basename)
    }
  } | insert 1 "NONE")

  $env.NVIM_APPNAME = ($nvim_configs | str join "\n" | fzf)
  print $env.NVIM_APPNAME
}
