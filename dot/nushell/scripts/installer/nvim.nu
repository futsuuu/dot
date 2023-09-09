export def build [version?: string] {
  let build_path = ($nu.temp-path | path join "neovim-build")
  let install_path = ($env.HOME | path join "bin" "_" "nvim")

  if ($build_path | path exists) {
    rm -rvf $build_path
  }

  # sudo pacman -S --noconfirm --needed base-devel cmake unzip ninja curl
  # use sudo only when necessary
  for package in ["base-devel", "cmake", "unzip", "ninja", "curl"] {
    if (pacman -Qi $package | complete).exit_code != 0 {
      sudo pacman -S --noconfirm $package
    }
  }

  git clone --filter=blob:none https://github.com/neovim/neovim $build_path
  cd $build_path

  if $version != null {
    git checkout $version
  }

  if ($install_path | path exists) {
    rm -rvf $install_path
  }

  sh -c $"make CMAKE_INSTALL_PREFIX=($install_path) CMAKE_BUILD_TYPE=Release install"

  ln -sf ($install_path | path join "bin" "nvim") ($env.HOME | path join "bin" "nvim")

  nvim -V -v
}
