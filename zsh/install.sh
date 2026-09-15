#!/bin/bash
# zsh + oh-my-zsh setup.
# Relies on helpers (debian_install, clone_repo, link_dotfiles) from utils.sh,
# which install.sh sources before this file.

install_zsh() {
  # mac ships zsh; debian may need it
  debian_install "zsh"

  # Official oh-my-zsh installer. KEEP_ZSHRC preserves our symlinked .zshrc,
  # RUNZSH/CHSH keep it non-interactive.
  if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  local zsh_custom="${HOME}/.oh-my-zsh/custom"
  clone_repo "https://github.com/zsh-users/zsh-autosuggestions" "${zsh_custom}/plugins/zsh-autosuggestions"
  clone_repo "https://github.com/zsh-users/zsh-completions" "${zsh_custom}/plugins/zsh-completions"
  clone_repo "https://github.com/zsh-users/zsh-history-substring-search" "${zsh_custom}/plugins/zsh-history-substring-search"
  clone_repo "https://github.com/zsh-users/zsh-syntax-highlighting" "${zsh_custom}/plugins/zsh-syntax-highlighting"

  # tool completions — $ZSH_CUSTOM/completions is on oh-my-zsh's fpath
  if command -v fnm >/dev/null; then
    mkdir -p "${zsh_custom}/completions"
    fnm completions --shell zsh >"${zsh_custom}/completions/_fnm"
  fi

  # symlink config
  link_dotfiles "zsh/zshrc" "${HOME}/.zshrc"
  link_dotfiles "zsh/zprofile" "${HOME}/.zprofile"
}
