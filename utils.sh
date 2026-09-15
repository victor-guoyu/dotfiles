#!/bin/bash

# Detect machine type
case "$(uname -s)" in
Darwin)
  readonly MACHINE_TYPE="mac"
  ;;
Linux)
  # Check if it's Ubuntu
  if grep -q "Ubuntu" /etc/os-release 2>/dev/null; then
    readonly MACHINE_TYPE="linux"
  else
    echo "Error: Unsupported machine type. Only Mac and Linux (Ubuntu) are supported." >&2
    exit 1
  fi
  ;;
*)
  echo "Error: Unsupported machine type. Only Mac and Linux (Ubuntu) are supported." >&2
  exit 1
  ;;
esac

link_dotfiles() {
  local src="$1"
  local destination="$2"

  if [ -L "${destination}" ]; then
    echo "${destination} symlink already exists, skipping"
  elif [ -f ${destination} ]; then
    echo "${destination} is a file, skipping"
  elif [ -d ${destination} ]; then
    echo "${destination} is a dir, skipping"
  else
    echo "symlinking ${src}"
    ln -s ~/dotfiles/"${src}" "${destination}"
  fi
}

install_package() {
  local package_name="$1"

  if [ -z "$package_name" ]; then
    echo "Error: Package name is required" >&2
    return 1
  fi

  case "$MACHINE_TYPE" in
  mac)
    brew_install "$package_name"
    ;;
  linux)
    debian_install "$package_name"
    ;;
  *)
    echo "Error: Unsupported machine type: $MACHINE_TYPE" >&2
    return 1
    ;;
  esac
}

install_homebrew() {
  # Only install on Mac
  if [ "$MACHINE_TYPE" != "mac" ]; then
    echo "Homebrew is only supported on Mac, skipping"
    return 0
  fi

  # Check if already installed
  if command -v brew &>/dev/null; then
    echo "Homebrew is already installed, skipping"
    return 0
  fi

  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

brew_install() {
  local package_name="$1"

  if [ -z "$package_name" ]; then
    echo "Error: Package name is required" >&2
    return 1
  fi

  # Only install on Mac
  if [ "$MACHINE_TYPE" != "mac" ]; then
    echo "brew is only supported on Mac, skipping $package_name"
    return 0
  fi

  # Check if already installed
  if brew list "$package_name" &>/dev/null; then
    echo "$package_name is already installed, skipping"
  else
    echo "Installing $package_name via brew..."
    brew install "$package_name"
  fi
}

debian_install() {
  local package_name="$1"

  if [ -z "$package_name" ]; then
    echo "Error: Package name is required" >&2
    return 1
  fi

  # Only install on Linux
  if [ "$MACHINE_TYPE" != "linux" ]; then
    echo "apt-get is only supported on Linux, skipping $package_name"
    return 0
  fi

  # Check if already installed
  if dpkg -l | grep -q "^ii.*$package_name"; then
    echo "$package_name is already installed, skipping"
  else
    echo "Installing $package_name via apt-get..."
    sudo apt-get install -y "$package_name"
  fi
}

install_cask() {
  local package_name="$1"

  if [ -z "$package_name" ]; then
    echo "Error: Package name is required" >&2
    return 1
  fi

  # Casks are only available on Mac
  if [ "$MACHINE_TYPE" != "mac" ]; then
    echo "Casks are only supported on Mac, skipping $package_name"
    return 0
  fi

  # Check if already installed
  if brew list --cask "$package_name" &>/dev/null; then
    echo "$package_name is already installed, skipping"
  else
    echo "Installing $package_name via brew cask..."
    # if the app is already installed via other means, --force will override the existing installation.
    brew install --cask "$package_name" --force
  fi
}

clone_repo() {
  local repo_url="$1"
  local destination="$2"

  if [ -z "$repo_url" ] || [ -z "$destination" ]; then
    echo "Error: Both repo URL and destination are required" >&2
    return 1
  fi

  if [ -d "$destination" ]; then
    echo "$(basename "$destination") already exists, skipping"
  else
    echo "Cloning $repo_url to $destination..."
    git clone "$repo_url" "$destination"
  fi
}

install_fnm() {
  if command -v fnm &>/dev/null; then
    echo "fnm is already installed, skipping"
    return 0
  fi

  case "$MACHINE_TYPE" in
  mac)
    brew_install "fnm"
    ;;
  linux)
    # No apt package, so use upstream's installer. --skip-shell stops it
    # appending its own block to the symlinked .zshrc; --install-dir puts the
    # binary somewhere .zprofile already has on PATH (the default,
    # ~/.local/share/fnm, is not).
    echo "Installing fnm via upstream install script..."
    curl -fsSL https://fnm.vercel.app/install |
      bash -s -- --skip-shell --install-dir "$HOME/.local/bin"
    ;;
  *)
    echo "Error: Unsupported machine type: $MACHINE_TYPE" >&2
    return 1
    ;;
  esac
}
