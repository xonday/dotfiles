#!/bin/bash
# backup config
#rsync -a ~/*.sh ~/dotfiles/scripts
#rsync -a ~/.config/foot ~/dotfiles/
#rsync -avz --delete ~/.local/bin /mnt/old-fileserver/dotfiles-28-11-25/
#rsync -avz --delete ~/dotfiles/ /mnt/old-fileserver/dotfiles-28-11-25
#rsync -avz --delete ~/dotfiles/ /mnt/nfs-share/backups/dotfiles-28-11-25
#rsync -avz --delete ~/.local/bin /mnt/nfs-share/backups/dotfiles-28-11-25

# reset backups
	#rm -r /mnt/old-fileserver/infinity/ && rm -r /mnt/nfs-share/backups/infinity/
	#mkdir -p /mnt/old-fileserver/infinity/home && mkdir -p /mnt/nfs-share/backups/infinity/home

rsync -avz --safe-links --exclude={".cargo/*",".local/share/*",".config/zsh/plugins/*",".config/cache/*",".config/chromium/*",".cache/*",".mozilla/*","/lost+found"} --delete /home/alex/ /mnt/nfs-share/backups/infinity/home
rsync -avz --safe-links --exclude={".cargo/*",".local/share/*",".config/zsh/plugins/*",".config/cache/*",".config/chromium/*",".cache/*",".mozilla/*","/lost+found"} --delete /home/alex/ /mnt/old-fileserver/infinity/home

