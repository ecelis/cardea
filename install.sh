#!/bin/sh
# Cardea Installer for Linux, FreeBSD and MacOS

set -e

echo "🪟 Setting up Cardea Vim..."

# Detect OS
OS=$(uname)

if [ "$OS" = "FreeBSD" ]; then
    echo "Detected FreeBSD. Using pkg..."
    # Note: Assumes user has sudo/root permissions
    pkg install -y node npm git fzf ripgrep
elif [ "$OS" = "Darwin" ]; then
    echo "Detected Mac OS. Using brew.."]
    brew install git
    brew install node 
    brew install fzf
    brew install ripgrep
    brew install vim
elif [ "$OS" = "Linux" ]; then
	if [ -f /etc/fedora-release ]; then
	    echo "Detected Fedora. Using dnf..."
	    sudo dnf install -y nodejs git fzf ripgrep
	elif [ -f /etc/redhat-release ]; then
	    echo "Detected Red Hat or Relative. Using dnf..."
	    sudo dnf install -y nodejs git fzf ripgrep
	fi
else
	echo "No supported system detected. Aborting."
	exit 0
fi

# Create symlink
if [ -f ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.bak
    echo "Backed up existing .vimrc to .vimrc.bak"
fi

ln -sf $(pwd)/.vimrc ~/.vimrc
echo "✅ Symlinked .vimrc"
echo "🚀 Open Vim and run :PlugInstall to complete setup."
