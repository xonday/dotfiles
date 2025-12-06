# Dotfiles for my DWL setup

# My DWL Build - Setup Guide

### Notes

* On the Distro: I'm using OpenSUSE Tumbleweed/Slowroll
    * I started with a Server install
    * From there you can follow more or less my commands (though I likely missed some steps)
    * With slightly differing package names this should work on other distros
* Initially I followed this guide by tonybtw:  
    * https://www.youtube.com/watch?v=XkHrQhI95l0  
    * blog post: https://www.tonybtw.com/tutorial/dwl/  
    * Later on I switched to dwlb as the bar together with someblocks. I also created some custom scripts (or modified some that I took from here: https://github.com/LukeSmithxyz/voidrice/tree/master/.local/bin/statusbar)  
    * Bread on Penguins also makes great videos (not just) on dwm: https://www.youtube.com/@BreadOnPenguins  
* I have all the patches under dotfiles/dwl/patches/ applied

## (optional) migrate to Slowroll
* https://en.opensuse.org/Portal:Slowroll  
sudo zypper in opensuse-migration-tool  
sudo opensuse-migration-tool --dry-run  
sudo opensuse-migration-tool  
sudo reboot  

## 1. Installing packages

sudo zypper dup -y  

**dependencies for dwl**  
sudo zypper in -y libwlroots-0_19 cmake wayland-protocols-devel wlroots-devel libinput-devel libxkbcommon-devel  
sudo zypper in -t pattern devel_basis  
sudo zypper in -y bemenu foot

**for notifications**
* sudo zyppper in -y libnotify-tools mako 
* mako is the notification daemon that will listen to libnotify

**applications to get started**  
* sudo zypper in git firefox htop  

**fallback fonts**
* install some fallback fonts if you get font errors:  
* sudo zypper in suse-fonts liberation-fonts dejavu-fonts

### Jetbrains Mono Nerd Font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip  
unzip -o -q -d JetBrainsMono JetBrainsMono.zip   
mv JetBrainsMono ~/.local/share/fonts/  
rm JetBrainsMono.zip  

### other packages I'm using
sudo zypper in ttf-jetbrains-mono-nerd sensors swaybg wl-clipboard grim slurp imv  

## 2. DWL - inital setup and install
git clone https://github.com/xonday/dotfiles.git  
cd dotfiles/dwl  
vim config.def.h # adjust keybinds to your liking  
sudo make clean install  
* dwl can now be run from the terminal, just type its name

### 3. Bar Setup

### dwlb
sudo zypper in fcft-devel # dependency  
cd dotfiles/dwlb  
make  
sudo make install  

#### someblocks
cd dotfiles/someblocks
make && sudo make install

**fixing startup with someblocks:**  
1. create autostart script:

#!/bin/sh

#scale display  
wlr-randr --output eDP-1 --scale 1.5  
#Set the wallpaper  
swaybg -i dotfiles/images/fancy_setup_2560x1600.png & #put your image path here  
#Start mako (notification daemon)  
mako &  
dwlb -ipc -scale 2 # set scaling for dwlb if you have increased the display scale as I did above

2. create start-dwl.sh script:

#!/bin/sh  
pkill someblocks  
dwl -s ./autostart-with-dwl.sh; sleep 0.1 && someblocks -p | dwlb -status-stdin all &  

3. make both files executable
4. run ./start-dwl.sh

### 4. Fix scripts location

* copy the scripts you need from dotfiles/scripts into ~/.local/bin 

That's it!

