# 🛠️ Dotfiles Setup (Debian + i3wm)

Welcome to my personal dotfiles repository! This setup is built for speed, minimalism, and keyboard-driven productivity on **Debian ** using **i3wm**. 

Configurations are dynamically managed and symlinked using **GNU Stow**.

![Rice Overview](https://img.shields.io/badge/Environment-i3wm-blue?style=for-the-badge&logo=i3)
![Distro](https://img.shields.io/badge/OS-Debian%20Trixie-D10A34?style=for-the-badge&logo=debian)
![Theme](https://img.shields.io/badge/Theme-Nord%20%2F%20Tokyo%20Night-7aa2f7?style=for-the-badge)

---

## 📦 What's Inside?

| Component | Application | Description |
| :--- | :--- | :--- |
| **WM** | `i3wm` | Tiling window manager configured with dynamic autotiling |
| **Terminal** | `Alacritty` | GPU-accelerated terminal emulator |
| **Status Bar** | `Polybar` | Fully customized bar featuring system monitors and controls |
| **Launcher** | `Rofi` | Clean application launcher and powermenu launcher |
| **Compositor** | `Picom` | For smooth animations, blurs, and true window transparency |
| **System Info** | `Fastfetch` | Modern and fast system information fetcher |
| **File Manager**| `Thunar` | Lightweight and reliable graphical file manager |

---

## 🚀 Automated Installation

The master installation script handles everything out of the box: full system package updates, core dependencies, automated Python pip environments for autotiling, font rendering configurations, backups, and linking.

### 🔹 Option 1: Full Setup with Dependencies (Recommended First-Time)
Installs all system packages, fonts, and deploys configurations:
```bash
git clone https://github.com/krishnaharry208/dotfiles.git
cd dotfiles
./install.sh
```

### 🔹 Option 2: Stow-Only Deployment (Configs Already Exist)
If dependencies are already installed, just deploy symlinks:
```bash
cd ~/dotfiles
./stow-install.sh
```

Or manually with stow:
```bash
cd ~/dotfiles
stow i3 alacritty picom polybar rofi fastfetch
```

---

## 📚 Understanding Stow

This repository uses **GNU Stow** to manage symlinks. Each configuration package (i3, alacritty, etc.) contains a `.config/` directory that mirrors your home directory structure.

**For detailed stow usage**, see [STOW_SETUP.md](./STOW_SETUP.md) for:
- How stow works
- Common commands (deploy, undo, restow)
- Troubleshooting symlink conflicts
- Updating configurations

### Quick Stow Reference
```bash
# Deploy specific app configs
stow i3

# Deploy multiple apps
stow i3 alacritty polybar

# Remove symlinks (don't delete files)
stow -D i3

# Recreate symlinks
stow -R i3

# Dry-run (see what would happen)
stow --simulate i3
```

