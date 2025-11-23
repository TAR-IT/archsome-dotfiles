# Archsome .dotfiles

<div align="center">
    <h1>Archsome .dotfiles</h1>
    <h2>My configuration files for Arch Linux + awesomewm.</h2>
</div>

---

## Contents
1. [What is awesomewm?](#awesome)
2. [Details](#details)
3. [Installation](#install)
4. [Notes](#notes)
5. [License](#license)

---

<a name="awesome"></a>
## What is awesomewm?
Awesome Window Manager is a highly configurable, next-generation (dwm, xmonad) window manager framework for Xorg.  
It is extremely efficient and extensible, featuring a well-documented Lua API.  
Awesome is licensed under the GNU GPL v2 and primarily targeted at power users, developers, and anyone who wants fine-grained control over their graphical environment.

More resources:
- [Homepage](https://awesomewm.org/)
- [Arch Wiki](https://wiki.archlinux.org/title/Awesome)
- [Screenshot Gallery](https://mipmip.github.io/awesomewm-screenshots/)
- [API Documentation](https://awesomewm.org/apidoc/)
- [Discord](https://discord.gg/BPat4F87dg)
- [StackOverflow](https://stackoverflow.com/questions/tagged/awesome-wm)
- [Reddit](https://www.reddit.com/r/awesomewm/)

---

<a name="details"></a>
## Details
My current setup includes:

- **OS**: Arch Linux  
- **WM**: awesome (custom configuration)  
- **Theme**: Custom (based on the default awesomewm theme)  
- **Terminal**: kitty  
- **File Manager**: Thunar  
- **Browser**: Brave
- **Fonts**: Source Code Pro
- **Audio**: PipeWire

---

<a name="install"></a>
## Installation

### 1. Update your system
```bash
sudo pacman -Syu
```

### 2. Install required packages
```bash
sudo pacman -S git awesome kitty thunar 
```
Optional: install fonts, browsers, notification daemon, or other tools you want.

### 3. Clone this repository
```bash
git clone https://github.com/TAR-IT/archsome-dotfiles
cd ~/archsome-dotfiles
```

### 4. Deploy dotfiles using GNU Stow
```bash
stow -t ~ awesome kitty
```
Add more folders as needed (stow -t ~ <folder>).

### 5. Start AwesomeWM

Log out and select awesome in your display manager, or

Add exec awesome in your .xinitrc if using startx.

### 6. Additional configuration

Edit ~/.config/awesome/rc.lua to tweak keybindings, widgets, and theme.

Change wallpaper via ~/.config/awesome/autorun.sh or feh --bg-scale <path>.

<a name="notes"></a>
## Notes

If you encounter any problems, please open an issue in this repository.

Contributions, suggestions, and improvements are always welcome.

This repository is actively maintained, so check back for updates.

<a name="license"></a>
## License

This repository is licensed under the GNU General Public License v3.0 (GPL-3.0). See the LICENSE file for details.