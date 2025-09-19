for dir in /usr/lib/pulse-*/modules; do
    ln -s /opt/pulseaudio-module-xrdp/*.la /opt/pulseaudio-module-xrdp/*.so $dir
done
cd /opt/pulseaudio-module-xrdp
mkdir -p /usr/libexec/pulseaudio-module-xrdp
cp load_pa_modules.sh /usr/libexec/pulseaudio-module-xrdp/
cp pulseaudio-xrdp.desktop /etc/xdg/autostart/
apt-get autoclean
adduser xrdp pulse-access
# echo "enable-autospawn = yes" >> /etc/pulse/client.conf
echo "\nload-module module-xrdp-sink\nload-module module-xrdp-source" >> /etc/pulse/default.pa
# echo "pulseaudio --start" > /etc/profile.d/pulseaudio.sh
echo "pulseaudio --start" > /etc/X11/Xsession.d/99pulseaudio
# なくても影響なかった 2025/3/19
# awk '{print $0;}/\[Globals\]/{print "enable_sound=true";}' /etc/xrdp/xrdp.ini > /tmp/xrdp.ini
# mv /tmp/xrdp.ini /etc/xrdp/
mkdir -p /var/run/dbus
dbus-uuidgen > /var/run/dbus/machine-id

# ログイン・ログアウト時にログを記録するスクリプトを起動する。
# echo 'session optional pam_exec.so /usr/local/sbin/session-log.sh' >> /etc/pam.d/common-session
# ただし、XRDPログインの場合、接続元が不明

# wtmpへの記録を追加する。
# echo 'session	required	pam_utmp.so' >> /etc/pam.d/xrdp-sesman
# 無効
