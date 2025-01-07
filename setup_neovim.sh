#!/bin/bash

# 更新套件列表並安裝必要工具
sudo apt-get update && sudo apt-get install -y build-essential procps curl file git

# 安裝 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 設定 Homebrew 環境變數
if test -d ~/.linuxbrew; then
    eval "$(~/.linuxbrew/bin/brew shellenv)"
elif test -d /home/linuxbrew/.linuxbrew; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 配置 shell 啟動文件
if [ -n "$BASH_VERSION" ]; then
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
elif [ -n "$ZSH_VERSION" ]; then
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc
fi

# 驗證 Homebrew 安裝
brew doctor

# 安裝示例程式和工具
brew install hello
brew install neovim

# 備份舊的 Neovim 配置並下載新的配置
if [ -d ~/.config/nvim ]; then
    mv ~/.config/nvim ~/.config/nvim.bak
fi
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# 啟動 Neovim
nvim