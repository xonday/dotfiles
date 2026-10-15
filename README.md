# Dotfiles for my DWL setup

## Notes

* **Distro:** I'm using openSUSE Tumbleweed/Slowroll
    * I started with a Server install
    * From there you can more or less follow my commands below
    * With slightly different package names this should work on other distros too
* Initially I followed this guide by tonybtw:
    * Video: https://www.youtube.com/watch?v=XkHrQhI95l0
    * Blog post: https://www.tonybtw.com/tutorial/dwl/
* Later on I switched to dwlb as the bar, together with someblocks. I also wrote some custom status bar scripts (or modified some I took from here: https://github.com/LukeSmithxyz/voidrice/tree/master/.local/bin/statusbar)
* Bread on Penguins also makes great videos (not just) on dwm: https://www.youtube.com/@BreadOnPenguins
* All the patches under `dotfiles/dwl/patches/` are already applied

## (Optional) Migrate to Slowroll

See https://en.opensuse.org/Portal:Slowroll

```bash
sudo zypper in opensuse-migration-tool
sudo opensuse-migration-tool --dry-run
sudo opensuse-migration-tool
sudo reboot
```

## 1. Installing packages

```bash
sudo zypper dup -y
```

**Dependencies for dwl**

```bash
sudo zypper in -y libwlroots-0_19 cmake wayland-protocols-devel wlroots-devel libinput-devel libxkbcommon-devel
sudo zypper in -y -t pattern devel_basis
```

**Essential applications**

```bash
sudo zypper in -y bemenu foot calc ddcutil wl-clipboard cliphist wget unzip
```

**Notifications** (mako is the notification daemon that listens to libnotify)

```bash
sudo zypper in -y libnotify-tools mako
```

**Applications to get started**

```bash
sudo zypper in -y git firefox htop rsync
```

**Fallback fonts** (install these if you get font errors)

```bash
sudo zypper in -y suse-fonts liberation-fonts dejavu-fonts
```

### JetBrains Mono Nerd Font

```bash
cd ~
mkdir -p ~/.local/share/fonts
rm -rf ~/.local/share/fonts/JetBrainsMono
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip -o -q -d JetBrainsMono JetBrainsMono.zip
mv JetBrainsMono ~/.local/share/fonts/
fc-cache -f
rm JetBrainsMono.zip
```

### Other packages I'm using

```bash
sudo zypper in -y sensors swaybg grim slurp imv wlr-randr
```

## 2. DWL – initial setup and install

```bash
mkdir -p ~/Tech
git clone https://github.com/xonday/dotfiles.git ~/Tech/dotfiles
cd ~/Tech/dotfiles/dwl
vim config.def.h   # adjust keybinds to your liking
make clean
make
sudo make install
```

> **Note:** `make` only creates `config.h` from `config.def.h` if `config.h` doesn't exist yet. If there already is a `config.h`, edit that one instead (or delete it so it gets regenerated).

## 3. Bar setup

### dwlb

```bash
sudo zypper in -y fcft-devel   # dependency
cd ~/Tech/dotfiles/dwlb
make
sudo make install
```

### someblocks

```bash
cd ~/Tech/dotfiles/someblocks
make
sudo make install
```

### Startup scripts

The two startup scripts live in `dotfiles/startup_scripts/`. Copy them into `~/.local/bin/` (make sure that's on your `PATH`):

```bash
rsync -av ~/Tech/dotfiles/startup_scripts/ ~/.local/bin/
chmod +x ~/.local/bin/start_dwl.sh ~/.local/bin/autostart-with-dwl.sh
```

**`autostart-with-dwl.sh`** – everything that should run inside the dwl session:

```sh
#!/bin/sh

# scale display
wlr-randr --output eDP-1 --scale 1.5

# wallpaper (put your image path here)
swaybg -i "$HOME/Tech/dotfiles/images/dayou-lu_wind-through-the-lotus-pond.JPG" &

# notification daemon
mako &

# clipboard history
wl-paste --watch cliphist store &

# feed someblocks into the bar once dwlb is up
(sleep 1; someblocks -p | dwlb -status-stdin all) &

# dwlb stays in the foreground so this script lives as long as dwl
# (set -scale if you increased the display scale as above)
exec dwlb -ipc -scale 2
```

**`start_dwl.sh`** – starts dwl with the autostart script:

```sh
#!/bin/sh
# kill leftover someblocks from a previous session
pkill someblocks
exec dwl -s "$HOME/.local/bin/autostart-with-dwl.sh"
```

To start dwl, log in on a TTY and run:

```bash
start_dwl.sh
```

## 4. Brightness control for external monitors (ddcutil)

ddcutil talks to monitors through `/dev/i2c-*`. For that to work as a normal user you need to:

1. load the `i2c-dev` kernel module (now and at every boot)
2. add a udev rule that gives the `i2c` group access to those devices
3. add your user to that group

```bash
sudo groupadd -f i2c
sudo usermod -aG i2c "$USER"

sudo tee /etc/udev/rules.d/60-ddcutil-i2c.rules <<'EOF'
KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
EOF

# load i2c-dev at every boot
echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf

sudo udevadm control --reload
sudo modprobe i2c-dev
sudo udevadm trigger
```

Log out and back in (or reboot) so the new group takes effect, then test it:

```bash
ddcutil detect
```

If your external monitor shows up, brightness control works. If you get "permission denied", the group change hasn't taken effect yet.

## 5. Scripts

Copy the scripts from `dotfiles/scripts` into `~/.local/bin`:

```bash
rsync -av ~/Tech/dotfiles/scripts/ ~/.local/bin/
```

Or, to keep `~/.local/bin` an exact mirror of the repo:

```bash
rsync -av --delete ~/Tech/dotfiles/scripts/ ~/.local/bin/
```

> **Careful:** `--delete` removes every file in `~/.local/bin/` that isn't in `dotfiles/scripts/`, including the startup scripts from step 3. Only use it if you know what's in there.

That's it!

## Personal additions

Fonts for Chinese:

```bash
sudo zypper in -y lxgw-wenkai-fonts lxgw-wenkai-screen-fonts
```
