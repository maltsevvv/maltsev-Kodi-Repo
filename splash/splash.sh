#!/bin/bash

if ! grep -q "disable_splash=1" /boot/config.txt; then
  cat <<'EOF' >> /boot/config.txt

disable_splash=1
EOF
fi

sed -i 's/console=tty1/console=tty3 consoleblank=0 loglevel=1 /' /boot/cmdline.txt

systemctl disable getty@tty1

apt install -y fbi
if ! grep -q "Description=Splash screen" /etc/systemd/system/splashscreen.service; then
  cat <<'EOF' > /etc/systemd/system/splashscreen.service
[Unit]
Description=Splash screen
DefaultDependencies=no
After=local-fs.target

[Service]
ExecStart=/usr/bin/fbi -d /dev/fb0 --noverbose -a /opt/splash.png
StandardInput=tty
StandardOutput=tty

[Install]
WantedBy=sysinit.target
EOF
  systemctl enable splashscreen
fi

rm /opt/splash.png
#wget -P /opt https://github.com/maltsevvv/maltsev-Kodi-Repo/blob/master/splash/splash.png
wget -P /opt https://raw.githubusercontent.com/maltsevvv/maltsev-Kodi-Repo/blob/master/splash/splash.png

if (systemctl -q is-active kodi.service); then
  systemctl stop kodi.service
  sleep 10
elif (systemctl -q is-active kodi.service); then
  systemctl stop kodi.service
  sleep 10
exit 1
fi

mv /usr/share/kodi/media/splash.jpg /usr/share/kodi/media/original_splash.jpg
#wget -P /usr/share/kodi/media/ https://github.com/maltsevvv/maltsev-Kodi-Repo/blob/master/splash/splash.jpg
wget -P /usr/share/kodi/media/ https://raw.githubusercontent.com/maltsevvv/maltsev-Kodi-Repo/blob/master/splash/splash.jpg
sleep 10
reboot
