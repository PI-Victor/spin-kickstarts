# Fedora Education Math
#
# Filename:
#   fedora-livecd-education-math.ks
# Description:
#   Fedora Live Spin including mainly software for educational & mathematical purposes
# Maintainers:
#   Sebastian Dziallas <sdz AT fedoraproject DOT org>
#   Fedora Education SIG
# Acknowledgements:
#   Rex Dieter
#   Thorsten Leemhuis

%include fedora-live-base.ks

%packages

# KDE packages
desktop-backgrounds-basic
guidance-power-manager
kdebase
kdegraphics
kdemultimedia
kdeutils
# koffice-kpresenter
# koffice-kspread
# koffice-kword
kde-settings-pulseaudio
NetworkManager-gnome

# additional office packages
# koffice pulls in kdelibs3
abiword
gnumeric

# mathematical apps selected by the SIG
kdeedu-math
qalculate-gtk
wxMaxima
octave
gnuplot
Macaulay2
orpie

# some extras
fuse
# pavucontrol

# additional fonts
# @fonts
# fonts-ISO8859-2 
# cjkunifonts-ukai 
# madan-fonts 
# fonts-KOI8-R 
# fonts-KOI8-R-100dpi 
# tibetan-machine-uni-fonts
-abyssinica-fonts
-cjkunifonts-uming
-baekmuk-ttf-fonts-gulim
-dejavu-fonts-experimental
-jomolhari-fonts
-kacst-fonts
-paktype-fonts
-lklug-fonts
-lohit-fonts-*
-thaifonts-scalable
-VLGothic-fonts

# FIXME/TODO: recheck the removals here
# try to remove some packages from livecd-fedora-base-desktop.ks
-scim*
-gdm
-authconfig-gtk
-m17n*
-PolicyKit-gnome
-gnome-doc-utils-stylesheets
-anthy
-kasumi
-pygtkglext
-python-devel
-libchewing

# save some space (from @base)
-make
-nss_db
-autofs

# -@dial-up
-isdn4k-utils
-lrzsz
-rp-pppoe
-minicom
-wvdial

# misc
-comps-extras
-gutenprint
-gutenprint-foomatic
-jwhois
-rdist
-rdate

%end

%post

# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop <<EOF
DESKTOP="KDE"
DISPLAYMANAGER="KDE"
EOF

# add initscript
cat >> /etc/rc.d/init.d/livesys << EOF

if [ -e /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png ] ; then
    # use image also for kdm
    mkdir -p /usr/share/apps/kdm/faces
    cp /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png /usr/share/apps/kdm/faces/fedora.face.icon
fi

# make fedora user use KDE
echo "startkde" > /home/liveuser/.xsession
chmod a+x /home/liveuser/.xsession
chown liveuser:liveuser /home/liveuser/.xsession

# set up autologin for user fedora
sed -i 's/#AutoLoginEnable=true/AutoLoginEnable=true/' /etc/kde/kdm/kdmrc
sed -i 's/#AutoLoginUser=fred/AutoLoginUser=liveuser/' /etc/kde/kdm/kdmrc

# set up user fedora as default user and preselected user
sed -i 's/#PreselectUser=Default/PreselectUser=Default/' /etc/kde/kdm/kdmrc
sed -i 's/#DefaultUser=johndoe/DefaultUser=liveuser/' /etc/kde/kdm/kdmrc

# add apps to favorites menu
mkdir -p /home/liveuser/.kde/share/config/
cat > /home/liveuser/.kde/share/config/kickoffrc << MENU_EOF
[Favorites]
FavoriteURLs=/usr/share/applications/kde4/konqbrowser.desktop,/usr/share/applications/kde4/dolphin.desktop,/usr/share/applications/liveinst.desktop
MENU_EOF
chown -R liveuser:liveuser /home/liveuser/.kde/

# show liveinst.desktop on and in menu
sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop

# workaround to start nm-applet automatically
cp /etc/xdg/autostart/nm-applet.desktop /usr/share/autostart/

%end
