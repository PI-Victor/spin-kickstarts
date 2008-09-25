# fedora-livecd-kde.ks
#
# Description:
# - Fedora Live Spin with the K Desktop Environment (KDE)
#
# Maintainer(s):
# - Sebastian Vahl <fedora@deadbabylon.de>
# - Fedora KDE SIG

%include fedora-live-base.ks

%packages

# workaround to put it on the beta
phonon-backend-xine

@kde-desktop

# unwanted packages from @kde-desktop
# don't include these for now to fit on a cd

### amarok has duplicate functionality with juk (~10 megs)
#-amarok
### digikam has duplicate functionality with gwenview (~11 megs)
-digikam
### kdeedu is too big for the live images
-kdeedu
### scribus is too big for the live images
-scribus
### kget has also basic torrent features (~3 megs)
-ktorrent
### konqueror is also able to browse ftp shares (~1 megs)
#-kftpgrabber*
### kaffeine has duplicate functionality with dragonplayer (~3 megs)
-kaffeine*
### the removal of kdegames will free ~31 megs
#-kdegames


# Useful additional KDE3 applications
koffice-kword
koffice-kspread
koffice-kpresenter
koffice-filters
k3b
filelight
# twinkle (~10 megs)
#twinkle


# some extras
fuse
# nice to have but pulls in gstreamer
#pavucontrol


# additional fonts
@fonts
#fonts-ISO8859-2 
#cjkunifonts-ukai 
#madan-fonts 
#fonts-KOI8-R 
#fonts-KOI8-R-100dpi 
#tibetan-machine-uni-fonts


# FIXME/TODO: recheck the removals here
# try to remove some packages from fedora-live-base.ks
-gdm
-authconfig-gtk

# save some space (from @base)
-make
-nss_db
-autofs

%end

%post

# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop <<EOF
DESKTOP="KDE"
DISPLAYMANAGER="KDM"
EOF

# add initscript
cat >> /etc/rc.d/init.d/fedora-live << EOF

if [ -e /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png ] ; then
    # use image also for kdm
    mkdir -p /usr/share/apps/kdm/faces
    cp /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png /usr/share/apps/kdm/faces/fedora.face.icon
fi

# make fedora user use KDE
echo "startkde" > /home/fedora/.xsession
chmod a+x /home/fedora/.xsession
chown fedora:fedora /home/fedora/.xsession

# set up autologin for user fedora
sed -i 's/#AutoLoginEnable=true/AutoLoginEnable=true/' /etc/kde/kdm/kdmrc
sed -i 's/#AutoLoginUser=fred/AutoLoginUser=fedora/' /etc/kde/kdm/kdmrc

# set up user fedora as default user and preselected user
sed -i 's/#PreselectUser=Default/PreselectUser=Default/' /etc/kde/kdm/kdmrc
sed -i 's/#DefaultUser=johndoe/DefaultUser=fedora/' /etc/kde/kdm/kdmrc

# add liveinst.desktop to favorites menu
mkdir -p /home/fedora/.kde/share/config/
cat > /home/fedora/.kde/share/config/kickoffrc << MENU_EOF
[Favorites]
FavoriteURLs=/usr/share/applications/kde4/konqbrowser.desktop,/usr/share/applications/kde4/dolphin.desktop,/usr/share/applications/kde4/systemsettings.desktop,/usr/share/applications/liveinst.desktop
MENU_EOF
chown -R fedora:fedora /home/fedora/.kde/

# show liveinst.desktop on and in menu
sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop

EOF

%end
