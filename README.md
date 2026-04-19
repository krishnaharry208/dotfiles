# 🛠️ Dotfiles Setup (Debian + i3)

This repository contains my personal Linux setup using **GNU Stow** for managing dotfiles.

It includes configs for:

* i3
* Alacritty
* Picom
* Polybar
* Rofi
* Fastfetch

---

## 🚀 Installation

### 🔹 Method 1: Git Clone (Recommended)

```bash
git clone https://github.com/krishnaharry208/dotfiles
cd dotfiles
sudo ./install.sh
```

✔ Best for editing or customizing configs
✔ Full control over setup

---

### 🔹 Method 2: One Command (curl)

```bash
curl -fsSL https://raw.githubusercontent.com/krishnaharry208/dotfiles/main/install.sh | sudo bash
```

✔ Fastest way to install
✔ Perfect for fresh systems

---

## ⚙️ What the Script Does

* Sets up Debian repositories (trixie)
* Updates system packages
* Installs required packages:

  * i3, Alacritty, Thunar, Picom, Git, Stow, etc.
* Installs **JetBrainsMono Nerd Font**
* Clones this repository (if needed)
* Backs up existing configs
* Applies all configs using GNU Stow

---

## 📁 Repository Structure

```
dotfiles/
├── install.sh
├── i3/
├── alacritty/
├── picom/
├── polybar/
├── rofi/
├── fastfetch/
```

Each folder is a **Stow package**.

---

## 🔧 Usage (After Installation)

### Apply all configs

```bash
cd ~/dotfiles
stow *
```

### Fix or update one config

```bash
stow -R alacritty
```

### Remove a config

```bash
stow -D alacritty
```

---

## ⚠️ Important Notes

* Always edit configs inside:

  ```
  ~/dotfiles/<package>/
  ```

  NOT in `~/.config/`

* Your configs are symlinked using Stow

---

## 🧠 Requirements

* Debian (tested on trixie)
* Internet connection
* sudo privileges

---

## 📌 Tips

* Restart i3 after install:

  ```
  Mod + Shift + R
  ```
* Or reboot system for full effect

---

## 🔥 Credits

* Managed with **GNU Stow**
* Fonts from Nerd Fonts (JetBrainsMono)

---

## 🚀 Future Improvements

* bash + plugins
* Themes & icons
* Auto environment setup

---

Enjoy your setup 🎉
