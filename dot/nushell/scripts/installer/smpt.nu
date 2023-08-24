export def download [] {
  let asset_name = (
    "smpt-"
    + $nu.os-info.arch
    + "-"
    + (match $nu.os-info.name {
      linux => "unknown-linux-musl",
      windows => "pc-windows-msvc",
      macos => "apple-darwin",
    })
    + ".zip"
  )
  curl -LO $"https://github.com/futsuuu/smpt/releases/latest/download/($asset_name)"
  ^unzip -o $asset_name -d ($nu.home-path | path join "bin")
  rm -vf $asset_name
}
