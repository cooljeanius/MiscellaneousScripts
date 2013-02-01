#!/bin/bash

echo "This script is being run as \"$0\""

echo "• Enabling Debug menus in various applications…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.Safari" "IncludeDebugMenu"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.AddressBook" "ABShowDebugMenu"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.appstore" "ShowDebugMenu"  true
defaults write kCFPreferencesAnyUser kCFPreferencesCurrentHost "com.apple.dvdplayer" "EnableDebugging"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.iCal" "IncludeDebugMenu"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.PhotoBooth" "EnableDebugMenu"  -1

echo "• Enabling QuickLook XRay Folders…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.finder" "QLEnableXRayFolders"  -1

echo "• Showing all files in Finder…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.finder" "AppleShowAllFiles"  -1

echo "• Setting Crash Report Type to Developer…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.CrashReporter" "DialogType"  crashreport

echo "• Setting screen capture output type…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.screencapture" "type"  TIF

echo "• Disabling quarantine…"
defaults write kCFPreferencesAnyUser kCFPreferencesCurrentHost "com.apple.LaunchServices" "LSQuarantine"  0
if [ "`whoami`" = "root" ]; then
	xattr -d -r com.apple.quarantine ./*
	if [ -d /Volumes/NO\ NAME ]; then
		xattr -d -r com.apple.quarantine /Volumes/NO\ NAME/Portable_Between_School_Library_Computers/*
	fi
else
	xattr -d com.apple.quarantine ./*
	if [ -d /Volumes/NO\ NAME ]; then
		xattr -d com.apple.quarantine /Volumes/NO\ NAME/Portable_Between_School_Library_Computers/*
	fi
fi

echo "• Enabling beep feedback…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost ".GlobalPreferences" "com.apple.sound.beep.feedback"  -1

echo "• Disabling defaulting to saving to iCloud…"
defaults write kCFPreferencesAnyUser kCFPreferencesCurrentHost ".GlobalPreferences" "NSDocumentSaveNewDocumentsToCloud"  0

echo "• Enabling Quartz 2d Extreme…"
defaults write kCFPreferencesAnyUser kCFPreferencesCurrentHost "com.apple.windowserver" "Quartz2DExtremeEnabled"  -1

echo "• Enabling Quartz GL…"
defaults write kCFPreferencesAnyUser kCFPreferencesCurrentHost "com.apple.windowserver" "QuartzGLEnabled"  -1

echo "• Warning about clear-text passwords in AFP…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.AppleShareClient" "afp_cleartext_warn"  -1

echo "• Disabling rubber-band scrolling…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost ".GlobalPreferences" "NSScrollViewRubberbanding"  0

echo "• Multiplying mouse speed…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost ".GlobalPreferences" "com.apple.mouse.scaling"  3

echo "• Showing other users in login window…"
defaults write kCFPreferencesAnyUser kCFPreferencesCurrentHost "com.apple.loginwindow" "SHOWOTHERUSERS_MANAGED"  -1

echo "• Enabling PostScript error logging…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.print" "DoPostScriptErrorHandler"  -1

echo "• Expanding print dialog by default…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost ".GlobalPreferences" "PMPrintingExpandedStateForPrint"  -1

echo "• Expanding save dialog by default…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost ".GlobalPreferences" "NSNavPanelExpandedStateForSaveMode"  -1

echo "• Using Scientific calculator by default…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.calculator" "ViewDefaultsKey"  Scientific

echo "• Enabling Webkit Developer Extras in Dictionary.app…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.Dictionary" "WebKitDeveloperExtras"  -1

echo "• Turning on all advanced Disk Utility options…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.DiskUtility" "DUDebugMenuEnabled"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.diskcopy" "expert-mode"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.DiskUtility" "advanced-image-options"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.DiskUtility" "DUShowEveryPartition"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.DiskUtility" "DUShowUnsupportedNetworks"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.finder" "DUDebugMenuEnabled"  -1

echo "• Turning on Dock stack highlighting…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.dock" "mouse-over-hilite-stack"  -1

echo "• Enabling all recents in Finder…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.NetworkBrowser" "EnableAllRecents"  -1

echo "• Enabling Finder quit menu item…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.finder" "QuitMenuItem"  -1

echo "• Turning on Finder path bar…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.finder" "ShowPathBar"  -1

echo "• Turning off .DS_Stores on Network…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.desktopservices" "DSDontWriteNetworkStores"  1

echo "• Enabling QuickLook slow motion…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.finder" "QLEnableSlowMotion"  -1

echo "• Showing this computer under Shared…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.NetworkBrowser" "ShowThisComputer"  -1

echo "• Turning on iCal HTTP logging…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.iCal" "LogHTTPActivity"  -1

echo "• Allowing half-stars in iTunes…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.iTunes" "allow-half-stars"  -1

echo "• Enabling iTunes booklet authoring…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.iTunes" "booklet-authoring-mode"  -1

echo "• Enabling iTunes carrier testing mode…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.iTunes" "carrier-testing"  -1

echo "• Modifying Keychain Access display options…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.keychainaccess" "Distinguish Legacy ACLs"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.keychainaccess" "Show Expired Certificates"  -1

echo "• Enabling third-party bundles in Mail…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.mail" "EnableBundles"  -1

echo "• Setting Safari tab bar to always show…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.Safari" "AlwaysShowTabBar"  -1

echo "• Enabling Safari Web Inspector…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.Safari" "WebKitDeveloperExtras"  -1

echo "• Enabling toggling of WebGL in Safari…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.Safari" "WebKitWebGLEnabled"  -1

echo "• Enabling advanced ScreenSharing options…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.ScreenSharing" "debug"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.ScreenSharing" "ShowBonjourBrowser_Debug"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.ScreenSharing" "skipLocalAddressCheck"  -1

echo "• Showing unsupported network volumes for Time Machine…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.systempreferences" "TMShowUnsupportedNetworkVolumes"  -1

echo "• Changing X11 options…"
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "org.x.X11" "nolisten_tcp"  0
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "com.apple.x11" "wm_click_through"  -1
defaults write kCFPreferencesCurrentUser kCFPreferencesAnyHost "org.x.X11" "wm_window_shading"  -1

if [ -d /Volumes/NO\ NAME ]; then 
	echo "Copying stuff from thumb drive…"
	if [ -d ~/Applications ]; then
		echo "•=> Copying applications…"
	else
		mkdir -v ~/Applications
		echo "•=> Copying applications…"
	fi
	cp -Rvp /Volumes/NO\ NAME/Portable_Between_School_Library_Computers/Applications/* ~/Applications
	echo "•=> Copying dotfiles…"
	cp -Rfvp /Volumes/NO\ NAME/Portable_Between_School_Library_Computers/my_dotfiles/chrooted/ ~/
	chmod -v -x ~/.bash_profile ~/.gitconfig ~/.CFUserTextEncoding ~/.viminfo ~/.Xauthority ~/.bash_history
	if [ -d ~/Library ]; then
		echo "•=> Copying Library items…"
	else
		mkdir -v ~/Library
		echo "•=> Copying Library items…"
	fi
	if [ -f ~/Library/Components ]; then
		rm -rfv ~/Library/Components
	fi
	if [ -f ~/Library/QuickLook ]; then
		rm -rfv ~/Library/QuickLook
	fi
	if [ -f ~/Library/KeyBindings ]; then
		rm -rfv ~/Library/KeyBindings
	fi
	if [ -f ~/Library/Application\ Support/iCloud ]; then
		rm -rfv ~/Library/Application\ Support/iCloud
	fi
	cp -Rfvp /Volumes/NO\ NAME/Portable_Between_School_Library_Computers/Library/* ~/Library
	if [ -d ~/Music/iTunes ]; then
		echo "•=> Copying iTunes music…"
	else
		mkdir -pv ~/Music/iTunes
		"•=> Copying iTunes music…"
	fi
	cp -Rfvp /Volumes/NO\ NAME/Portable_Between_School_Library_Computers/Music/iTunes/* ~/Music/iTunes
	if [ -d ~/Downloads ]; then
		echo "•=> Copying downloads…"
	else
		mkdir -v ~/Downloads
		echo "•=> Copying downloads…"
	fi
	cp -Rfvp /Volumes/NO\ NAME/Portable_Between_School_Library_Computers/Downloads/* ~/Downloads
else
	echo "•=> Portable USB drive not found."
fi

echo "• Attempting to fix resource forks…"
if [ "`whoami`" = "root" ]; then
	if [ -x /System/Library/CoreServices/fixupresourceforks ]; then
		/System/Library/CoreServices/fixupresourceforks
	else
		echo "•=> Oops… not possible."
	fi
else
	echo "•=> Cannot do that because we are not root."
fi

echo "• Making Library visible…"
if [ -z "`ls -lO ~/ | grep hidden | grep Library`" ]; then
	echo "•=> Library is already unhidden…"
else
	echo "•=> Unhiding Library…"
	chflags nohidden ~/Library
fi

echo "• Killing stuff that is either unnecessary or that needs to have its preferences regenerated…"
killall -vz Popup
killall -vz DFXLogin
killall -vz ARDAgent
killall -vz KeyAccess
killall -vz TISwitcher
killall -vz mdworker
killall -vz mdworker32
killall -vz SymSecondaryLaunch
killall -vz ScanNotification
killall -vz Symantec\ QuickMenu
killall -vz warmd_agent
killall -vz cookied
killall -vz lsboxd
killall -vz CVMCompiler
killall -vz GWAlert
killall -vz Dock
killall -vz Finder
killall -vz SystemUIServer
killall -vz Safari
killall -vz Adobe\ AIR\ Installer
killall -vz Adobe\ AIR\ Updater
killall -vz System\ Preferences
killall -vz ssh-agent
killall -vz AppleSpell.service
killall -vz helpd
killall -vz hiutil
killall -vz AirPort\ Base\ Station\ Agent
if [ "`whoami`" = "root" ]; then
	killall -vz navx
	killall -vz SymAutoProtect
	killall -vz smcdaemon
	killall -vz qmasterd
	killall -vz LiveUpdate
	killall -vz KeyAccess
	killall -vz karl
	killall -vz kass
	killall -vz TSDaemon
	killall -vz scheduledScanner
	killall -vz NortonMissedTasks
	killall -vz SAVDiskMountNotify
	killall -vz jlucaller
	killall -vz syguard
	killall -vz MachineRenamer
	killall -vz parentalcontrolsd
	killall -vz jamfAgent
	launchctl remove edu.northwestern.mmlc.MachineRenamer
	launchctl remove com.jamfsoftware.jamf.daemon
	launchctl remove com.jamfsoftware.task.Every\ 5\ Minutes
	if [ -d /Library/LaunchDaemons ]; then
		launchctl unload -w /Library/Launch*/com.jamfsoftware.*.plist
		launchctl unload -w /Library/Launch*/edu.northwestern.*.plist
		launchctl unload -w /Library/Launch*/com.apple.qmaster.*.plist
		launchctl unload -w /Library/Launch*/com.faronics.*.plist
		launchctl unload -w /Library/Launch*/com.symantec.*.plist
	fi
	if [ -d /Library/StartupItems/SymProtector ]; then
		rm -rf /Library/StartupItems/SymProtector
	fi 
	if [ -d /Library/StartupItems/SMC ]; then
		rm -rf /Library/StartupItems/SMC
	fi
	if [ -d /Library/StartupItems/SymAutoProtect ]; then
		rm -rf /Library/StartupItems/SymAutoProtect
	fi
	if [ -d /Library/StartupItems/NortonMissedTasks ]; then
		rm -rf /Library/StartupItems/NortonMissedTasks
	fi
	if [ -d /Library/StartupItems/KeyAccess ]; then
		rm -rf /Library/StartupItems/KeyAccess
	fi
	if [ -d /var/at/tabs ]; then
		rm -rf /var/at/tabs
	fi
	if [ -d /var/db/com.symantec ]; then
		rm -rf /var/db/com.symantec
	fi
	if [ -d /var/db/RemoteManagement ]; then
		rm -rf /var/db/RemoteManagement
	fi
else
	echo "Processes belonging to root left alone"
fi

echo "• Doing final setup now…"
echo "whoami = `whoami`"
echo "pwd = `pwd`"
open ~/
open -g /Applications/Utilities/Console.app
open -g /Applications/Utilities/Activity\ Monitor.app
open -g ~/Applications/Jumpcut.app
osascript -e "tell application \"Finder\"" -e "empty trash" -e "end tell"
find ./ -name .DS_Store -delete
if [ -d /Volumes/NO\ NAME ]; then
	find /Volumes/NO\ NAME/ -name .DS_Store -delete
fi
open /Applications/Utilities/Terminal.app
if [ -d ~/deepfreeze ]; then
	rmdir ~/deepfreeze
fi
if [ -f ~/.profile ]; then
	. ~/.profile
elif [ -f ~/.bash_profile ]; then
	. ~/.bash_profile
elif [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
bash

