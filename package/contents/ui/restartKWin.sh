#!/usr/bin/env bash

if [ "$XDG_SESSION_TYPE" == "x11" ]; then
    nohup kwin_x11 --replace > /dev/null 2>&1 &
elif [ "$XDG_SESSION_TYPE" == "wayland" ]; then
    kdialog --title "Exquisite" --warningyesno "Restarting KWin on Wayland will cause the entire session to restart, closing all applications and background processes. Are you sure you want to proceed?" --yes-label "Restart Session" --no-label "Cancel"
    if [ "$?" == "0" ]; then
        nohup kwin_wayland --replace > /dev/null 2>&1 &
    fi
else
    kdialog --title "Exquisite" --error "Couldn't identify session type.\nThe value of XDG_SESSION_TYPE is: $XDG_SESSION_TYPE"
fi
