#!/usr/bin/env bash
set -euo pipefail #stop on errors

sudo zypper dup -y

# dependencies for dwl
echo "installing essential dependencies for wayland and DWL"
sudo zypper in -y libwlroots-0_19 cmake wayland-protocols-devel wlroots-devel libinput-devel libxkbcommon-devel
sudo zypper in -y -t pattern devel_basis

echo "installing essential applications"
sudo zypper in -y bemenu foot calc ddcutil wl-clipboard cliphist wget unzip

# for notifications (mako is the notification daemon that will listen to libnotify)
sudo zypper in -y libnotify-tools mako


# applications to get started
echo "installing some applications"
sudo zypper in -y git firefox htop rsync
echo "installing fallback fonts to avoid errors"
sudo zypper in -y suse-fonts liberation-fonts dejavu-fonts

echo "installing Jetbrains Mono Nerd Font"
cd ~
mkdir -p ~/.local/share/fonts
rm -rf ~/.local/share/fonts/JetBrainsMono
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip -o -q -d JetBrainsMono JetBrainsMono.zip
mv JetBrainsMono ~/.local/share/fonts/
fc-cache -f
rm JetBrainsMono.zip


echo "installing other packages I'm using"
sudo zypper in -y sensors swaybg grim slurp imv wlr-randr #ttf-jetbrains-mono-nerd

mkdir -p ~/Tech
[ -d ~/Tech/dotfiles ] || git clone https://github.com/xonday/dotfiles.git ~/Tech/dotfiles
cd ~/Tech/dotfiles/dwl
make clean 
make 
sudo make install
echo "DWL successfully installed"

echo "installing the bar (dwlb)"
sudo zypper in -y fcft-devel # dependency
cd ~/Tech/dotfiles/dwlb
make
sudo make install

echo "installing someblocks"
cd ~/Tech/dotfiles/someblocks
make 
sudo make install

rsync -av ~/Tech/dotfiles/startup_scripts/ ~/.local/bin/

echo "adding udev rule so brightness works correctly with external monitors"
sudo groupadd -f i2c
sudo usermod -aG i2c "$USER"
sudo tee /etc/udev/rules.d/60-ddcutil-i2c.rules <<'EOF'
KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
EOF
# load i2c-dev at every boot
echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf
sudo udevadm control --reload
# load it now too, so the /dev/i2c-* devices appear with the new rule applied
sudo modprobe i2c-dev
sudo udevadm trigger

echo "copying scripts dotfiles/scripts into ~/.local/bin"
rsync -av ~/Tech/dotfiles/scripts/ ~/.local/bin/

echo "installing  fonts for Chinese"
sudo zypper in -y lxgw-wenkai-fonts lxgw-wenkai-screen-fonts

echo "DWL installation completed successfully!"
