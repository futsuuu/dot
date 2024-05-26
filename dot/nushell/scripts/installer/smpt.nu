export def download [] {
  let link = (
    "https://github.com/futsuuu/smpt/releases/latest/download/smpt-"
    + (if $nu.os-info.name == macos { "unversal2" } else { $nu.os-info.arch })
    + "-"
    + (match $nu.os-info.name {
      linux => "unknown-linux-musl",
      windows => "pc-windows-msvc.exe",
      macos => "apple-darwin",
    })
  )
  let out_path = $nu.home-path | path join bin (if $nu.os-info.name == windows { "smpt.exe" } else { "smpt" })
  curl -o $out_path -L $link
  if (which chmod | is-not-empty) {
    chmod +x $out_path
  }
}
