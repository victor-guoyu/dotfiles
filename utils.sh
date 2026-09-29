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

# Set by apt_prepare once the first missing package has had the root check
# and the apt refresh, so the rest of the run skips both.
APT_PREPARED=""

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

  # Check if already installed. dpkg-query matches the exact package name;
  # grepping `dpkg -l` let "zsh" match "zsh-common" and skip the real one.
  if dpkg-query -W -f='${Status}' "$package_name" 2>/dev/null | grep -q "ok installed"; then
    echo "$package_name is already installed, skipping"
  else
    apt_prepare || exit 1
    echo "Installing $package_name via apt-get..."
    as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y "$package_name"
  fi
}

as_root() {
  if [ "$(id -u)" -eq 0 ]; then "$@"; else sudo "$@"; fi
}

# apt needs root: directly when we are root (a fresh container), otherwise
# through sudo. Checked at the first package that is actually missing, so a
# container user with sudo but no password stops with a reason rather than
# sudo's bare "a password is required" -- and a re-run after root installed
# the packages goes through, since it needs no root.
apt_prepare() {
  if [ -n "$APT_PREPARED" ]; then
    return 0
  fi

  # `sudo true`, not `sudo -v`: -v wants a password unless *every* sudoers
  # entry for the user is NOPASSWD, so a user in the password-requiring sudo
  # group with a NOPASSWD rule on top was refused. A real command follows the
  # rules apt-get will, and still prompts once, which sudo then caches.
  if [ "$(id -u)" -ne 0 ] && ! { command -v sudo &>/dev/null && sudo true; }; then
    echo "Error: installing packages needs root or sudo, and $(id -un) has neither." >&2
    echo "The config is linked already. For the packages, re-run install.sh as root" >&2
    echo "(in a container: docker exec -u root ...), then again as $(id -un)." >&2
    return 1
  fi

  # Container images delete /var/lib/apt/lists to stay small, and then every
  # install fails with "has no installation candidate".
  echo "Refreshing the apt package lists..."
  as_root apt-get update
  APT_PREPARED=1
}

install_neovim() {
  case "$MACHINE_TYPE" in
  mac)
    brew_install "neovim"
    ;;
  linux)
    # Not apt: Ubuntu 24.04 ships 0.9.5 and LazyVim refuses anything below
    # 0.11.2. Upstream's release build goes under ~/.local, so it needs no
    # root, and .zprofile puts ~/.local/bin ahead of /usr/bin.
    if [ -x "$HOME/.local/bin/nvim" ]; then
      echo "neovim is already installed in ~/.local/bin, skipping"
      return 0
    fi

    local arch
    case "$(uname -m)" in
    x86_64) arch="x86_64" ;;
    aarch64 | arm64) arch="arm64" ;;
    *)
      echo "Error: no neovim release build for $(uname -m)" >&2
      return 1
      ;;
    esac

    echo "Installing neovim via GitHub release..."
    mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"
    curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${arch}.tar.gz" |
      tar -xz -C "$HOME/.local/opt"
    ln -sf "$HOME/.local/opt/nvim-linux-${arch}/bin/nvim" "$HOME/.local/bin/nvim"
    ;;
  *)
    echo "Error: Unsupported machine type: $MACHINE_TYPE" >&2
    return 1
    ;;
  esac
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

install_buf() {
  if command -v buf &>/dev/null; then
    echo "buf is already installed, skipping"
    return 0
  fi

  case "$MACHINE_TYPE" in
  mac)
    brew_install "buf"
    ;;
  linux)
    # No apt package. Upstream ships a single static binary per platform,
    # named buf-$(uname -s)-$(uname -m), so this needs no version pin and no
    # tarball. ~/.local/bin is already on PATH via .zprofile (same reasoning
    # as install_fnm).
    echo "Installing buf via GitHub release..."
    mkdir -p "$HOME/.local/bin"
    curl -fsSL \
      "https://github.com/bufbuild/buf/releases/latest/download/buf-$(uname -s)-$(uname -m)" \
      -o "$HOME/.local/bin/buf" &&
      chmod +x "$HOME/.local/bin/buf"
    ;;
  *)
    echo "Error: Unsupported machine type: $MACHINE_TYPE" >&2
    return 1
    ;;
  esac
}
