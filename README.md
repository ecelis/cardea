# Cardea Vim Distribution

**Cardea** is a modern, high-performance configuration for Vim 9.2+. Named
after the Roman Goddess of Hinges, it serves as the functional successor to the
classic Janus distribution—providing the "swing" and transition between a
traditional editor and a modern IDE.

Built for engineers who value speed, asynchronous execution, and a "nerd-rocker" aesthetic.

🎨 Aesthetics

Cardea uses the Gruvbox Material (Soft) theme to provide a high-contrast yet eye-friendly environment reminiscent of classic Unix workstations.

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

#### FreeBSD Requisites

At the time of the intial commit FreeBSD still ships vim 9.1
```sh
pkg install \
    gettext-runtime \
    gettext-tools \
    indexinfo libffi \
    libtextstyle \
    mpdecimal \
    pkgconf \
    readline \
    gmake \
    gcc
```

### Setup

Clone the repository and link the configuration:

```bash
git clone git@github.com:ecelis/cardea.git ~/.vim_cardea
cd ~/.vim_cardea
chmod +x install.sh
./install.sh
```

Open Vim; the configuration is set to automatically download vim-plug and install all plugins on the first run.
Language Support

Once inside Vim, install the engines for your primary stack:
Vim Script

```vim
:CocInstall coc-go coc-pyright coc-json
```

## 🏠 The Welcome Dashboard

When launching `vim` without arguments, Cardea presents a specialized dashboard:
* **Quick Access:** Press the shortcut key next to any recent file to open it.
* **Bookmarks:** Built-in shortcuts for configuration files (`c` for .vimrc).
* **Identity:** Displays the Cardea ASCII header and current working directory.

## ⌨️ Keybindings

Cardea uses the Spacebar as the <Leader> key for ergonomic, high-speed navigation.

### General & Navigation

|Key|Action|
|---|------|
|`<Leader> f`|Find Files (via FZF)|
|`<Leader> b`|Buffers (Switch between open files)|
|`<Leader> n`|NERDTree (Toggle file explorer sidebar)|
|`<Leader> g`|Git Status (via Fugitive)|
|`CTRL + j/k/h/l`|Navigate between split windows|

### Code Intelligence (LSP)

|Key|Action|
|---|------|
|`gd`	|Go to Definition|
|`gy`	|Go to Type Definition|
|`gr`	|Find References|
|`K`	|Show Documentation (Hover)|
|`<Leader> rni`	|Rename Symbol (Refactor)|
|`<Tab>`	|Trigger Autocomplete / Next Item|
|`K`|Show Documentation (Hover)|
|`CTRL + f`|Scroll Down in Documentation window|
|`CTRL + b`|Scroll Up in Documentation window|

### Editing

|Key|Action|
|---|------|
|`<Tab>`|Navigate down the autocomplete menu|
|`<S-Tab>`|Navigate up the autocomplete menu|
|`<Enter>`|Confirm selection (No new line)|
|`<Leader> w`|Wrap Paragraph (Hard break at 72 chars)|
|`<Leader> tw`|"Toggle Wrap (Visual only, no line breaks)"|

### Misc

|Key|Action|
|---|------|
|`<Leader> t`|Toggle Theme (Switch between Tokyo Night and Gruvbox)|

### Editing Defaults

- Line Numbers: Hybrid (Absolute current line + Relative others).
- Indentation: 4 spaces (Expandtab enabled).
- Clipboard: Integrated with system clipboard (unnamedplus).

## 🐹 Go Development Environment (IDE Features)

Cardea is pre-configured to handle Go development with `gopls`.

### Key Go Features:
* **Auto-Import:** Missing packages are added, and unused ones are removed on save.
* **Go-to-Definition:** Instant jumping to source code or standard library.
* **Type Information:** Hover over any variable to see its underlying struct or interface.
* **Test Integration:** Run tests directly from the buffer.

### Go-Specific Keybindings:
| Key | Action |
|-----|--------|
| `gd` | Go to Definition |
| `gi` | Go to Implementation (useful for interfaces) |
| `gr` | Find all references of a function/struct |
| `:OR` | **Organize Imports** (manual trigger) |

### Setup for Go
Inside Vim, run:
`:CocInstall coc-go`

---
_“Janus watches the gate; Cardea moves the hinge.”_

## 💾 Session Management

Cardea allows you to save and restore your entire workspace (splits,
buffers, and cursor positions).
You never have to worry about losing your workspace layout:
* **Auto-Save:** On exit, your current state is automatically saved to a
global session called `LastSession`.
* **One-Key Restore:** Simply select `LastSession` from the welcome
dashboard to resume exactly where you were.
* **Manual Control:** Use `:Ssave <name>` if you want to keep a
permanent snapshot of a specific project.

| Key | Action |
|-----|------|
| `<Leader> ss` | **Save Session** (Local to current directory) |
| `<Leader> sl` | **Load Session** (From current directory) |
| `:Ssave <name>` | **Global Save** (Will appear on Startify dashboard) |
| `:Sload <name>` | **Global Load** |
| `:Sdelete <name>`| **Delete Session** |
