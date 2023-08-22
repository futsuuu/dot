export def build [] {
  let build_path = ($nu.temp-path | path join "neovim-build")
  let install_path = ($env.HOME | path join "bin" "_" "nvim")

  if ($build_path | path exists) {
    rm -rvf $build_path
  }

  if ($install_path | path exists) {
    rm -rvf $install_path
  }

  sudo pacman -S --noconfirm --needed base-devel cmake unzip ninja curl

  git clone --depth 1 https://github.com/neovim/neovim $build_path
  cd $build_path

  sh $"make CMAKE_INSTALL_PREFIX=($install_path) CMAKE_BUILD_TYPE=Release install"

  ln -sf ($install_path | path join "bin" "nvim") ($env.HOME | path join "bin" "nvim")

  nvim -V -v
}
