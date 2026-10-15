#!/usr/bin/env bash

sudo zypper dup -y

# dependencies for dwl
echo "installing essential dependencies for wayland and DWL"
sudo zypper in -y libwlroots-0_19 cmake wayland-protocols-devel wlroots-devel libinput-devel libxkbcommon-devel
sudo zypper in -t pattern devel_basis

echo "installing essential applications"
sudo zypper in -y bemenu foot calc ddcutil

# for notifications (mako is the notification daemon that will listen to libnotify)
sudo zyppper in -y libnotify-tools mako


# applications to get started
echo "installing some applications"
sudo zypper in -y git firefox htop rsync
echo "installing fallback fonts to avoid errors"
sudo zypper in -y suse-fonts liberation-fonts dejavu-fonts

echo "installing Jetbrains Mono Nerd Font"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip -o -q -d JetBrainsMono JetBrainsMono.zip
mv JetBrainsMono ~/.local/share/fonts/
rm JetBrainsMono.zip

echo "installing other packages I'm using"
sudo zypper in ttf-jetbrains-mono-nerd sensors swaybg wl-clipboard grim slurp imv cliphist

2. DWL - inital setup and install
mkdir ~/Tech/dotfiles &&
git clone https://github.com/xonday/dotfiles.git
cd ~/Tech/dotfiles/dwl
sudo make clean install && echo "DWL successfully installed"

echo "installing the bar (dwlb)
sudo zypper in -y fcft-devel # dependency
cd ~/Tech/dotfiles/dwlb
make
sudo make install

echo "installing someblocks"
cd ~/Tech/dotfiles/someblocks
make && sudo make install


mkdir ~/Tech/scripts 
cat > ~/Tech/scripts/autostart.sh << 'EOF'
#!/bin/sh
#scale display
wlr-randr --output eDP-1 --scale 1.5
#Set the wallpaper
swaybg -i dotfiles/images/fancy_setup_2560x1600.png & #put your image path here
#Start mako (notification daemon)
mako &
dwlb -ipc -scale 2 # set scaling for dwlb if you have increased the display scale as I did above
EOF
chmod +x ~/Tech/scripts/autostart.sh

cat > ~/Tech/scripts/autostart-with-dwl.sh << 'EOF'
#!/bin/sh
pkill someblocks
dwl -s ./autostart-with-dwl.sh; sleep 0.1 && someblocks -p | dwlb -status-stdin all &
EOF

chmod +x ~/Tech/scripts/autostart-with-dwl.sh


echo "adding udev rule so brightness works correctly with external monitors"
sudo groupadd i2c sudo usermod -aG i2c "$USER"
sudo tee /etc/udev/rules.d/60-ddcutil-i2c.rules <<'EOF'
KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
EOF
sudo udevadm control --reload sudo udevadm trigger


echo "copying scripts dotfiles/scripts into ~/.local/bin"
rsync -av dotfiles/scripts/ ~/.local/bin/

echo "installing  fonts for Chinese"
sudo zypper install lxgw-wenkai-fonts lxgw-wenkai-screen-fonts

echo "DWL installation completed successfully!"
