install-bazzite-arch:
  #!/usr/bin/env bash
  source /etc/default/bazzite
  
  echo 'Installing Bazzite Arch...'
  distrobox assemble create --file /usr/share/ublue-os/distrobox/bazzite-arch
  distrobox-enter -n bazzite-arch -- '  sudo locale-gen'
  distrobox-enter -n bazzite-arch -- '  /usr/bin/bazzite-steam-runtime --silent &>/dev/null &'
  distrobox-enter -n bazzite-arch -- '  distrobox-export --app steam'
  distrobox-enter -n bazzite-arch -- '  distrobox-export --app lutris'
  distrobox-enter -n bazzite-arch -- '  distrobox-export --app protontricks'
  mkdir -p ~/.config/autostart/
  cp ~/.local/share/applications/bazzite-arch-steam.desktop ~/.config/autostart/bazzite-arch-steam.desktop
  sed -i 's@/usr/bin/bazzite-steam-runtime  %U@/usr/bin/bazzite-steam-runtime -silent  %U@g' ~/.config/autostart/bazzite-arch-steam.desktop
  mkdir -p $HOME/.steam
  distrobox-enter -n bazzite-arch -- '  distrobox-export --bin /usr/bin/steamcmd --export-path ~/.steam'
  mv $HOME/.steam/steamcmd $HOME/.steam/steamcmd.sh
  if [[ ${BASE_IMAGE_NAME} == 'kinoite' ]]; then
    echo 'Creating desktop shortcuts...'
    cp ~/.local/share/applications/bazzite-arch-steam.desktop ~/Desktop/bazzite-arch-steam.desktop
    sed -i 's@  (on bazzite-arch)@@g' ~/Desktop/bazzite-arch-steam.desktop
    cp ~/.local/share/applications/bazzite-arch-net.lutris.Lutris.desktop ~/Desktop/bazzite-arch-net.lutris.Lutris.desktop
    sed -i 's@  (on bazzite-arch)@@g' ~/Desktop/bazzite-arch-net.lutris.Lutris.desktop
  fi
  sleep 10
  [ ! -e ~/Desktop/steam.desktop ] || rm ~/Desktop/steam.desktop

configure-waydroid:
  #!/usr/bin/env bash
  cd ~
  git clone https://github.com/casualsnek/waydroid_script
  cd ~/waydroid_script
  python -m venv venv
  source venv/bin/activate
  sudo pip install -r ~/waydroid_script/requirements.txt
  sudo ~/waydroid_script/main.py
  sudo pip uninstall -r ~/waydroid_script/requirements.txt -y
  deactivate
  rm -rf ~/waydroid_script

install-corectrl:
  echo 'Installing CoreCtrl...'
  rpm-ostree install corectrl
  echo 'Setting needed kargs for CoreCtrl...'
  rpm-ostree kargs --append="amdgpu.ppfeaturemask=0xffffffff"

install-nix:
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

remove-nix:
  curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/uninstaller-scripts/silverblue-nix-uninstaller.sh | sudo bash

enable-big-picture:
  #!/usr/bin/env bash
  source /etc/default/bazzite
  if [[ ${BASE_IMAGE_NAME} == 'silverblue' ]]; then
    systemctl enable --now gnome-autologin
  elif [[ ${BASE_IMAGE_NAME} == 'kinoite' ]]; then
    systemctl enable --now plasma-autologin
  fi
  mkdir -p ~/.config/autostart/
  rm ~/.config/autostart/bazzite-arch-steam.desktop
  cp ~/.local/share/applications/bazzite-arch-steam.desktop ~/.config/autostart/bazzite-arch-steam.desktop
  sed -i 's@/usr/bin/bazzite-steam-runtime  %U@/usr/bin/bazzite-steam-runtime -bigpicture  %U@g' ~/.config/autostart/bazzite-arch-steam.desktop
  mv ~/.config/autostart/bazzite-arch-steam.desktop ~/.config/autostart/bazzite-arch-steam-bigpicture.desktop

get-greenlight:
  echo 'Retrieving Greenlight'
  wget https://github.com/unknownskl/greenlight/releases/download/v2.0.0-beta8/Greenlight-2.0.0-beta8.AppImage -O ~/Desktop/Greenlight.AppImage
  chmod +x ~/Desktop/Greenlight.AppImage

enable-supergfxctl: 
  #!/usr/bin/env bash
  source /etc/default/bazzite
  if [[ ${IMAGE_FLAVOR} == 'nvidia' ]]; then
    systemctl enable --now supergfxd.service
  else
    echo "This requires an Nvidia image."
  fi

fix-tf2-tcmalloc:
  #!/usr/bin/env bash
  podman run \
  -v $HOME/.steam/steam/steamapps/common/Team\ Fortress\ 2/bin:/hl2_linux:Z \
  ghcr.io/maisatanel/tcmalloc-hl2-fixer:main

enable-vapor-theme:
  #!/usr/bin/env bash
  source /etc/default/bazzite
  if [[ ${BASE_IMAGE_NAME} == 'silverblue' ]]; then
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
    gsettings set org.gnome.mutter center-new-windows true
    gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
    gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/steamdeck/Steam\ Deck\ Logo\ Default.jpg
    gsettings set org.gnome.desktop.background picture-uri-dark file:///usr/share/backgrounds/steamdeck/Steam\ Deck\ Logo\ Default.jpg
    gradience-cli flatpak-overrides -e both
    sudo flatpak override --filesystem=xdg-config/gtk-4.0
    sudo flatpak override --filesystem=xdg-config/gtk-3.0
    gradience-cli apply -p /usr/share/ublue-os/bazzite/themes/vapor.json
  else
    echo "This is only supported under GNOME."
  fi

enable-vgui2-theme:
  #!/usr/bin/env bash
  source /etc/default/bazzite
  if [[ ${BASE_IMAGE_NAME} == 'silverblue' ]]; then
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
    gsettings set org.gnome.mutter center-new-windows true
    gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
    gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/steamdeck/VGUI2.jpg
    gsettings set org.gnome.desktop.background picture-uri-dark file:///usr/share/backgrounds/steamdeck/VGUI2.jpg
    gradience-cli flatpak-overrides -e both
    sudo flatpak override --filesystem=xdg-config/gtk-4.0
    sudo flatpak override --filesystem=xdg-config/gtk-3.0
    gradience-cli apply -p /usr/share/ublue-os/bazzite/themes/vgui2.json
  else 
    echo "This is only supported under GNOME."
  fi

set-btrfs-flags:
  echo 'Configuring drive mount parameters...'
  sudo sed -i 's/compress=zstd:1/noatime,lazytime,commit=120,compress-force=zstd:1,space_cache=v2,discard=async/g' /etc/fstab

zram-on:
  #!/usr/bin/env bash
  KARGS=$(rpm-ostree kargs)
  if grep -q 'zram' <<< ${KARGS}; then
    rpm-ostree kargs --delete=zram
    echo 'ZRAM enabled. Please reboot.'
  else
    echo 'ZRAM is already enabled.'
  fi

zram-off:
  #!/usr/bin/env bash
  KARGS=$(rpm-ostree kargs)
  if grep -qv 'zram' <<< ${KARGS}; then
    rpm-ostree kargs --append=zram=0
    echo 'ZRAM disabled. Please reboot.'
  else
    echo 'ZRAM is already disabled.'
  fi

resize-zram:
  #!/usr/bin/env bash
  CONFIG='/etc/systemd/zram-generator.conf'
  if grep -q "zram-size" <<< $(cat ${CONFIG}); then
    CURRENT_SIZE=$(cat "${CONFIG}" | grep "zram-size" | sed 's/zram-size=//g')
  else
    CURRENT_SIZE=1024
  fi
  echo 'Current size: '${CURRENT_SIZE}
  read -p 'Enter new size (512-4096) in megabytes (1024): ' NEW_SIZE
  if [ -z "${NEW_SIZE//[0-9]}" ]; then
    if [ -z "${NEW_SIZE}" ]; then
      NEW_SIZE=1024
    fi
    if ((${NEW_SIZE} >= 512 && ${NEW_SIZE} <= 4096)); then
      if grep "zram-size" <<< $(cat ${CONFIG}); then
        sudo sed -i 's/zram-size='${CURRENT_SIZE}'/zram-size='${NEW_SIZE}'/g' ${CONFIG}
      else
        sudo -A echo "zram-size=${NEW_SIZE}" >> ${CONFIG}
      fi
      echo 'Current size: '${NEW_SIZE}'. Please reboot.'
    else
      echo 'Error: Input out of range (512-4096). Running again.'
      just --unstable resize-zram
    fi
  else
    echo 'Error: Input is not an integer. Running again.'
    just --unstable resize-zram
  fi

hide-grub:
  #!/usr/bin/env bash
  sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
  echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub 1>/dev/null
  echo 'GRUB_HIDDEN_TIMEOUT=1' | sudo tee -a /etc/default/grub 1>/dev/null
  if [ -f '/boot/efi/EFI/fedora/grub.cfg' ]; then
    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
  else
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
  fi

unhide-grub:
  #!/usr/bin/env bash
  sudo sed -i '/GRUB_HIDDEN_TIMEOUT=1/d' /etc/default/grub
  sudo sed -i '/GRUB_TIMEOUT_STYLE=hidden/d' /etc/default/grub
  sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub
  if [ -f '/boot/efi/EFI/fedora/grub.cfg' ]; then
    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
  else
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
  fi

sign-image:
  #!/usr/bin/env bash
  source /etc/default/bazzite
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/${IMAGE_VENDOR}/${IMAGE_NAME}:${FEDORA_MAJOR_VERSION}
