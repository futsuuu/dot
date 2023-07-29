# Nushell Environment Config File

$env.DENO_TLS_CA_STORE = "system"
$env.LANG = "en_US.utf-8"
$env.EDITOR = "nvim"
$env.FZF_DEFAULT_OPTS = "
  --prompt=' ' --height 60% --border --margin=0,4 --reverse
  --cycle --no-mouse
  --color fg:gray,hl:blue,fg+:white,bg:black,bg+:black,hl+:blue
  --color info:green,prompt:blue,spinner:yellow,pointer:red,marker:red,border:gray
"

mkdir ~/.cache/smpt
~/dev/github.com/futsuuu/dot/smpt/target/release/smpt init nu | save -f ~/.cache/smpt/init.nu

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
