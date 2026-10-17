#!/usr/bin/env bash
set -euo pipefail #stop on errors

[[ $EUID -ne 0 ]] || { echo "run as your normal user, not root"; exit 1; }

sudo zypper dup -y --auto-agree-with-licenses

# dependencies for dwl
echo "installing essential dependencies for wayland and DWL"
sudo zypper in -y -t pattern devel_basis
sudo zypper in -y cmake wayland-protocols-devel wlroots-devel libinput-devel libxkbcommon-devel\ #dependenciees for DWL
fcft-devel \ # dependency for dwlb
bemenu foot git calc ddcutil wl-clipboard cliphist wget unzip libnotify-tools mako git sensors swaybg grim slurp imv wlr-randr greetd greetd-agreety \ # essential applications used in this build
firefox htop rsync \ #other
suse-fonts liberation-fonts dejavu-fonts #fallback fonts

# wlroots: keep the locked 0.19, don't let zypper upgrade it
if pkg-config --exists wlroots-0.19; then
    echo "wlroots 0.19 already installed and locked, skipping"
else
    sudo zypper in -y libwlroots-0_19 wlroots-devel
    sudo zypper addlock libwlroots-0_19 wlroots-devel
fi


echo "installing Jetbrains Mono Nerd Font"
cd ~
mkdir -p ~/.local/share/fonts
rm -rf ~/.local/share/fonts/JetBrainsMono
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip -o -q -d JetBrainsMono JetBrainsMono.zip
mv JetBrainsMono ~/.local/share/fonts/
fc-cache -f
rm JetBrainsMono.zip

mkdir -p ~/Tech
[ -d ~/Tech/dotfiles ] || git clone https://github.com/xonday/dotfiles.git ~/Tech/dotfiles
cd ~/Tech/dotfiles/dwl
make clean 
make 
sudo make install
echo "DWL successfully installed"

echo "installing the bar (dwlb)"
cd ~/Tech/dotfiles/dwlb
make
sudo make install

echo "installing someblocks"
cd ~/Tech/dotfiles/someblocks
make 
sudo make install

echo "installing wlock"
cd ~/Tech/dotfiles/wlock
make CC=cc
sudo make CC=cc install

rsync -av ~/Tech/dotfiles/startup_scripts/ ~/.local/bin/

echo "setting up greetd"
sudo tee /etc/greetd/config.toml  > /dev/null <<'EOF'
[terminal]
vt = 1

[initial_session]
command = "/home/alex/.local/bin/start_dwl.sh"
user = "alex"

[default_session]
command = "agreety --cmd /home/alex/.local/bin/start_dwl.sh"
user = "greeter"
EOF

sudo systemctl enable greetd
sudo systemctl set-default graphical.target

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
sudo zypper in -y lxgw-wenkai-fonts lxgw-wenkai-screen-fonts #TODO: move to separate script


echo "DWL installation completed successfully!"
