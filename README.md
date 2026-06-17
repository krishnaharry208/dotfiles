# 🛠️ Dotfiles Setup (Debian + i3wm)

Personal dotfiles for a fast, minimal, and keyboard-driven Linux workflow on **Debian** with **i3wm**.

Configuration files are managed with **GNU Stow** for clean, modular, and easy deployment.

---

## ✨ Features

* 🪟 **i3wm** with automatic split orientation using `autotiling`
* 🚀 GPU-accelerated **Alacritty** terminal
* 📊 Customized **Polybar**
* 🔍 Fast application launcher with **Rofi**
* 🎨 Transparent windows and effects via **Picom**
* 💻 Modern system information with **Fastfetch**
* 📁 Lightweight file manager using **Thunar**
* 🔗 Modular dotfiles managed with **GNU Stow**

---

## 📦 Included Configurations

| Component      | Application | Purpose                             |
| -------------- | ----------- | ----------------------------------- |
| Window Manager | i3wm        | Dynamic tiling window manager       |
| Terminal       | Alacritty   | GPU-accelerated terminal            |
| Status Bar     | Polybar     | System information and controls     |
| Launcher       | Rofi        | Application launcher and power menu |
| Compositor     | Picom       | Transparency and visual effects     |
| System Info    | Fastfetch   | Display system information          |
| File Manager   | Thunar      | Lightweight file manager            |

---

## 🚀 Installation

### Full Setup (Recommended)

Installs dependencies, fonts, and configures the system.

```bash
git clone https://github.com/krishnaharry208/dotfiles.git
cd dotfiles

chmod +x ins/install.sh
./ins/install.sh
```

---

### Stow-Only Setup

If dependencies are already installed:

```bash
cd ~/dotfiles

stow alacritty
stow fastfetch
stow i3
stow picom
stow polybar
stow rofi
```

Or deploy everything:

```bash
stow */
```

---

## 📚 GNU Stow Usage

Deploy a package:

```bash
stow i3
```

Deploy multiple packages:

```bash
stow i3 alacritty polybar
```

Remove symlinks:

```bash
stow -D i3
```

Restow after changes:

```bash
stow -R i3
```

Dry-run without making changes:

```bash
stow -nv i3
```

---

## 📂 Repository Structure

```text
dotfiles/
├── alacritty/
│   └── .config/alacritty/alacritty.toml
├── fastfetch/
│   └── .config/fastfetch/config.jsonc
├── i3/
│   └── .config/i3/config
├── picom/
│   └── .config/picom/picom.conf
├── polybar/
│   └── .config/polybar/
├── rofi/
│   └── .config/rofi/
├── ins/
│   ├── install.sh
│   └── README.md
├── STOW_SETUP.md
└── README.md
```

Each package mirrors the standard `$HOME` directory structure, allowing GNU Stow to create symlinks automatically in their correct locations.

---

## 🔄 Updating

Update the repository:

```bash
cd ~/dotfiles
git pull
```

Recreate symlinks:

```bash
stow -R */
```

---

## 🖼️ Preview

*(Add screenshots here)*

---

## 📄 License

Feel free to use, modify, and adapt these dotfiles for your own setup.
