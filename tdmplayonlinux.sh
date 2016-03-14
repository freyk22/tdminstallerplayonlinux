#!/bin/bash
# Date : 2015-05-28
# Last revision : 2015-06-07
# Wine version used : 1.7.16
# Distribution used to test : Mac OS 10.9.5
# Author : Freek 'Freyk' Borgerink
# Licence : GPL
  
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
  
TITLE="The Dark Mod"
PREFIX="TheDarkMod"
EDITOR="Broken Glass Studios"
GAME_URL="http://www.thedarkmod.com"
AUTHOR="Freek 'Freyk' Borgerink"
WORKING_WINE_VERSION="1.7.16"
 
#md5hash of tdm_update_win.zip from the thedarkmod.com site
TDMWINUPDATERDOWNLOADLOCATION="http://www.fidcal.com/darkuser/tdm_update_win.zip"
#$TDMWINUPDATERHASH="ff1b6d10c65970422206133e923cf36d"
 
 
################################
 
#function to run the updater
function fncRunUpdater {
        POL_SetupWindow_message "$(eval_gettext 'Going to run the updater. In the updater click only on continue or ok.\nIf the updater fails, close all the windows and run the updater again with the shortcut.')" "$TITLE"
        cd "$WINEPREFIX/drive_c/games/thedarkmod"
         POL_SetupWindow_wait_next_signal "The Dark Mod Updater in progress." "$TITLE"
        #POL_Wine_WaitBefore "$TITLE"
        POL_Wine "$WINEPREFIX/drive_c/games/thedarkmod/tdm_update.exe"
         #POL_SetupWindow_detect_exit
         POL_Wine_WaitExit "$TITLE"
}
 
#function to check if the dark mod executable is present
function fncFilePresenceCheck {
        FILE="$WINEPREFIX/drive_c/games/thedarkmod/TheDarkMod.exe"
        #POL_SetupWindow_message "$(eval_gettext 'Going to check the file presence of $FILE ')" "$TITLE"
        if [ -f $FILE ]; then
                #POL_SetupWindow_message "$(eval_gettext 'The Dark Mod Executable is present')" "$TITLE"
                POL_Shortcut "TheDarkMod.exe" "The Dark Mod"
        else
                POL_SetupWindow_message "$(eval_gettext 'The Dark Mod Executable is not present on your system\nPlease rerun the updater using the shortcut\nand create the shortcut mannualy')" "$TITLE"
        fi
}
 
#Starting the script
POL_SetupWindow_Init

#Starting debugging API
POL_Debug_Init
  
POL_SetupWindow_presentation "$TITLE" "$EDITOR" "$GAME_URL" "$AUTHOR" "$PREFIX"
 
#Select the download method.
#cant use POL_SetupWindow_InstallMethod, because there are more installation methods
POL_SetupWindow_menu "$(eval_gettext 'How would you like to install The Dark Mod?')" "Install Method" "Online|Local updater zip|Local Standonlone zip" "|"
INSTALLMETHOD="$APP_ANSWER"
 
if [ "$INSTALLMETHOD" = "Online" ]
then
        #create prefix folder
        POL_Wine_SelectPrefix "$PREFIX"
        POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"
        mkdir -p "$WINEPREFIX/drive_c/games/thedarkmod"
    cd "$WINEPREFIX/drive_c/games/thedarkmod"
        #Download tdm updater
        POL_Download "$TDMWINUPDATERDOWNLOADLOCATION" #"$TDMWINUPDATERHASH"
        #Unpack the zipfile
        POL_System_ExtractSingleFile "$WINEPREFIX/drive_c/games/thedarkmod/tdm_update_win.zip" "tdm_update.exe" "$WINEPREFIX/drive_c/games/thedarkmod/tdm_update.exe"
    rm "$WINEPREFIX/drive_c/games/thedarkmod/tdm_update_win.zip"
    #Create shortcut for updater
        POL_Shortcut "tdm_update.exe" "The Dark Mod Updater"
        fncRunUpdater
        fncFilePresenceCheck
fi
 
if [ "$INSTALLMETHOD" = "Local updater zip" ]
then
        #create prefix folder
    POL_SetupWindow_message "$(eval_gettext 'Please download the darkmod updater zip file from \n$GAME_URL')" "$TITLE"
        POL_SetupWindow_browse "$(eval_gettext 'Please select the darkmod updater zip file to run.\nIt must have the name tdm_update_win.zip')" "$TITLE"
        # Setting prefix
        POL_Wine_SelectPrefix "$PREFIX"
        POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"
    mkdir -p "$WINEPREFIX/drive_c/games/thedarkmod"
    #Unpack the zipfile
        POL_System_ExtractSingleFile "$APP_ANSWER" "tdm_update.exe" "$WINEPREFIX/drive_c/games/thedarkmod/tdm_update.exe"
        #Create the shortcuts
        POL_Shortcut "tdm_update.exe" "The Dark Mod Updater"
        fncRunUpdater
        fncFilePresenceCheck       
fi
 
if [ "$INSTALLMETHOD" = "Local Standonlone zip" ]
then
        POL_SetupWindow_message "$(eval_gettext 'Please download first The Dark Mod standalone release zip-file:\n\nTHE DARK MOD Version 2.0 - Standalone Release\n\nFrom sites like: \n$GAME_URL\nhttp://www.moddb.com\nhttp://www.google.com')" "$TITLE"
        POL_SetupWindow_browse "$(eval_gettext 'Please select the darkmod standalone release zip file to run.')" "$TITLE"
        #create prefix folder
        POL_Wine_SelectPrefix "$PREFIX"
        POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"
    mkdir -p "$WINEPREFIX/drive_c/games/"
    #Unpack the zipfile
    cd "$WINEPREFIX/drive_c/games/"
        POL_System_unzip "$APP_ANSWER"
        #rename folder
        mv "$WINEPREFIX/drive_c/games/THE DARK MOD Version 2.0 - Standalone Release/" "$WINEPREFIX/drive_c/games/thedarkmod"
        #Set permissions
        chmod -R ug+rw "$WINEPREFIX/drive_c/games/thedarkmod"
        #set shortcut
        POL_Shortcut "TheDarkMod.exe" "The Dark Mod"
        POL_Shortcut "tdm_update.exe" "The Dark Mod Updater"
        POL_SetupWindow_menu "$(eval_gettext 'The 2.0 updater doesnt run on $WORKING_WINE_VERSION.\nWould you like that I download a newer version of the the updater\nand then update the files?')" "Run Updater" "Yes|No" "|"
        if [ "$APP_ANSWER" = "Yes" ]
        then
                POL_SetupWindow_message "$(eval_gettext 'Going Online to update the updater and run it.')" "$TITLE"
                cd "$WINEPREFIX/drive_c/games/thedarkmod"
                #Download tdm updater
                POL_Download "$TDMWINUPDATERDOWNLOADLOCATION" #"$TDMWINUPDATERHASH"
                #remove old updater
                rm "$WINEPREFIX/drive_c/games/thedarkmod/tdm_update.exe"
                rm "$WINEPREFIX/drive_c/games/thedarkmod/tdm_update.log"
                #Unpack the zipfile
                POL_System_ExtractSingleFile "$WINEPREFIX/drive_c/games/thedarkmod/tdm_update_win.zip" "tdm_update.exe" "$WINEPREFIX/drive_c/games/thedarkmod/tdm_update.exe"
            rm "$WINEPREFIX/drive_c/games/thedarkmod/tdm_update_win.zip"
                fncRunUpdater
        fi       
fi
 
#Setting wine stuff
#send end message 
POL_SetupWindow_message "$(eval_gettext 'This is the end of the $TITLE installation script. \n\nFor more info, visit $GAME_URL')" "end"
POL_SetupWindow_Close
exit 0


