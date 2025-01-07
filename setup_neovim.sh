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

# 配置 shell 啟動文件 (非 root 使用者)
if [ -n "$BASH_VERSION" ]; then
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
elif [ -n "$ZSH_VERSION" ]; then
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc
fi

# 詢問是否將配置加入 root 使用者
read -p "是否將 Homebrew 配置加入 root 使用者的啟動文件？ (y/N): " add_to_root
if [[ "$add_to_root" =~ ^[Yy]$ ]]; then
    if sudo test -d /root; then
        if [ -n "$BASH_VERSION" ]; then
            sudo bash -c "echo \"eval \\\"\$($(brew --prefix)/bin/brew shellenv)\\\"\" >> /root/.bashrc"
        elif [ -n "$ZSH_VERSION" ]; then
            sudo bash -c "echo \"eval \\\"\$($(brew --prefix)/bin/brew shellenv)\\\"\" >> /root/.zshrc"
        fi
        echo "已將 Homebrew 配置加入 root 的 shell 啟動文件。"
    else
        echo "無法找到 /root 目錄，無法配置 root 使用者環境。"
    fi
else
    echo "跳過配置 root 使用者的啟動文件。"
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

# 詢問是否將 Neovim 配置加入 root 使用者
read -p "是否將 Neovim 配置安裝到 root 使用者？ (y/N): " add_nvim_to_root
if [[ "$add_nvim_to_root" =~ ^[Yy]$ ]]; then
    if sudo test -d /root; then
        sudo mkdir -p /root/.config
        if sudo test -d /root/.config/nvim; then
            sudo mv /root/.config/nvim /root/.config/nvim.bak
            echo "已備份 root 使用者的舊 Neovim 配置到 /root/.config/nvim.bak。"
        fi
        sudo git clone https://github.com/LazyVim/starter /root/.config/nvim
        sudo rm -rf /root/.config/nvim/.git
        echo "已將 Neovim 配置安裝到 root 使用者。"
    else
        echo "無法找到 /root 目錄，無法配置 root 使用者的 Neovim 環境。"
    fi
else
    echo "跳過配置 root 使用者的 Neovim 環境。"
fi

# 啟動 Neovim
nvim