# Nushell Environment Config File

let home = $nu.home-path

$env.PATH = (
  $env.PATH
    | split row (char esep)
    | prepend ($home | path join ".cargo" "bin")
    | prepend ($home | path join ".deno" "bin")
    | prepend ($home | path join "bin")
    | uniq
)

export-env {
  load-env {
    LANG: "en_US.UTF-8"
    SHELL: $nu.current-exe
    EDITOR: "nvim"
    VISUAL: $env.EDITOR
    BROWSER: "vivaldi-stable"
  }
  if $nu.os-info.name == "linux" {
    load-env {
      XDG_CONFIG_HOME: ($home | path join ".config")
      XDG_CACHE_HOME: ($home | path join ".cache")
      XDG_DATA_HOME: ($home | path join ".local" "share")
      XDG_STATE_HOME: ($home | path join ".local" "state")
    }
  }
}

$env.DENO_TLS_CA_STORE = "system"
$env.FZF_DEFAULT_OPTS = "
--prompt='> ' --height 60% --border --margin=0,4 --reverse
--cycle --no-mouse
--color fg:gray,hl:blue,fg+:white,bg:black,bg+:black,hl+:blue
--color info:green,prompt:blue,spinner:yellow,pointer:red,marker:red,border:gray
"

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

$env.NU_LIB_DIRS = [
  ($nu.config-path | path dirname | path join 'scripts')
]
$env.NU_PLUGIN_DIRS = [
   ($nu.config-path | path dirname | path join 'plugins')
 ]
