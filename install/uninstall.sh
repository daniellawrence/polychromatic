#!/bin/bash
#
# Polychromatic is free software: you can redistribute it and/or modify
# it under the temms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Polychromatic is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Polychromatic. If not, see <http://www.gnu.org/licenses/>.
#
# Copyright (C) 2016 Luke Horwell <luke@ubuntu-mate.org>
#
############################################################################
# This script manually deletes the Polychromatic and Python
# libraries from the system.
############################################################################

# Paths
target_data="/usr/share/polychromatic"
target_bin="/usr/bin"
target_icon="/usr/share/icons"
modules="/usr/lib/python3/dist-packages/polychromatic"
locale_dir="/usr/share/locale/"

function delete_directory {
    dir="${1}"
    if [ -d ${dir} ];then
	echo rm -rf "${dir}"
    fi
}

function delete_file {
    file="${1}"
    if [ -d "${file}" ];then
	echo rm "${file}"
    fi
}

# Are we root?
if [ "$(id -u)" != "0" ]; then
    echo "To uninstall, this script must be run as root." 1>&2
    exec sudo "$0"
    exit
fi

# If a clean removal script is present, run that instead.
clean_script="$target_data/uninstall-polychromatic.sh"
if [ ! "$0" == "$clean_script" ]; then
    if [ -f "$clean_script" ]; then
        echo "Cleanly removing the software from your system..."
        exec "$clean_script"
    fi
fi

# Deleting files
delete_directory "$target_data"
delete_directory "$modules"
delete_file      "$target_bin/polychromatic-controller"
delete_file      "$target_bin/polychromatic-tray-applet"
delete_file      "$target_icon/hicolor/scalable/apps/polychromatic.svg"
delete_directory /usr/share/applications/polychromatic-controller.desktop
delete_directory /usr/share/applications/polychromatic-tray-applet.desktop
delete_directory /etc/xdg/autostart/polychromatic-tray-applet.desktop

# Delete locales
find $locale_dir -name "polychromatic-controller.mo" -type f -delete
find $locale_dir -name "polychromatic-tray-applet.mo" -type f -delete

# Post removal
update-icon-caches /usr/share/icons/hicolor/

# Success!
echo "Uninstall Success!"
exit 0

