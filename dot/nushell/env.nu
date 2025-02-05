# Nushell Environment Config File

let home = $nu.home-path

$env.banner = true

export-env {
  mut path = (
    $env
      | get PATH
      | split row (char esep)
      | append ($home | path join "bin")
      | append ($home | path join ".nrtm" "bin")
      | append ($home | path join ".cargo" "bin")
      | append ($home | path join ".deno" "bin")
  )

  $path = ($path | uniq)

  if $nu.os-info.name == "windows" {
    $env.Path = $path
  } else {
    $env.PATH = $path
  }
}

if $nu.os-info.name == "linux" {
  $env.XDG_CONFIG_HOME = ($home | path join ".config")
  $env.XDG_CACHE_HOME = ($home | path join ".cache")
  $env.XDG_DATA_HOME = ($home | path join ".local" "share")
  $env.XDG_STATE_HOME = ($home | path join ".local" "state")
}

$env.LANG = "en_US.UTF-8"
$env.EDITOR = "nvim"
$env.VISUAL = $env.EDITOR
$env.BROWSER = "thorium-browser"

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
