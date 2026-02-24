# Cardea Vim Distribution

**Cardea** is a modern, high-performance configuration for Vim 9.2+. Named after the Roman Goddess of Hinges, it serves as the functional successor to the classic Janus distribution—providing the "swing" and transition between a traditional editor and a modern IDE.

Built for Principal Engineers who value speed, asynchronous execution, and a "nerd-rocker" aesthetic.

## 🚀 Features

* **Vim 9.2 Optimized:** Leverages the latest performance improvements.
* **Asynchronous Intelligence:** Powered by `coc.nvim` for LSP support (Go, Python, C).
* **Blazing Fast Navigation:** Replaces the heavy CtrlP with `FZF`.
* **Minimalist UI:** Uses `lightline` and `gruvbox-material` for a clean, retro-computing look.
* **Git Integrated:** Full power of `vim-fugitive`.

## 🛠️ Installation

### Prerequisites

1.  **Vim 9.2+** (compiled with `+python3`).
2.  **Node.js** (required for CoC/LSP).
3.  **FZF** and **Ripgrep** (`rg`) installed on your system.

### Setup

Clone the repository and link the configuration:

```bash
git clone [https://github.com/your-username/cardea.git](https://github.com/your-username/cardea.git) ~/.vim_cardea
ln -s ~/.vim_cardea/.vimrc ~/.vimrc
