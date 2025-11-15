# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS dotfiles repository that uses **GNU Stow** for symlink management and **Homebrew** for package installation. The setup is designed around Zsh with Oh My Zsh framework, tmux for terminal multiplexing, and various modern CLI tools.

## Core Commands

### Installation & Management
```bash
make install    # Full installation (runs bin/install.sh)
make update     # Update all components (dotfiles, plugins, packages)
make uninstall  # Remove dotfiles and restore defaults

# Direct script access
bin/install.sh   # Initial setup with all dependencies
bin/update.sh    # Update repo, vendor plugins, and brew packages
bin/brew.sh      # Update/install Homebrew packages only
```

### Testing
The repository has a GitHub Actions workflow (`.github/workflows/main.yml`) that validates the installation script runs successfully on macOS-latest. Run `make install` to test locally.

## Architecture

### Stow-Based Symlink Management
Files in the repository root (except those in `.stow-local-ignore`) are symlinked to `$HOME` using GNU Stow. This allows clean separation between the repository structure and the actual dotfile locations.

**Excluded from symlinking:** `.git`, `.github`, `bin/`, `utils/`, `vendor/`, `LICENSE`, `Makefile`, `README.md`

### Plugin System Architecture
The dotfiles use a vendor-based plugin system for Zsh extensions:

```
vendor/
├── fzf-git.sh/           # Fuzzy git operations (CTRL-G keybindings)
├── fzf-tab/              # Fuzzy tab completion for Zsh
└── zsh-autosuggestions/  # Command history suggestions
```

Plugins are:
1. Cloned during installation into `vendor/`
2. Sourced in `.zshrc` after Oh My Zsh loads
3. Updated via `update.sh` using `git pull`

### Local Customization Pattern
The installation script creates `.local` override files that are sourced after their main counterparts:
- `.aliases.local` → sourced in `.aliases`
- `.functions.local` → sourced in `.functions`
- `.keys.local` → sourced in `.keys`
- `.brew.local` → sourced in `brew.sh`
- `.exports.local` → sourced in `.exports`

These files are git-ignored and allow user-specific customizations without modifying tracked files.

### Package Management Flow
1. Package definitions live in `.brew` (taps, brews, casks, fonts)
2. `brew.sh` reads both `.brew` and `.brew.local` (if exists)
3. Script updates Homebrew, upgrades packages, then installs missing ones
4. Installed via arrays: `TAPS`, `BREWS`, `CASKS`, `FONTS`

### Shell Configuration Loading Order
1. `.zshrc` - Oh My Zsh initialization and core plugins (git, fzf)
2. `.exports` → `.exports.local` - Environment variables
3. `.aliases` → `.aliases.local` - Command aliases (109+ defined)
4. `.functions` → `.functions.local` - Shell functions
5. `.history` - Zsh history settings
6. Vendor plugins: fzf-git.sh, zsh-autosuggestions, fzf-tab, zsh-syntax-highlighting
7. Starship prompt initialization
8. Mise (version manager) activation
9. Zoxide (smart cd) initialization
10. `.keys` documentation (optional viewing with `?`)

### Documentation System
The `utils/common` file provides colored output functions (`tput`-based) for documenting features:
- `.echo_alias()` - Documents an alias
- `.echo_function()` - Documents a shell function
- `.echo_keybinding()` - Documents a keybinding
- `.echo_version()` - Shows git version info

All documentation is viewable via the `?` alias, which sources and displays `.aliases`, `.functions`, and `.keys`.

## Key Implementation Details

### Installation Script (`bin/install.sh`)
The installation is orchestrated through a `setup()` function that:
1. Checks for existing Oh My Zsh installation (fails if exists)
2. Clones dotfiles repo to `$HOME/.dotfiles` (if not already there)
3. Installs Homebrew (if needed)
4. Installs Oh My Zsh with proper permissions (`umask g-w,o-w`)
5. Installs vendor plugins (fzf-git, fzf-tab, zsh-autosuggestions)
6. Installs Mise version manager
7. Runs `brew.sh` to install packages
8. Creates `.local` template files
9. Uses GNU Stow to symlink dotfiles

### Stow Relinking Pattern
When modifying dotfile structure, always relink:
```bash
cd ~/.dotfiles
stow --restow .
```

The installation and update scripts handle this automatically.

### Config Files in `.config/`
XDG-compliant configs are stored in `.config/` and symlinked:
- `starship.toml` - Shell prompt (replaces Oh My Zsh theme in practice)
- `git/ignore` - Global gitignore patterns
- `gh/` - GitHub CLI configuration
- `mc/` - Midnight Commander settings
- `iterm2/` - iTerm2 preferences

## Important Patterns

### Adding New Packages
1. Add to `.brew` in the appropriate array (`TAPS`, `BREWS`, `CASKS`, `FONTS`)
2. Run `bin/brew.sh` or `make update`
3. For personal packages, use `.brew.local` instead

### Adding New Aliases
1. Add to `.aliases` with `.echo_alias` documentation
2. Pattern: `alias name='command' && .echo_alias 'alias description'`
3. Reload: `source ~/.zshrc` or restart terminal

### Adding New Vendor Plugins
1. Clone to `vendor/` directory
2. Add installation function to `bin/install.sh`
3. Call function from `setup()`
4. Source plugin in `.zshrc` after Oh My Zsh loads
5. Add update logic to `bin/update.sh`

### Tmux Integration
The `.zshrc` includes tmux auto-start logic. Configuration in `.tmux.conf`:
- Prefix: `CTRL-A` (not default CTRL-B)
- 256-color support
- Large scrollback buffer (100,000 lines)
- Mouse mode enabled
- Documented keybindings in `.keys`

## CI/CD Notes
The GitHub Actions workflow runs `make install` on macOS-latest with a 5-minute timeout. This validates the installation script works correctly. The workflow is triggered manually or scheduled (Fridays at 20:00 UTC).
