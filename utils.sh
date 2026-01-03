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
      # Check if package is already installed
      if brew list "$package_name" &>/dev/null; then
        echo "$package_name is already installed, skipping"
      else
        echo "Installing $package_name via brew..."
        brew install "$package_name"
      fi
      ;;
    linux)
      # Check if package is already installed
      if dpkg -l | grep -q "^ii.*$package_name"; then
        echo "$package_name is already installed, skipping"
      else
        echo "Installing $package_name via apt-get..."
        sudo apt-get install -y "$package_name"
      fi
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
    brew install --cask "$package_name"
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

