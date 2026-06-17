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

### 🔹 Option 1: Git Clone (Recommended for Customization)
Clone the repository locally to tweak scripts before executing them:
```bash
git clone https://github.com/krishnaharry208/dotfiles.git
cd dotfiles
./install.sh

