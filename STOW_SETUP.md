# Stow-Based Dotfiles Setup

This dotfiles repository uses **GNU Stow** to manage symlinks from your home directory to the configuration files stored here.

## How Stow Works

GNU Stow is a symlink manager that creates symbolic links from a source directory to a target directory, maintaining the directory structure. In this setup:

- **Source**: Individual directories in the dotfiles folder (e.g., `i3/`, `alacritty/`, `polybar/`)
- **Target**: Your home directory (`~`)
- **Stow Directory**: The dotfiles folder itself (where you run the command from)

### Directory Structure

Each application folder contains a `.config/` subdirectory that mirrors the target structure:

```
dotfiles/
├── i3/
│   └── .config/
│       └── i3/
│           └── config          → symlinked to ~/.config/i3/config
├── alacritty/
│   └── .config/
│       └── alacritty/
│           └── alacritty.toml  → symlinked to ~/.config/alacritty/alacritty.toml
├── polybar/
│   └── .config/
│       └── polybar/
│           ├── config.ini      → symlinked to ~/.config/polybar/config.ini
│           └── launch.sh       → symlinked to ~/.config/polybar/launch.sh
└── ... (other apps)
```

## Installation

### Quick Stow Deploy (Symlinks Only)

If you already have all dependencies installed, simply deploy the symlinks:

```bash
cd ~/dotfiles
stow i3 alacritty picom polybar rofi fastfetch
```

Or deploy all at once:

```bash
cd ~/dotfiles
for pkg in i3 alacritty picom polybar rofi fastfetch; do
  stow "$pkg"
done
```

### Full Setup with Dependencies

Run the comprehensive install script (installs packages, fonts, and deploys configs):

```bash
bash ~/dotfiles/install.sh
```

## Common Stow Commands

### Deploy configs
```bash
stow i3              # Symlink only i3 configs
stow i3 alacritty    # Symlink multiple apps
```

### Remove symlinks (don't delete actual files)
```bash
stow -D i3           # Remove i3 symlinks
stow -D i3 alacritty # Remove multiple
```

### Restow (recreate symlinks, useful for updates)
```bash
stow -R i3           # Restow i3 (delete old + create new)
```

### Check what would happen (dry-run)
```bash
stow --simulate i3   # Show what would be created
```

## What Gets Installed

Each stowed package installs its configuration to `~/.config/`:

- **i3**: Window manager config
- **alacritty**: Terminal emulator config
- **picom**: Compositor config
- **polybar**: Status bar config and launch script
- **rofi**: Application launcher config
- **fastfetch**: System info display config

## Backing Up Existing Configs

Before running stow, the `install.sh` script automatically backs up existing physical configs to `~/.backup/`. 

**Important**: If you have symlinks already in `~/.config/` pointing to different locations, stow will conflict. Remove those first:

```bash
rm -rf ~/.config/i3  # If it's a real directory
```

Then run stow.

## Troubleshooting

### "Stow cannot create symlink: File exists"
You have existing configs in your `~/.config/`. Back them up or remove them first:
```bash
mv ~/.config/i3 ~/.config/i3.bak
```

### Symlinks not appearing
Ensure you're running stow from the dotfiles directory:
```bash
cd ~/dotfiles
stow --restow i3    # -R to force recreation
```

### Permission denied errors
Ensure the user (not root) owns the symlinks:
```bash
sudo chown -R $USER:$USER ~/.config/
```

## Updating Dotfiles

To pull latest changes and reapply symlinks:

```bash
cd ~/dotfiles
git pull
stow -R i3 alacritty picom polybar rofi fastfetch
```
