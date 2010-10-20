# Desktop with customizationst to fit in a CD sized image (package removals, etc.)
# Maintained by the Fedora Desktop SIG:
# http://fedoraproject.org/wiki/SIGs/Desktop
# mailto:fedora-desktop-list@fedoraproject.org

%include fedora-live-desktop.ks
%include fedora-live-minimization.ks

%packages
# First, no office
-openoffice.org-*

# Temporary list of things removed from comps but not synced yet
-specspo

# Remove animated background
-laughlin-backgrounds-animated*

# Drop the Java plugin
-java-1.6.0-openjdk-plugin
-java-1.6.0-openjdk

# Drop things that pull in perl
-linux-atm
-perf

# No printing
-foomatic-db-ppds
-foomatic

# Dictionaries are big
-aspell-*
-hunspell-*
-man-pages*
-words

# Help and art can be big, too
-gnome-user-docs
-evolution-help
-gnome-games-help
-desktop-backgrounds-basic
-*backgrounds-extras

# Legacy cmdline things we don't want
-nss_db
-krb5-auth-dialog
-krb5-workstation
-pam_krb5
-quota
-nano
-minicom
-dos2unix
-finger
-ftp
-jwhois
-mtr
-pinfo
-rsh
-telnet
-nfs-utils
-ypbind
-yp-tools
-rpcbind
-acpid

# Drop some system-config things
-system-config-boot
-system-config-language
-system-config-network
-system-config-rootpassword
-system-config-services
-policycoreutils-gui

%end

%post
# Since we aren't including the animated backgrounds we should use the plain one
.
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults
 -t str -s /desktop/gnome/background/picture_filename /usr/share/backgrounds/lau
ghlin/default/laughlin.xml
%end
