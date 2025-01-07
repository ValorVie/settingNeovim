# Linux 開發環境自動化設定腳本

此專案提供一個 Bash 腳本，用於自動安裝必要工具、配置 Homebrew 以及設置 Neovim 開發環境。

## 功能

- 自動更新系統套件列表
- 安裝必要的開發工具（如 `build-essential`, `curl`, `git` 等）
- 安裝並配置 [Homebrew](https://brew.sh/)
- 安裝示例工具 `hello` 和 `neovim`
- 自動備份現有的 Neovim 配置
- 安裝 [LazyVim Starter](https://github.com/LazyVim/starter) 作為 Neovim 的預設配置

## 使用方式
```shell
cd ~
chmod +x setup.sh
./setup.sh
```