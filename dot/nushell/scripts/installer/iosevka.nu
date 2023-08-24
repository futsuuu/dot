export def download [] {
  curl -LO https://github.com/futsuuu/iosevka-custom/releases/latest/download/font.zip
  unzip font.zip
  # font/
  #   IosevkaCutom ~ .ttf
  rm font.zip

  if $nu.os-info.name != "linux" {
    return
  }

  let target_path = ($env.XDG_DATA_HOME | path join "fonts" "ttf" "IosevkaCutom")
  if not ($target_path | path dirname | path exists) {
    mkdir -v ($target_path | path dirname)
  } else if ($target_path | path exists) {
    rm -rvf $target_path
  }
  mv -vf font $target_path
}
