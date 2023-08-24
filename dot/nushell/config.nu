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

  print "current: " $env.NVIM_APPNAME "\n" -n
  mut nvim_configs = []

  let config_dir = if $nu.os-info.name == "windows" { $env.LOCALAPPDATA } else { $env.XDG_CONFIG_HOME }

  for $entry in (ls $config_dir).name {
    if $env.NVIM_APPNAME == ($entry | path basename) {
      continue
    }
    if ($entry | path type) not-in ["dir", "symlink"] {
      continue
    }
    if ((ls $entry).name
      | where { |e| ($e =~ "init.vim") or ($e =~ "init.lua") }
      | length
    ) < 1 {
      continue
    }

    $nvim_configs = ($nvim_configs | insert 0 ($entry | path basename))
  }

  $env.NVIM_APPNAME = ($nvim_configs | str join "\n" | fzf)
  print $env.NVIM_APPNAME
}
