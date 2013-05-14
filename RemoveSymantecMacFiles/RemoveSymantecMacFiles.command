#!/bin/sh
# File Name:    RemoveSymantecMacFiles.command
  Version=6.0.22
# Author:       Corey Swertfager, Symantec Corporation
# Watermark ID:	CB70-6840-3597-44-15-4
# Created:      10/04/2001
# Modified:     05/10/2013
#
# WARNING: This script will remove all files and folders created by
#          Symantec OS X products (except Symantec Adminstration Console
#          for Macintosh files) and any files within those folders.
#          Therefore, you will lose ALL files that reside in those folders,
#          including any that you have created.
#
# Usage:   RemoveSymantecMacFiles.command [options] [volume ...]
#
# Summary: See ShowUsage() function.
#
# History: 5.00 - Ported code from version 4.27.
#                 Now removes crontab entries from any OS X boot volume.
#                 Now removes Symantec items from loginwindow.plist files.
#                 Now removes receipts from any volume.
#                 Now checks for Symantec kexts/processes in memory when
#                 determining when a restart is necessary.
#                 Added -f option to suppress output of removed files.
#                 Now shows names of files as they are removed, unless the
#                 -f option is specified.
#          5.01 - Now removes:
#                    /Library/Contextual Menu Items/SAVCMPlugIn.plugin
#          5.02 - Adjusted output when a folder/file cannot be removed.
#                 Removed warning when /Library/StartupItems remains.
#                 Now removes:
#                    /Library/Application Support/Symantec/Daemon/SymDaemon.bundle
#                    /Library/Application Support/Symantec/Daemon
#                    /Library/Application Support/Symantec/SymUIAgent
#                    /Library/Application Support/Symantec/WebFraud
#                    /Library/Contextual Menu Items/SymFileSecurityCM.plugin
#                    /Library/PrivateFrameworks/SymAppKitAdditions.framework
#                    /Library/PrivateFrameworks/SymBase.framework
#                    /Library/PrivateFrameworks/SymConfidential.framework
#                    /Library/PrivateFrameworks/SymSharedSettings.framework
#                    /Library/Receipts/SymConfidential.pkg
#                    /Library/Receipts/SymFileSecurity.pkg
#                    /Library/Receipts/SymSharedFrameworks.pkg
#                    /Library/Receipts/SymSharedSettings.pkg
#                    /private/etc/mach_init.d/SymSharedSettings.plist
#          5.03 - Now removes:
#                    /Applications/Norton Confidential.app
#                    /Library/Application Support/Symantec/IntrusionPrevention
#                    /Library/LaunchDaemons/com.symantec.symdaemon.plist
#                    /Library/LaunchDaemons/com.symantec.uiagent.bundle
#                    /Library/PrivateFrameworks/SymDaemon.framework
#                    /Library/PrivateFrameworks/SymInternetSecurity.framework
#                    /Library/PrivateFrameworks/SymUIAgent.framework
#                    /Library/PrivateFrameworks/SymUIAgentUI.framework
#                    /Library/Receipts/SymConfidentialData.pkg
#                    /Library/Receipts/SymDaemon.pkg
#                    /Library/Receipts/SymFileSecurity.pkg
#                    /Library/Receipts/SymInternetSecurity.pkg
#                    /Library/Receipts/SymIntrusionPrevention.pkg
#                    /Library/Receipts/SymNCOApplication.pkg
#                    /Library/Receipts/SymUIAgent.pkg
#                    /Library/Receipts/SymWebFraud.pkg
#                    /Library/Receipts/WCIDEngine.pkg
#                    /System/Library/Extensions/SymInternetSecurity.kext
#                    /System/Library/Extensions/SymIPS.kext
#                    /System/Library/SymInternetSecurity.kext
#          5.04 - Now removes:
#                    /Applications/Firefox.app/Contents/MacOS/extensions/{0e10f3d7-07f6-4f12-97b9-9b27e07139a5}
#                    /Library/Application Support/Symantec/Assistants/Norton Confidential
#                    /Library/Application Support/Symantec/Assistants/Symantec Setup Assistant.app
#                    /Library/Application Support/Symantec/Assistants/Symantec Setup Assistant.bundle
#                    /Library/Application Support/Symantec/Assistants
#                    /Library/Receipts/SymSetupAssistant.pkg
#          5.05 - Now removes:
#                    /Library/Preferences/com.symantec.sharedsettings
#          5.06 - Now removes:
#                    /Library/Application Support/Symantec/Settings
#          5.07 - Now removes:
#                    /Library/LaunchDaemons/com.symantec.uiagent.plist
#          5.08 - Now removes:
#                    */Library/Preferences/com.symantec.uninstaller.plist
#          5.09 - Now only removes when empty:
#                    /Library/Application Support/Symantec/Assistants
#                    /Library/Application Support/Symantec/Daemon
#          5.10 - Now removes:
#                    /Library/Application Support/Symantec/Daemon/error.log
#                 Added volume name to paths in progress.
#          5.11 - Now removes:
#                    /Applications/Firefox.app/Contents/MacOS/extensions/{29dd9c80-9ea1-4aaf-9305-a0314aba24e3}
#          5.12 - Now removes:
#                    /private/var/tmp/com.symantec.liveupdate.*
#          5.13 - OSXvnc StartupItems are now filtered out during Symantec
#                 process checking.
#          5.14 - Modified for OS 10.5 compatibility.
#                 No longer removes empty /Library/StartupItems.
#                 Now removes:
#                    /Library/InputManagers/Norton Confidential for Safari
#                 Now removes files installed by NAV 11 build 1.
#          5.15 - Now removes:
#                    /.symSchedScanLockxz
#                 RemoveInvisibleFilesFromVolume functions now removes:
#                    /.SymAVQSFile
#                 Added DeleteLaunchdPlists function to remove Symantec
#                 Scheduler launchd plists.
#                 Added messaging when there are no Symantec crontab
#                 entries to delete.
#                 Renamed Remove function to RemoveItem.
#                 RemoveItem function can now match several files.
#                 Now removes additional files installed by NAV 11.
#                 A list of files deleted by this program is now appended
#                 to ReadMe.txt.
#                 All com.symantec.* preferences are now shown when using
#                 the -L option to show all files that would be deleted.
#          5.16 - Now removes:
#                    */Library/Preferences/com.symantec.nortonantivirus.*
#                    */Library/Preferences/com.symantec.nortonconfidential.*
#                    */Library/Preferences/com.symantec.schedScanResults*
#                    */Library/Preferences/com.symantec.symsched*
#          5.17 - Adjusted grep filters in SymantecIsInMemory function.
#                 Now removes:
#                    /Applications/Norton AntiVirus.app
#          5.18 - Changed how ShowVersion is called for OS 10.5 compatibility.
#          5.19 - Now removes:
#                    /Library/Internet Plug-Ins/Norton Confidential for Safari.plugin
#          5.20 - Now removes:
#                    /Library/Receipts/SymantecAVDefs*
#                    /private/tmp/com.symantec.liveupdate.restart
#          5.21 - Added output to DeleteSymantecLoginItems function.
#                 Revised output of -l and -L options.
#                 Now removes:
#                    /Library/Receipts/SymStuffit.pkg
#          5.22 - Now removes:
#                    /Library/Application Support/Symantec/Protector
#                    /Library/Receipts/SymProtector.pkg
#                    /Library/StartupItems/SymProtector
#          5.23 - Now removes:
#                    /Library/Receipts/SavLog.pkg
#          5.24 - Changed the assignment order of CRONDIR to account for
#                 cases where OS 10.5 was installed over OS 10.4.
#          5.25 - Now removes:
#                    */Library/Preferences/com.Symantec.SAVX.*
#          5.26 - Now removes:
#                    /Library/Application Support/Symantec/Assistants/Client Firewall
#                    /Library/Application Support/Symantec/Assistants/SCF Assistant Startup.app
#                    /Library/Application Support/Symantec/DeepSight
#                    /Library/Application Support/Symantec/Firewall
#                    /Library/LaunchDaemons/com.symantec.deepsight-extractor.plist
#                    /Library/LaunchDaemons/com.symantec.npfbootstrap.plist
#                    /Library/PrivateFrameworks/SymFirewall.framework
#                    /Library/PrivateFrameworks/SymPersonalFirewall.framework
#                    /System/Library/Extensions/SymPersonalFirewall.kext
#                    /usr/bin/scfx
#          5.27 - Now removes:
#                    /Library/Application Support/Symantec/Daemon/debug.log
#                    /Library/Receipts/SymantecClientFirewall.pkg
#                    /Library/Receipts/SymFirewall.pkg
#                    /Library/Receipts/SymPersonalFirewallCore.pkg
#          5.28 - Now removes:
#                    /Library/Application Support/Symantec/Assistants/Norton Firewall
#                    /Library/Application Support/Symantec/Assistants/NPF Assistant Startup.app
#                    /Library/Receipts/NortonFirewall.pkg
#                    /Library/Receipts/SymPersonalFirewallUI.pkg
#                    /usr/bin/npfx
#          5.29 - Added ReceiptsTable variable and RunPredeleteScripts
#                 function to incorporate the running of predelete scripts.
#                 Added -e option to show predelete errors.
#          5.30 - Now removes:
#                    /Library/Application Support/Symantec/Assistants/NIS Assistant Startup.app
#                    /Library/Application Support/Symantec/Assistants/Norton Internet Security
#                    /Library/Receipts/NortonInternetSecurity.pkg
#          5.31 - Now removes temporary files used by this program.
#                 Added running of pre_delete scripts to RunPredeleteScripts functions.
#          5.32 - Adjusted DeleteSymantecLoginItems diff filtering.
#          5.33 - Now removes:
#                    /private/tmp/symask
#          5.34 - Now removes:
#                    /Library/LaunchDaemons/com.symantec*
#                    /Library/Preferences/com.symantec*
#                       [except com.symantec.sacm* and com.symantec.smac*]
#                    {each user's home directory}/Library/Preferences/com.symantec*
#                       [except com.symantec.sacm* and com.symantec.smac*]
#                    {each user's home directory}/Library/Preferences/Network/com.symantec*
#                    /Library/Preferences/Network/com.symantec*
#                 Added -x option to RemoveItem function.
#                 RemoveItem function now ignores letter case when a
#                 pattern or an exclusion is passed.
#                 Links in /Volumes are now ignored.
#          5.35 - Removed return statement that caused premature script end.
#          5.36 - Now removes items installed by NFS 100.001:
#                    /Library/Application Support/Symantec/Norton Family Safety
#                    /Library/Internet Plug-Ins/Norton Family Safety.plugin
#                    /Library/PreferencePanes/Norton Family Safety.prefPane
#                    /Library/Receipts/NFSCore.pkg
#          5.37 - Revised pattern to find Symantec processes.
#                 Now removes all Dev.pkg receipts.
#          5.38 - Now removes items installed by NSM 100.008:
#                    /Library/Application Support/Symantec/Norton Safety Minder
#                    /Library/Internet Plug-Ins/Norton Safety Minder.plugin
#                    /Library/PreferencePanes/Norton Safety Minder.prefPane
#                    /Library/PreferencePanes/Ribbon.Norton.prefPane
#                    /Library/Receipts/NSMCore.pkg
#          5.39 - Now removes:
#                    /Library/Caches/com.symantec*
#                    /Library/Caches/Norton*
#                    /Library/Caches/Symantec*
#                    /Library/Logs/Norton*
#                    /Library/Logs/Symantec*
#                    /Library/Logs/SymDeepsight*
#                    /Library/Logs/SymFWLog.log
#                    /Library/Logs/SymFWRules.log*
#                    /Library/Preferences/wcid
#                    /private/var/tmp/com.symantec*
#                    {each user's home directory}/Library/Caches/com.symantec*
#                    {each user's home directory}/Library/Caches/Norton*
#                    {each user's home directory}/Library/Caches/Symantec*
#                    {each user's home directory}/Library/Preferences/wcid
#          5.40 - Fixed an erroneous "invalid password" error message.
#                 Non-removal of /opt is no longer considered an error
#                 (some third party programs install files into there).
#          5.41 - Updated Usage(s) comments.
#          5.42 - Now removes:
#                    /Library/PrivateFrameworks/SymWebKitUtils.framework
#          5.43 - Now removes:
#                    /Library/InputManagers/Norton Safety Minder
#          5.44 - Now removes:
#                    /var/db/receipts/com.symantec*
#          5.45 - Now removes if empty folder:
#                    /Library/Preferences/Network
#                 Now removes:
#                    /Applications/Firefox.app/Contents/MacOS/extensions/nortonsafetyminder@symantec.com
#          5.46 - Added -d option.
#                 Updated help.
#          5.47 - Added running of predelete scripts stored in new Symantec
#                 Uninstaller's Receipt folder.
#                 Now removes:
#                    /Library/Application Support/Symantec/Uninstaller
#                 Added -Q and -QQ options.
#                 Added KillTerminal function.
#          5.48 - Restart prompt is now shown any time boot volume is checked
#                 and there are Symantec processes and/or kexts in memory,
#                 except when -l or -L is passed.
#                 Now removes:
#                    /Library/Application Support/Symantec/Registry
#                    /Library/Application Support/Symantec/Submissions
#                    /Library/Application Support/Symantec/SymWebKitUtils
#                    /Library/PrivateFrameworks/SymSubmission.framework
#                    /Library/Receipts/SymSubmission.pkg
#                    /Library/Receipts/SymWebKitUtils.pkg
#                 Now removes /Library/PrivateFrameworks/SymWebKitUtils.framework
#                 only if the framework does not contain SymWKULoader.dylib; its
#                 receipt is removed if SymWKULoader.dylib does not exist or if
#                 /Library/StartupItems/CleanUpSymWebKitUtils exists.
#          5.49 - Excluded /LiveUpdateAdminUtility/ from processes to find in
#                 SymantecIsInMemory function.
#          5.50 - Fixed RunPredeleteScripts function so that it runs more than
#                 just the first predelete script in Symantec Uninstaller's
#                 Receipts folder and allows for multiple predelete scripts in
#                 /Library/Receipts receipts.
#                 Now removes:
#                    /Library/InputManagers/SymWebKitUtils
#                    /Library/StartupItems/SymQuickMenuOSFix
#                    /Library/StartupItems/SymWebKitUtilsOSFix
#                 Restart prompt is now shown if CleanUpSymWebKitUtils exists in
#                 /Library/StartupItems.
#                 Running ofLiveUpdate.pkg predelete script is no longer skipped.
#          5.51 - Now removes:
#                    /Library/Application Support/Symantec/SEP
#                    /Library/Application Support/Symantec/SMC
#                    /Library/Application Support/Symantec/SNAC
#                    /Library/LaunchAgents/com.symantec*
#                    /Library/Receipts/SMC.pkg
#                    /Library/Receipts/SNAC.pkg
#                    /Library/Receipts/Symantec Endpoint Protection.pkg
#                    /Library/Receipts/SymantecSAQuickMenu.pkg
#                    /Library/Services/ScanService.service
#                    /Library/Services [deleted if empty]
#                    /Library/StartupItems/SMC
#                    /usr/lib/libsymsea.1.0.0.dylib
#                    /usr/lib/libsymsea.dylib
#                 Adjusted RunPredeleteScripts function to limit predelete script
#                 names to those ending with predelete or pre_delete; doing so
#                 prevents a bus error by no longer running "predeletetool".
#          5.52 - Added -m option to use more program when -l, -L, or -R
#                 options are used.
#                 Removed -r option, which deleted only receipts.
#                 Added -R option to include folder contents when showing
#                 installed files.
#                 Progress shown when using the -l, -L, or -R options is
#                 now sent to standard error to facilitate piping the
#                 generated report to a file without piping progress.
#          5.53 - Now removes:
#                    /Library/ScriptingAdditions/SymWebKitUtils.osax
#                    /Library/ScriptingAdditions/SymWebKitUtilsSL.osax
#                    /usr/local/lib/libgecko3parsers.dylib
#                    /usr/local/lib [deleted if empty]
#                    /usr/local [deleted if empty]
#          5.54 - Now removes:
#                    /private/var/db/receipts/com.symantec*
#          5.55 - Now removes:
#                    /Library/Receipts/LiveUpdate*
#                    /Library/Application Support/Symantec/AntiVirus.kextcache
#                 RunPredeleteScripts function now also runs predelete scripts for
#                 receipts in ReceiptsTable that pass option -a.
#          5.56 - Now removes:
#                    /private/tmp/jlulogtemp
#                    /private/tmp/LiveUpdate.*
#                    /private/tmp/liveupdate
#                    /private/tmp/lulogtemp
#                    /private/tmp/SymSharedFrameworks*
#                    /private/var/db/receipts/$(SYM_SKU_REVDOMAIN).install.bom
#                    /private/var/db/receipts/$(SYM_SKU_REVDOMAIN).install.plist
#                    /private/var/tmp/com.Symantec*
#          5.57 - Now removes:
#                    /Library/Application Support/nis_postuninstall.rb
#                    /Library/Application Support/nis_postuninstall.sh
#          5.58 - Now removes:
#                    /Library/Receipts/NSMCore.Universal.pkg
#          5.59 - Now removes:
#                    /Applications/Norton DNS Beta.app
#                    /Applications/Norton DNS.app
#                    /Library/Application Support/Symantec/Norton DNS
#                    /Library/LaunchDaemons/com.norton
#                    /private/var/log/nortondns.log
#                    {each user's home directory}/Library/Caches/com.norton
#                    {each user's home directory}/Library/Preferences/com.norton
#          5.60 - Now removes:
#                    /Library/Preferences/com.norton*
#                    {each user's home directory}/Library/Preferences/com.norton*
#                 The following removals were added in version 5.59, but the version
#                 history erroneously left off the trailing *:
#                    /Library/LaunchDaemons/com.norton*
#                    {each user's home directory}/Library/Caches/com.norton*
#                 The following removal were added in version 5.59, but the version
#                 history erroneously omitted its addition:
#                    /Library/Caches/com.norton*
#          5.61 - Removed CurrentUserTempFile/ProcessArgumentsCalled.
#          5.62 - Modified for case-sensitive volume compatibility.
#                 Now removes (based on NIS 5.0 builds 8-12 boms):
#                    /Library/Application Support/Symantec/ErrorReporting
#                    /Library/PrivateFrameworks/SymLicensing.framework
#                    /Library/Receipts/NAV_App*
#                    /Library/Receipts/NAV_AutoProtect*
#                    /Library/Receipts/NortonFirewall*
#                    /Library/Receipts/NortonInternetSecurity*
#                    /Library/Receipts/NortonQuickMenu*
#                    /Library/Receipts/SymantecSharedComponents*
#                    /Library/Receipts/SymantecUninstaller*
#                    /Library/Receipts/SymConfidential*
#                    /Library/Receipts/SymDaemon*
#                    /Library/Receipts/SymErrorReporting.pkg
#                    /Library/Receipts/SymFileSecurity*
#                    /Library/Receipts/SymFirewall*
#                    /Library/Receipts/SymIntrusionPrevention*
#                    /Library/Receipts/SymNCOApplication*
#                    /Library/Receipts/SymPersonalFirewallCore*
#                    /Library/Receipts/SymPersonalFirewallUI*
#                    /Library/Receipts/SymPseudoLicensing*
#                    /Library/Receipts/SymSetupAssistant*
#                    /Library/Receipts/SymSharedFrameworks*
#                    /Library/Receipts/SymSharedSettings*
#                    /Library/Receipts/SymUIAgent*
#                    /Library/Receipts/SymWebFraud*
#                    /Library/Services/SymSafeWeb.service
#                    /usr/bin/MigrateQTF
#          5.63 - Now removes:
#                 /usr/local/lib/libecomlodr.dylib
#          5.64 - Updated DeleteCrontabEntries to delete entries from both
#                 OS 10.4 and OS 10.5 crontab directories.
#          5.65 - Updated for NAV 12/NIS 5.
#          5.66 - Added check for launch location to suppress screen clearing, prompts,
#                 and quit message ("NOTE: If you double-clicked this script, quit Terminal
#                 application now.") when running from within app bundle or in support folder.
#                 Now removes:
#                    /Library/Receipts/SymLicensing*
#          5.67 - Fixed "[: too many arguments" error.
#          5.68 - Now removes in all versions:
#                    /Library/Application Support/Symantec/Daemon/timer
#                    /Library/Application Support/Symantec/Licensing
#          5.69 - Now removes:
#                    /Preferences/ByHost/com.symantec*
#                    {each user's home directory}/Preferences/ByHost/com.symantec*
#          5.70 - Now removes:
#                    /Library/Application Support/Symantec/Daemon/timer.log
#          6.0.0 - 09/01/2011:
#                  Now designates when Symantec Uninstaller.app should not
#                  remove an item when using the -l or -R options.
#                  The -l and -R options are now equivalent.
#          6.0.1 - 09/11/2011:
#                  Updated file list.
#          6.0.2 - 09/16/2011:
#                  Updated file list.
#          6.0.3 - 10/07/2011:
#                  Now removes:
#                     /Library/Application Support/nav_postuninstall.rb
#                     /Library/Application Support/nsm_postuninstall.rb
#                     /Library/Application Support/o2spy.log
#                     /Library/Application Support/Symantec/NortonM
#                     /Library/PrivateFrameworks/PlausibleDatabase.framework
#                     /Library/PrivateFrameworks/SymOxygen.framework
#          6.0.4 - 11/08/2011:
#                  Now removes:
#                     /Library/Application Support/nav_uninstalldashboard*
#                     /Library/Application Support/symantec_uninstalldashboard*
#          6.0.5 - 11/17/2011:
#                  Now removes:
#                     /Library/Application Support/Symantec/SymSAQuickMenu
#          6.0.6 - 12/06/2011:
#                  Now removes:
#                     /Library/PrivilegedHelperTools/NATRemoteLock.app
#                     /Library/Receipts/NATRemoteLock.pkg
#                     /Library/Receipts/NATSDPlugin.pkg
#                     /Library/Receipts/nortonantitheftPostflight.pkg
#                     /Library/Receipts/PredeleteTool.pkg
#                     /Library/Receipts/SymOxygen.pkg
#                     /usr/lib/libwpsapi.dylib
#          6.0.7 - 12/14/2011:
#                  Now removes:
#                     /Library/Receipts/nortonanti-theftPostflight.pkg
#                     /private/var/db/NATSqlDatabase.db
#          6.0.8 - 02/28/2012:
#                  Now removes:
#                     /private/tmp/com.symantec.liveupdate.reboot
#          6.0.9 - 03/30/2012:
#                  Now removes:
#                    /private/var/db/receipts/com.Symantec*
#          6.0.10 - 06/19/2012 - Corey Swertfager:
#                   Now removes:
#                      /Applications/Norton Zone*
#                      /Library/Application Support/nav_uninstalldashboard*
#                      /Library/Application Support/symantec_uninstalldashboard*
#                      /Library/Caches/com.apple.Safari/Extensions/Norton*
#                      /Library/Caches/com.apple.Safari/Extensions/Symantec*
#                      /Library/Internet Plug-Ins/NortonSafetyMinderBF.plugin
#                      /Library/Preferences/Norton Zone
#                      /Library/Receipts/ZoneStandalone.pkg
#                      {each user's home directory}/Library/Caches/com.apple.Safari/Extensions/Norton*
#                      {each user's home directory}/Library/Caches/com.apple.Safari/Extensions/Symantec*
#                      {each user's home directory}/Library/Preferences/Norton Zone
#                   Now actually removes (added missing quotes to RemoveItem calls):
#                      /Library/Application Support/nav_uninstalldashboard*
#                      /Library/Application Support/symantec_uninstalldashboard*
#          6.0.11 - 06/19/2012 - Corey Swertfager:
#                   Now removes:
#                      /Library/Application Support/NortonZone
#                      {each user's home directory}/Library/Application Support/NortonZone
#          6.0.12 - 07/06/2012 - Corey Swertfager:
#                   * Modified grep calls with regular expressions that contain pattern "$\|"
#                     to instead use extended regular expression "$|" for OS 10.8 compatibility,
#                     fixing the problem of predelete scripts not being run on OS 10.8.
#                   * Now removes:
#                        /usr/local/bin/KeyGenerator
#          6.0.13 - 08/03/2012 - Corey Swertfager:
#                   * Now removes:
#                        /Library/Application Support/Symantec/Mexico
#                        /Library/Frameworks/mach_inject_bundle.framework
#          6.0.14 - 08/27/2012 - Corey Swertfager:
#                   * Now removes Norton Zone saved sessions.
#          6.0.15 - 08/31/2012 - Corey Swertfager:
#                   * Removed logic that attempted to remove:
#                        {each user's home directory}/Library/Norton Zone
#          6.0.16 - 10/08/2012 - Corey Swertfager:
#                   * Now removes:
#                        {each user's home directory}/Library/Application Support/Symantec
#                        /Library/Internet Plug-Ins/NortonInternetSecurityBF.plugin
#                   * Now makes a second attempt to remove:
#                        /Library/Application Support/Symantec/ErrorReporting
#                        /Library/Application Support/Symantec [deleted if empty]
#          6.0.17 - 10/11/2012 - Corey Swertfager:
#                   Now removes:
#                      /Library/Application Support/Symantec/NisLaunch
#          6.0.18 - 10/19/2012 - Corey Swertfager:
#                   Now removes:
#                        {each user's home directory}/Library/Safari/Extensions/NortonSafetyMinderBF*
#          6.0.19 - 03/12/2013 - Corey Swertfager:
#                   * Now removes:
#                        /Library/Application Support/Symantec/Daemon [deleted whether empty or not]
#                        /Library/PrivilegedHelperTools/com.symantec*
#                   * Added KillNortonZone function.
#                   * Added watermark ID.
#          6.0.20 - 03/15/2013 - Corey Swertfager:
#                   * Now removes Norton Zone from loginwindow.plist files.
#                   * Revamped DeleteSymantecLoginItems function to account
#                     for varying key values.
#                   * KillNortonZone function now only runs killall Finder
#                     if Norton Zone process was killed.
#          6.0.21 - 04/26/2013 - Corey Swertfager:
#                   * Now removes:
#                        /Library/Application Support/Symantec/Silo
#                        /usr/local/bin/MigrateQTF
#                        /usr/local/bin [deleted if empty]
#          6.0.22 - 05/10/2013 - Corey Swertfager:
#                   * Now removes:
#                        /var/log/luxtool.log*

# *** Variable Initializations ***

PATH=/bin:/sbin:/usr/bin:/usr/sbin
AbbreviatedScriptName=`basename "$0" .command`
AutoRunScript=true
AutoRunScript=false
BootVolumeWillBeSearched=false
CreateFilesRemovedListOnly=false
DoRunPredeleteScripts=true
CurrentVolumeBeingUsed="/"
FilesRemovedList="/private/tmp/${AbbreviatedScriptName}RemovesThese.txt"
FilesRemovedFilesOnlyList="/private/tmp/${AbbreviatedScriptName}RemovesThese-FilesOnly.txt"
FilesRemovedListOfOld="/Users/Shared/${AbbreviatedScriptName}RemovesThese.txt"
FilesWereSaved=false
FinishedExitCode=0
FullScriptName=`basename "$0"`
LANG=""
LaunchLocationGrepPattern='/Library/Application Support/Symantec/Uninstaller\|\.app/Contents/Resources'
ListOnlyFilesThatExist=false
LogFile="/private/tmp/${AbbreviatedScriptName}Log.txt"
LogFileOfOld="/Users/Shared/${AbbreviatedScriptName}Log.txt"
NoFilesToRemove=true
# ----- NotRemovedBySymantecUninstaller BEGIN ------------------------------------------------
#       A list of paths or partial paths that aren't removed by Symantec Uninstaller.app.
#       Add only items that cannot be isolated by the -u option.
NotRemovedBySymantecUninstaller='/Library/LaunchDaemons/com.symantec.nis.uninstall.plist
/Library/Logs/SymantecTestPatchers.log'
# ----- NotRemovedBySymantecUninstaller END --------------------------------------------------
NotRemovedBySymantecUninstallerText=" [should not be removed by Symantec Uninstaller.app]"
NumberOfArgumentsPassedToScript=$#
PauseBeforeRestarting=true
PublicVersion=true
QuitTerminalForcefully=false
QuitTerminalForcefullyForAll=false
QuitWithoutRestarting=false
$AutoRunScript && QuitWithoutRestarting=true
# ----- ReceiptsTable BEGIN ------------------------------------------------
#       (2 fields, tab delimited):
#          Receipt name / Receipt option (-a = delete receipt*, -s = skip run of predelete script)
ReceiptsTable='
# Check to make sure there are no vague receipts that may be used by
#    third party software before releasing to the public.
# This line may need to be removed to avoid deleting third party files:
CompatibilityCheck.pkg
# This line may need to be removed to avoid deleting third party files:
Decomposer.pkg
# This line may need to be removed to avoid deleting third party files:
DeletionTracking.pkg
FileSaver.pkg
LiveUpdate	-a
NATRemoteLock.pkg
NATSDPlugin.pkg
NAVContextualMenu.pkg
NAVcorporate.pkg
NAVDefs.pkg
NAVEngine.pkg
NAVWidget.pkg
navx.pkg
NAV_App	-a
NAV_AutoProtect	-a
NFSCore.pkg
NISLaunch.pkg
Norton AntiVirus Application.pkg
Norton AntiVirus Product Log.rtf
Norton AntiVirus.pkg
Norton AutoProtect.pkg
Norton Disk Editor X.pkg
Norton Internet Security Log.rtf
Norton Personal Firewall 3.0 Log.rtf
Norton Scheduled Scans.pkg
Norton Scheduler.pkg
Norton SystemWorks 3.0 Log.rtf
Norton Utilities 8.0 Log.rtf
nortonanti-theftPostflight.pkg
nortonantitheftPostflight.pkg
NortonAutoProtect.pkg
# Remove all NortonAVDefs receipts
NortonAVDefs	-a
NortonDefragger.pkg
NortonDiskDoctor.pkg
NortonFirewall	-a
NortonInternetSecurity	-a
NortonLauncher.pkg
NortonParentalControl.pkg
NortonPersonalFirewall.pkg
NortonPersonalFirewallMenu.pkg
NortonPrivacyControl.pkg
NortonQuickMenu	-a
NPC Installer Log
NPC.pkg
NSMCore.pkg
NSMCore.Universal.pkg
NSWLaunch.pkg
NUMCompatibilityCheck.pkg
NumDocs.pkg
NUMLaunch.pkg
PredeleteTool.pkg
SavLog.pkg
# This line may need to be removed to avoid deleting third party files:
Scheduled Scans.pkg
# This line may need to be removed to avoid deleting third party files:
Scheduler.pkg
SDProfileEditor.pkg
SMC.pkg
SNAC.pkg
SpeedDisk.pkg
# NAV 9 installs the StuffIt engine if it needs to and creates the
# StuffIt.pkg receipt for it. The following line may need to be removed
# (but should not need to be) to avoid deleting third party files:
StuffIt.pkg
Symantec Alerts.pkg
Symantec AntiVirus.pkg
Symantec AutoProtect Prefs.pkg
Symantec AutoProtect.pkg
Symantec Decomposer.pkg
Symantec Endpoint Protection.pkg
Symantec Scheduled Scans.pkg
Symantec Scheduler.pkg
# Remove all SymantecAVDefs receipts
SymantecAVDefs	-a
SymantecClientFirewall.pkg
SymantecDecomposer.pkg
SymantecDeepSightExtractor.pkg
SymantecParentalControl.pkg
SymantecQuickMenu.pkg
SymantecSAQuickMenu.pkg
SymantecSharedComponents	-a
SymantecUninstaller	-a
SymantecURLs.pkg
SymAV10StuffItInstall.pkg
SymAVScanServer.pkg
SymConfidential	-a
SymConfidentialData.pkg
SymDaemon	-a
SymDC.pkg
SymDiskMountNotify.pkg
SymErrorReporting.pkg
SymEvent.pkg
SymFileSecurity	-a
SymFirewall	-a
SymFS.pkg
SymHelper.pkg
SymHelpScripts.pkg
SymInstallExtras.pkg
SymInternetSecurity.pkg
SymIntrusionPrevention	-a
SymIPS.pkg
SymLicensing	-a
SymNCOApplication	-a
SymOxygen.pkg
SymOSXKernelUtilities.pkg
SymPersonalFirewallCore	-a
SymPersonalFirewallUI	-a
SymProtector.pkg
SymPseudoLicensing	-a
SymSetupAssistant	-a
SymSharedFrameworks	-a
SymSharedSettings	-a
SymStuffit.pkg
SymSubmission.pkg
SymUIAgent	-a
SymWebFraud	-a
SymWebKitUtils.pkg
Unerase.pkg
# This line may need to be removed to avoid deleting third party files:
URL.pkg
VolumeAssist.pkg
VolumeRecover.pkg
WCIDEngine.pkg
Wipe Info.pkg
ZoneStandalone.pkg
'
# ----- ReceiptsTable END --------------------------------------------------
RemoveCrontabEntries=true
RemoveCrontabEntriesOnly=false
RemoveInvisibleFiles=true
RemoveInvisibleFilesOnly=false
RemoveFromAllVolumes=false
RemoveFromOtherVolumes=false
RestartAutomatically=false
RestartMayBeNeeded=false
SavedFilesDir="/private/tmp/${AbbreviatedScriptName}SavedFiles"
ShowFilesAsRemoved=true
ShowPredeleteErrors=false
ShowQuitMessage=true
SomeFileWasRemoved=false
SomeFileWasRemovedFromNonBootVolume=false
SomeFileWasRemovedFromBootVolume=false
UseMore=false

# *** Function Declarations ***

AssignOptions()
{
   # Usage:     AssignOptions $1
   # Argument:  $1 = Option to check.
   # Summary:   Assigns options for script. If $1 is a valid option,
   #            it changes script options accordingly.
   #
   case "$1" in
      -A)
         RemoveFromAllVolumes=true
         BootVolumeWillBeSearched=true
         ;;
      -c)
         RemoveCrontabEntriesOnly=true
         RemoveCrontabEntries=true
         RemoveInvisibleFilesOnly=false
         RemoveInvisibleFiles=false
         ;;
      -C)
         RemoveCrontabEntriesOnly=false
         RemoveCrontabEntries=false
         ;;
      -d)
         DoRunPredeleteScripts=false
         ;;
      -e)
         ShowPredeleteErrors=true
         ;;
      -f)
         ShowFilesAsRemoved=false
         ;;
      -h)
         ShowUsage
         ;;
      -i)
         RemoveInvisibleFilesOnly=true
         RemoveInvisibleFiles=true
         RemoveCrontabEntries=false
         RemoveCrontabEntriesOnly=false
         ;;
      -I)
         RemoveInvisibleFilesOnly=false
         RemoveInvisibleFiles=false
         ;;
      -l|-R)
         CreateFilesRemovedListOnly=true
         ListOnlyFilesThatExist=true
         ;;
      -L)
         CreateFilesRemovedListOnly=true
         ListOnlyFilesThatExist=false
         ;;
      -m)
         UseMore=true
         ;;
      -p)
         PauseBeforeRestarting=false
         ;;
      -q)
         QuitWithoutRestarting=true
         RestartAutomatically=false
         ;;
      -Q)
         QuitTerminalForcefully=true
         QuitTerminalForcefullyForAll=false
         QuitWithoutRestarting=true
         RestartAutomatically=false
         ;;
      -QQ)
         QuitTerminalForcefully=true
         QuitTerminalForcefullyForAll=true
         QuitWithoutRestarting=true
         RestartAutomatically=false
         ;;
      -re)
         RestartAutomatically=true
         QuitWithoutRestarting=false
         ;;
      -V)
         echo $Version
         ExitScript 0
         ;;
      *)
         AssignVolume "$1"   # Assign it to a Volume variable
         # If not a valid volume
         if [ $? = 1 ] ; then
            echo
            echo "ERROR: Invalid option or volume name: \"$1\"."
            ShowUsageHelp 4
         fi
         RemoveFromOtherVolumes=true
         ;;
   esac
}

AssignVolume()
{
   # Usage:     AssignVolume $1
   # Argument:  $1 = Volume name. The name can begin with "/Volumes/"
   #                 unless it is "/" (boot volume).
   # Summary:   Assigns the name of the volume passed as $1 to VolumesToUse.
   #            If volume is assigned, 0 is returned; else, 1 is returned.
   #
   # If nothing passed, skip assignment
   [ -z "$1" ] && return 1
   VolumeToAssign=`CheckIfValidVolume "$1"`
   if [ -z "$VolumeToAssign" ] ; then
      VolumeToAssign=`CheckIfValidVolume "/Volumes/$1"`
      [ -z "$VolumeToAssign" ] && return 1
   fi
   [ "$VolumeToAssign" = "/" ] && BootVolumeWillBeSearched=true
   VolumesToUse="$VolumesToUse
$VolumeToAssign"
   return 0
}

CheckIfValidVolume()
{
   # Usage:     CheckIfValidVolume $1
   # Argument:  $1 = Volume name to check.
   # Summary:   If $1 is a valid volume name, it is echoed;
   #            else, "" is echoed.
   #
   VVolume=""
   # If something passed
   if [ -n "$1" ] ; then
      # If it is a directory and not a link
      if [ -d "$1" -a ! -L "$1" ] ; then
         InitCurrentDir=`pwd` # Save initial directory location
         cd "$1"
         if [ "`pwd`" = "/" -o "`pwd`" = "//" ] ; then
            VVolume=/
         else
            cd ..
            ParentDir=`pwd`
            # If there is an extra / at beginning of path, remove it
            [ "`echo "z$ParentDir" | awk '{print substr($0,2,2)}'`" = "//" ] && ParentDir=`echo "z$ParentDir" | awk '{print substr($0,3)}'`
            # If $1 is a volume, assign it to VVolume
            [ "$ParentDir" = "/Volumes" ] && VVolume="$ParentDir/`basename "$1"`"
         fi
         cd "$InitCurrentDir"  # Return to initial directory
      fi
   fi
   echo "$VVolume"
}

DeleteCrontabEntries()
{
   # Usage:     DeleteCrontabEntries [$1]
   # Argument:  $1 = Volume name. The name should begin with "/Volumes/"
   #                 unless it is "/" (boot volume). If NULL, then / is
   #                 used as volume name.
   # Authors:   John Hansen, Corey Swertfager
   # Summary:   Deletes from / or volume specified the crontab entries
   #            created by Norton Scheduler and Symantec Scheduler.
   # Note:      User must be root when calling this function.
   #
   if [ "z$1" = z/ ] ; then
      VolumeToDeleteCrontabsFrom=""
   else
      VolumeToDeleteCrontabsFrom="$1"
   fi
   CRONDIRNEW="$VolumeToDeleteCrontabsFrom/private/var/at/tabs"   # OS 10.5 and later crontab directory
   CRONDIROLD="$VolumeToDeleteCrontabsFrom/private/var/cron/tabs"   # OS 10.4 and earlier crontab directory
   if [ ! -d "$CRONDIRNEW" -a ! -d "$CRONDIROLD" ] ; then
      if $CreateFilesRemovedListOnly ; then
         if [ -z "$VolumeToDeleteCrontabsFrom" ] ; then
            echo "No crontab directory was found on on the current boot volume." >> "$FilesRemovedList"
         else
            echo "No crontab directory was found on on the volume \"`basename "$VolumeToDeleteCrontabsFrom"`\"." >> "$FilesRemovedList"
         fi
         echo "" >> "$FilesRemovedList"
      else
         if [ -z "$VolumeToDeleteCrontabsFrom" ] ; then
            echo "No crontab directory was found on on the current boot volume."
         else
            echo "No crontab directory was found on on the volume \"`basename "$VolumeToDeleteCrontabsFrom"`\"."
         fi
      fi
      return 1
   fi
   TEMPFILETEMPLATE="/private/tmp/NortonTemp"
   GREP1="^#SqzS"
   GREP2="^#SYMANTEC SCHEDULER CRON ENTRIES"
   GREP3="^#PLEASE DO NOT EDIT\.$"
   GREP4="EvType1=.*EvType2=.*Sched="
   GREP5="Norton Solutions Support/Scheduler/schedLauncher"
   GREP6="Symantec/Scheduler/SymSecondaryLaunch.app/Contents/schedLauncher"
   SymantecCrontabEntryExists=false
   CurrentDir="`pwd`"	# Save initial directory location
   # Set IFS to only newline to get all crontabs
   IFS='
'
   for CRONDIR in `ls -d "$CRONDIRNEW" "$CRONDIROLD" 2>/dev/null` ; do
      cd "$CRONDIR"
      # List each crontab, pipe through grep command and replace
      for user in `ls * 2>/dev/null` ; do
         # If not root and not a valid user, skip
         [ "z$user" != "zroot" -a ! -d "$VolumeToDeleteCrontabsFrom/Users/$user" ] && continue
         # If deleting from boot volume
         if [ -z "$VolumeToDeleteCrontabsFrom" ] ; then
            # Check to see if there is a Symantec crontab entry
            if [ "`crontab -u "$user" -l | grep -c "$GREP1\|$GREP2\|$GREP3\|$GREP4\|$GREP5\|$GREP6"`" != 0 ] ; then
               SymantecCrontabEntryExists=true
            else
               continue   # Nothing to remove, skip user
            fi
            $CreateFilesRemovedListOnly && break
            TEMPFILE="$TEMPFILETEMPLATE`date +"%Y%m%d%H%M%S"`"
            crontab -u "$user" -l | grep -v "$GREP1\|$GREP2\|$GREP3\|$GREP4\|$GREP5\|$GREP6" > $TEMPFILE
            # Restore crontab file if it has more entries, else remove
            if [ -s "$TEMPFILE" ] ; then
               crontab -u "$user" $TEMPFILE
            else
               echo "y" | crontab -u "$user" -r
            fi
         else
            # Check to see if there is a Symantec crontab entry
            if [ "`grep -c "$GREP1\|$GREP2\|$GREP3\|$GREP4\|$GREP5\|$GREP6" "$user"`" != 0 ] ; then
               SymantecCrontabEntryExists=true
            else
               continue   # Nothing to remove, skip user
            fi
            $CreateFilesRemovedListOnly && break
            TEMPFILE="$TEMPFILETEMPLATE`date +"%Y%m%d%H%M%S"`"
            grep -v "$GREP1\|$GREP2\|$GREP3\|$GREP4\|$GREP5\|$GREP6" "$user" > $TEMPFILE
            # Restore crontab file if it has more entries, else remove
            if [ -s "$TEMPFILE" ] ; then
               cat $TEMPFILE >"$user"
            else
               rm -f "$user" 2>/dev/null
            fi
         fi
         /bin/rm "$TEMPFILE" 2>/dev/null
      done
      [ $CreateFilesRemovedListOnly = true -a $SymantecCrontabEntryExists = true ] && break
   done
   cd "$CurrentDir"	# Return to intial directory
   if $SymantecCrontabEntryExists ; then
      if $CreateFilesRemovedListOnly ; then
         if [ -z "$VolumeToDeleteCrontabsFrom" ] ; then
            echo "Symantec crontab entries would be deleted from the current boot volume." >> "$FilesRemovedList"
         else
            echo "Symantec crontab entries would be deleted from the volume" >> "$FilesRemovedList"
            echo "\"`basename "$VolumeToDeleteCrontabsFrom"`\"." >> "$FilesRemovedList"
         fi
         echo "" >> "$FilesRemovedList"
      else
         if [ -z "$VolumeToDeleteCrontabsFrom" ] ; then
            echo "Symantec crontab entries were deleted from the current boot volume."
         else
            echo "Symantec crontab entries were deleted from the volume"
            echo "\"`basename "$VolumeToDeleteCrontabsFrom"`\"."
         fi
      fi
      NoFilesToRemove=false
   else
      if $CreateFilesRemovedListOnly ; then
         if [ -z "$VolumeToDeleteCrontabsFrom" ] ; then
            echo "There are no Symantec crontab entries on the current boot volume;" >> "$FilesRemovedList"
            echo "no crontab entries would be removed from it." >> "$FilesRemovedList"
         else
            echo "There are no Symantec crontab entries on the volume \"`basename "$VolumeToDeleteCrontabsFrom"`\";" >> "$FilesRemovedList"
            echo "no crontabs would be adjusted on that volume." >> "$FilesRemovedList"
         fi
         echo "" >> "$FilesRemovedList"
      elif [ -z "$VolumeToDeleteCrontabsFrom" ] ; then
         echo "There are no Symantec crontab entries to delete from the current boot volume."
      else
         echo "There are no Symantec crontab entries to delete from the volume"
         echo "\"`basename "$VolumeToDeleteCrontabsFrom"`\"."
      fi
   fi
   return 0
}

DeleteLaunchdPlists()
{
   # Usage:     DeleteLaunchdPlists [$1]
   # Argument:  $1 = Volume name. The name should begin with "/Volumes/"
   #                 unless it is "/" (boot volume). If NULL, then / is
   #                 used as volume name.
   # Summary:   Deletes from / or volume specified the launchd plists
   #            created by Symantec Scheduler.
   # Note:      User must be root when calling this function.
   #
   if [ "z$1" = z/ ] ; then
      VolumeToDeleteLaunchdPlistsFrom=""
   else
      VolumeToDeleteLaunchdPlistsFrom="$1"
   fi
   LaunchdPlists=`ls -d "$VolumeToDeleteLaunchdPlistsFrom/Library/LaunchDaemons/com.symantec.Sched"*.plist 2>/dev/null`
   if [ "$LaunchdPlists" ] ; then
      if $CreateFilesRemovedListOnly ; then
         if [ -z "$VolumeToDeleteLaunchdPlistsFrom" ] ; then
            echo "Symantec Scheduler launchd plists would be deleted from the current boot volume." >> "$FilesRemovedList"
         else
            echo "Symantec Scheduler launchd plists would be deleted from the volume" >> "$FilesRemovedList"
            echo "\"`basename "$VolumeToDeleteLaunchdPlistsFrom"`\"." >> "$FilesRemovedList"
         fi
         echo "" >> "$FilesRemovedList"
      else
         IFS='
'
         for EachPlist in $LaunchdPlists ; do
            rm -f "$EachPlist" 2>/dev/null
         done
         if [ -z "$VolumeToDeleteLaunchdPlistsFrom" ] ; then
            echo "Symantec Scheduler launchd plists were deleted from the current boot volume."
         else
            echo "Symantec Scheduler launchd plists were deleted from the volume"
            echo "\"`basename "$VolumeToDeleteLaunchdPlistsFrom"`\"."
         fi
      fi
      NoFilesToRemove=false
   else
      if $CreateFilesRemovedListOnly ; then
         if [ -z "$VolumeToDeleteLaunchdPlistsFrom" ] ; then
            echo "There are no Symantec Scheduler launchd plists on the current boot volume," >> "$FilesRemovedList"
            echo "so none would be removed from it." >> "$FilesRemovedList"
         else
            echo "There are no Symantec Scheduler launchd plists on the volume" >> "$FilesRemovedList"
            echo "\"`basename "$VolumeToDeleteLaunchdPlistsFrom"`\", so none would be removed from it." >> "$FilesRemovedList"
         fi
         echo "" >> "$FilesRemovedList"
      elif [ -z "$VolumeToDeleteLaunchdPlistsFrom" ] ; then
         echo "There are no Symantec Scheduler launchd plists to delete from the current boot"
         echo "volume."
      else
         echo "There are no Symantec Scheduler launchd plists to delete from the volume"
         echo "\"`basename "$VolumeToDeleteLaunchdPlistsFrom"`\"."
      fi
   fi
   return 0
}

DeleteSymantecLoginItems()
{
   # Usage:     DeleteSymantecLoginItems [$1]
   # Argument:  $1 = Name of volume from which to remove login items.
   #                 The name must begin with "/Volumes/" unless it is
   #                 "/" (boot volume). If nothing is passed, / is assumed.
   # Summary:   Deletes Symantec items from all loginwindow.plist files on
   #            volume specified.
   # Note:      If this function is run while booted in OS 10.1.x, it will
   #            not be able to adjust loginwindow.plist files on an OS 10.4.x
   #            volume because plutil did not ship with basic OS 10.1.x.
   #            Boolean CreateFilesRemovedListOnly must be defined before
   #            running this function.
   #
   local Buffer
   local Line
   local TARGETVOLUME="$1"
   [ "z$1" = z/ ] && TARGETVOLUME=""
   TEMPFILETEMPLATE=/private/tmp/DeleteSymantecLoginItems
   OUTFILE=${TEMPFILETEMPLATE}`date +"%Y%m%d%H%M%S"`-1
   SOURCEFILE=${TEMPFILETEMPLATE}`date +"%Y%m%d%H%M%S"`-2
   GREPSTR="/Library/Application Support/Symantec\|/Library/Application Support/Norton Solutions\|/Library/Application Support/Symnatec/Scheduler/SymSecondaryLaunch.app\|/Library/StartupItems/Norton\|/Norton Zone.app"
   FileShouldBeAdjusted=false
   IFS='
'
   for EachUser in `ls "$TARGETVOLUME/Users" 2>/dev/null` "root" "/" ; do
      if [ "z$EachUser" = z/ ] ; then
         ORIGFILE="$TARGETVOLUME/Library/Preferences/loginwindow.plist"
      elif [ "z$EachUser" = zroot ] ; then
         ORIGFILE="$TARGETVOLUME/private/var/root/Library/Preferences/loginwindow.plist"
      else
         ORIGFILE="$TARGETVOLUME/Users/$EachUser/Library/Preferences/loginwindow.plist"
      fi
      [ ! -f "$ORIGFILE" ] && continue
      rm -rf $SOURCEFILE 2>/dev/null
      cp "$ORIGFILE" $SOURCEFILE
      CheckSyntax=true
      plutil -convert xml1 $SOURCEFILE 2>/dev/null
      # If plutil failed to convert the plist, don't check syntax later
      [ $? != 0 ] && CheckSyntax=false
      IsBinaryFormat=false
      # If original plist is different than converted plist, treat it as a binary file
      [ -n "`diff "$ORIGFILE" $SOURCEFILE 2>/dev/null`" ] && IsBinaryFormat=true
      # If some Symantec login item(s) found
      if [ "`grep "$GREPSTR" $SOURCEFILE`" ] ; then
         printf "" > $OUTFILE
         FileShouldBeAdjusted=true
         if $CreateFilesRemovedListOnly ; then
            echo "Symantec login items would be removed from:" >>"$FilesRemovedList"
            echo "   \"$ORIGFILE\"" >>"$FilesRemovedList"
         else
            # Purge Symantec login item(s)
            Buffer=""
            DoWriteBuffer=true
            for Line in `cat $SOURCEFILE` ; do
               # If beginning of a dictionary key
               if [ "`printf "%s" "$Line" | grep '<dict>$'`" ] ; then
                  [ "$Buffer" ] && echo "$Buffer" >> $OUTFILE
                  Buffer="$Line"
                  DoWriteBuffer=true
               else
                  if [ "$Buffer" ] ; then
                     Buffer="$Buffer
$Line"
                  else
                     Buffer="$Line"
                  fi
                  # If end of a dictionary key
                  if [ "`printf "%s" "$Line" | grep '</dict>$'`" ] ; then
                     $DoWriteBuffer && echo "$Buffer" >> $OUTFILE
                     Buffer=""
                     DoWriteBuffer=true
                  # Else if Symantec path was found
                  elif [ "`printf "%s" "$Line" | grep "$GREPSTR"`" ] ; then
                     DoWriteBuffer=false
                  fi
               fi
            done
            [ "$Buffer" ] && echo "$Buffer" >> $OUTFILE
            # If some login item information is missing
            if [ `grep -c '<dict>$' $OUTFILE` != `grep -c '</dict>$' $OUTFILE` ] ; then
               echo "ERROR: Could not remove Symantec login items from:"
               echo "       $ORIGFILE"
            # Else if syntax is to be checked and plist contains bad syntax
            elif [ $CheckSyntax = true -a -n "`plutil -s $OUTFILE 2>/dev/null`" ] ; then
               echo "ERROR: Could not remove Symantec login items from:"
               echo "       $ORIGFILE"
            else
               echo "Removing Symantec login items from:"
               echo "   \"$ORIGFILE\""
               cat $OUTFILE > "$ORIGFILE"
               $IsBinaryFormat && plutil -convert binary1 "$ORIGFILE" 2>/dev/null
            fi
         fi
      fi
   done
   rm -f $OUTFILE $SOURCEFILE 2>/dev/null
   $FileShouldBeAdjusted && echo "" >>"$FilesRemovedList"
}

DetermineAction()
{
   # Usage:     DetermineAction
   # Summary:   Determines which action to take based on user input.
   #
   clear
   echo
   ShowVersion
   echo "
WARNING: This script will remove all files and folders created by Symantec
         OS X products (except Symantec Adminstration Console for Macintosh
         files) and any files within those folders. Therefore, you will
         lose ALL files that reside in those folders, including any that
         you have created.
"
   echo "1 - Remove all Symantec files/folders."
   echo
   echo "2 - Quit. Do not remove any files."
   echo
   printf "Enter choice (1 or 2): "
   read choice
   echo
   case "`echo "z$choice" | awk '{print tolower(substr($0,2))}'`" in
      1)   # Remove files
         CreateFilesRemovedListOnly=false
         ;;
      2|q|quit)   # Quit
         echo "Program cancelled. No files were removed."
         ExitScript 0
         ;;
      *)   # Show choices again
         DetermineAction
         ;;
   esac
}

ExitScript()
{
   # Usage:     ExitScript [$1]
   # Argument:  $1 = The value to pass when calling the exit command.
   # Summary:   Checks to see if ShowQuitMessage and RunScriptAsStandAlone
   #            variables are set to true. If so, a message is displayed;
   #            otherwise, no message is displayed. The script is then
   #            exited and passes $1 to exit command. If nothing is passed
   #            to $1, then 0 is passed to exit command. If a non-integer
   #            is passed to $1, then 255 is passed to exit command.
   #
   rm -f "$FilesRemovedList" "$FilesRemovedFilesOnlyList" "$LogFile" 2>/dev/null 1>&2
   if $QuitTerminalForcefully ; then
      KillTerminal
   elif [ $ShowQuitMessage = true -a $RunScriptAsStandAlone = true ] ; then
      echo
      echo "NOTE: If you double-clicked this script, quit Terminal application now."
      echo
   fi
   [ -z "$1" ] && exit 0
   [ -z "`expr "$1" / 1 2>/dev/null`" ] && exit 255
   exit $1
}

FinishCleanup()
{
   # Usage:     FinishCleanup
   # Summary:   Displays then deletes the file named by LogFile, a log
   #            of files not removed by RemoveItem function, if ErrorOccurred
   #            is true. If NoFilesToRemove is true, a message is shown
   #            and the function is exited. If RemoveInvisibleFilesOnly
   #            is true, a message is shown and the function is exited;
   #            otherwise, a message is shown. Returns 2 if ErrorOccurred
   #            is true, 0 otherwise.
   #
   if $CreateFilesRemovedListOnly ; then
      clear >&2
      if $UseMore ; then
         ShowContents "$FilesRemovedList"
      else
         cat "$FilesRemovedList"
      fi
      echo ""  >&2
      echo "NOTE: No files have been removed."  >&2
      echo ""  >&2
      /bin/rm -rf "$FilesRemovedList" "$FilesRemovedFilesOnlyList" 2>/dev/null 1>&2
      return 0
   elif $ErrorOccurred ; then
      echo
      # Display LogFile
      ShowContents "$LogFile"
      # Remove LogFile
      /bin/rm -rf "$LogFile" 2>/dev/null 1>&2
      echo
      if $RemoveInvisibleFilesOnly ; then
         echo "NOTE: Not all of the invisible Symantec files were removed."
         echo "      Make sure each volume passed is unlocked and accessible."
         return 2
      else
         echo "NOTE: Not all folders/files were removed."
         echo "      Perhaps a file or folder listed above is in use or a folder"
         echo "      listed above is not empty."
         if $RestartMayBeNeeded ; then
            echo
            echo "Some Symantec product files have been removed from the boot volume."
            return 2
         else
            if $SomeFileWasRemoved ; then
               echo
               echo "Some folders or files have been removed."
            fi
            return 2
         fi
      fi
   fi
   if $RemoveInvisibleFilesOnly ; then
      if $NoFilesToRemove ; then
         echo "There were no invisible Symantec files to be removed."
      else
         echo "AntiVirus QuickScan and/or Norton FS files have been removed."
      fi
      return 0
   fi
   if $NoFilesToRemove ; then
      echo "There were no files that needed to be removed. No files were removed."
      return 0
   fi
   $RemoveCrontabEntriesOnly && return 0
   echo
   if $RestartMayBeNeeded ; then
      printf "Symantec product files have been removed from the boot volume"
      if $SomeFileWasRemovedFromNonBootVolume ; then
         echo
         echo "and from other volume(s) listed above."
      else
         echo "."
      fi
   else
      echo "Symantec product files have been removed from the above volume(s)."
   fi
   return 0
}

GetAdminPassword()
{
   # Usage:     GetAdminPassword [$1]
   # Argument:  $1 - Prompt for password. If true is passed, a user that
   #                 is not root will always be asked for a password. If
   #                 something other than true is passed or if nothing is
   #                 passed, then a user that is not root will only be
   #                 prompted for a password if authentication has lapsed.
   # Summary:   Gets an admin user password from the user so that
   #            future sudo commands can be run without a password
   #            prompt. The script is exited with a value of 1 if
   #            the user enters an invalid password or if the user
   #            is not an admin user. If the user is the root user,
   #            then there is no prompt for a password (there is
   #            no need for a password when user is root).
   #            NOTE: Make sure ExitScript function is in the script.
   #
   # If root user, no need to prompt for password
   [ "`whoami`" = "root" ] && return 0
   echo >&2
   # If prompt for password
   if [ "$1" = "true" -o "$1" = "true" ] ; then
      ShowVersion >&2
      echo >&2
      sudo -k >&2   # Make sudo require a password the next time it is run
      echo "You must be an admin user to run this script." >&2
   fi
   # A dummy sudo command to get password
   sudo -p "Please enter your admin password: " date 2>/dev/null 1>&2
   if [ ! $? = 0 ] ; then       # If failed to get password, alert user and exit script
      echo "You entered an invalid password or you are not an admin user. Script aborted." >&2
      ExitScript 1
   fi
}

KillNortonZone()
{
   $CreateFilesRemovedListOnly && return
   ZoneProcesses=`ps -axww | grep "Norton Zone.app/Contents/MacOS/Norton Zone" | grep -v grep | awk '{print $1}'`
   for EachZoneAppPID in $ZoneProcesses ; do
      kill -9 "$EachZoneAppPID"
   done
   [ "$ZoneProcesses" ] && killall Finder
}

KillTerminal()
{
   ProcessLines=`ps -axww | grep -e "/Applications/Utilities/Terminal.app" | grep -v grep | sort -f`
   if [ -z "$ProcessLines" ] ; then
      return
   elif [ `echo "$ProcessLines" | grep . -c` -gt 1 -a $QuitTerminalForcefullyForAll = false ] ; then
      echo "NOTE: Terminal was launched more than once so it could not be quit."
      echo "      Use the -QQ option to force Terminal to be quit for all users."
      return
   else
      echo "WARNING: Quitting Terminal."
   fi
   IFS='
'
   for ProcessLine in $ProcessLines ; do
      ProcessID=`printf "%s" "$ProcessLine" | awk '{print $1}'`
      kill -9 "$ProcessID"
   done
}

RemoveAllNortonFiles()
{
   # Usage:     RemoveAllNortonFiles $1
   # Argument:  $1 = Volume name. The name should begin with "/Volumes/"
   #                 unless it is "/" (boot volume).
   # Summary:   Removes all OS X Norton products' files and folders
   #            from volume named by $1 if RemoveInvisibleFilesOnly
   #            equals false; otherwise, removes only the invisible Norton
   #            files. Removes the invisible Norton files from other
   #            volumes that are passed to the script. Symantec crontab
   #            entries are removed if RemoveCrontabEntries = true.
   #
   # If not a valid volume, return 1
   [ -z "`CheckIfValidVolume "$1"`" ] && return 1
   CurrentVolumeBeingUsed="$1"
   if $CreateFilesRemovedListOnly ; then
      printf "" > "$FilesRemovedFilesOnlyList"
      echo "" >> "$FilesRemovedList"
      if [ `echo "$ListOfVolumesToUse" | grep -c .` -gt 1 ] ; then
         if [ "$1" = / ] ; then
            echo "------ Volume: / (current boot volume) ------" >> "$FilesRemovedList"
         else
            echo "------ Volume: \"`basename "$1"`\" ------" >> "$FilesRemovedList"
         fi
         echo "" >> "$FilesRemovedList"
      fi
   fi
   $RemoveCrontabEntries && DeleteCrontabEntries "$1"
   $RemoveCrontabEntries && DeleteLaunchdPlists "$1"
   $RemoveCrontabEntriesOnly && return 0
   ! $RemoveInvisibleFilesOnly && DeleteSymantecLoginItems "$1"
   RemoveNortonZoneSavedSessions "$CurrentVolumeBeingUsed"
   if $CreateFilesRemovedListOnly ; then
      if ! $RemoveInvisibleFilesOnly ; then
         RunPredeleteScripts "$1"
         echo "" >> "$FilesRemovedList"
      fi
      if $ListOnlyFilesThatExist ; then
         echo "The following files/folders currently exist and would be removed unless" >> "$FilesRemovedList"
         echo "otherwise noted:" >> "$FilesRemovedList"
      else
         echo "$FullScriptName would attempt to find and remove the following:" >> "$FilesRemovedList"
      fi
      echo "" >> "$FilesRemovedList"
   fi
   RemoveInvisibleFilesFromVolume "$1"
   $RemoveInvisibleFilesOnly && return 0
   $CreateFilesRemovedListOnly || RunPredeleteScripts "$1"
   # If not an OS X volume, return 1
   [ ! -d "$1/Library/Application Support" ] && return 1
   if $CreateFilesRemovedListOnly ; then
      echo "Finding visible Symantec files on:   $1" >&2
   elif $ShowFilesAsRemoved ; then
      echo "Locating visible Symantec files in:   $1"
   else
      echo "Removing visible Symantec files from:   $1"
   fi
   cd "$1"
   if [ "`pwd`" = "/" ] ; then
      VolumePrefix=""
   else
      VolumePrefix="`pwd`"
   fi
   KillNortonZone
   RemoveItem "/.com_symantec_symfs_private"
   RemoveItem "/.symSchedScanLockxz"
   RemoveItem "/Applications/Firefox.app/Contents/MacOS/extensions/{0e10f3d7-07f6-4f12-97b9-9b27e07139a5}"
   RemoveItem "/Applications/Firefox.app/Contents/MacOS/extensions/{29dd9c80-9ea1-4aaf-9305-a0314aba24e3}"
   RemoveItem "/Applications/Firefox.app/Contents/MacOS/extensions/nortonsafetyminder@symantec.com"
   RemoveItem "/Applications/Late Breaking News"
   RemoveItem "/Applications/LiveUpdate"
   RemoveItem "/Applications/LiveUpdate Folder"
   RemoveItem "/Applications/LiveUpdate Folder (OS X)"
#  Remove navx incorrectly installed by NAV 800.007 installer:
   RemoveItem "/Applications/navx"
   RemoveItem "/Applications/Norton AntiVirus"
   RemoveItem "/Applications/Norton AntiVirus (OS X)"
   RemoveItem "/Applications/Norton AntiVirus.app"
   RemoveItem "/Applications/Norton Confidential.app"
   RemoveItem "/Applications/Norton DNS Beta.app"
   RemoveItem "/Applications/Norton DNS.app"
   RemoveItem "/Applications/Norton Internet Security"
   RemoveItem "/Applications/Norton Internet Security.app"
   RemoveItem "/Applications/Norton Internet Security.NisX"
   RemoveItem "/Applications/Norton Internet Security (OS X)"
   RemoveItem "/Applications/Norton Parental Control"
   RemoveItem "/Applications/Norton Parental Control.app"
   RemoveItem "/Applications/Norton Personal Firewall"
   RemoveItem "/Applications/Norton Personal Firewall.app"
   RemoveItem "/Applications/Norton Personal Firewall (OS X)"
   RemoveItem "/Applications/Norton Scheduler (OS X)"
   RemoveItem "/Applications/Norton Solutions"
   RemoveItem "/Applications/Norton System Works"
   RemoveItem "/Applications/Norton SystemWorks"
   RemoveItem "/Applications/Norton SystemWorks.NswX"
   RemoveItem "/Applications/Norton Utilities"
   RemoveItem "/Applications/Norton Utilities Folder (OS X)"
   RemoveItem "/Applications/Norton Utilities.NnuX"
   RemoveItem "/Applications/Norton Zone" "*"
   RemoveItem "/Applications/Symantec AntiVirus"
   RemoveItem "/Applications/Symantec Solutions"
#  The next 3 items are erroneously created by early builds of NAV 10 installer
   RemoveItem "/Applications/Symantec/LiveUpdate.app"
   RemoveItem "/Applications/Symantec/Read Me Files"
   RemoveItem "/Applications/Symantec" -e
   RemoveItem "/Applications/Trash Running Daemons"
   RemoveItem "/Applications/uDelete Preferences"
   RemoveItem "/Applications/Register Your Software"
#  Folder erroneously created by NPF 300.001 - removed if empty:
   RemoveItem "/Firewall" -e -u
   RemoveItem "/Library/Application Support/NAVDiagnostic.log"
   RemoveItem "/Library/Application Support/NAV.history"
   RemoveItem "/Library/Application Support/nav_uninstalldashboard" "*"
   RemoveItem "/Library/Application Support/nav_postuninstall.rb" -u
   RemoveItem "/Library/Application Support/nis_postuninstall.rb" -u
   RemoveItem "/Library/Application Support/nis_postuninstall.sh" -u
   RemoveItem "/Library/Application Support/nsm_postuninstall.rb" -u
   RemoveItem "/Library/Application Support/Norton Application Aliases"
#  Remove "/Library/Application Support/Norton Solutions Support" if necessary
   if [ -e "$VolumePrefix/Library/Application Support/Norton Solutions Support" ] ; then
      # if Norton Solutions Support contains something other than "LiveUpdate/Registry/LUsm "*
      #    or it does not contain "LiveUpdate/Registry/LUsm "*
      if [ "`ls -d "$VolumePrefix/Library/Application Support/Norton Solutions Support/"* 2>/dev/null | grep -v "^\.DS_Store\|^\.localized"`" != \
                   "$VolumePrefix/Library/Application Support/Norton Solutions Support/LiveUpdate" -o \
           "`ls -d "$VolumePrefix/Library/Application Support/Norton Solutions Support/LiveUpdate/"* 2>/dev/null | grep -v "^\.DS_Store\|^\.localized"`" != \
                   "$VolumePrefix/Library/Application Support/Norton Solutions Support/LiveUpdate/Registry" -o \
           "z`ls -d "$VolumePrefix/Library/Application Support/Norton Solutions Support/LiveUpdate/Registry/"* 2>/dev/null | grep -v "^\.DS_Store\|^\.localized" | grep -v "LUsm "`" != z -o \
           -z "`ls -d "$VolumePrefix/Library/Application Support/Norton Solutions Support/LiveUpdate/Registry/LUsm "* 2>/dev/null`" ] ; then
         SaveFiles
         RemoveItem "/Library/Application Support/Norton Solutions Support"
         RestoreSaved
      fi
   fi
   RemoveItem "/Library/Application Support/o2spy.log"
   RemoveItem "/Library/Application Support/Symantec/AntiVirus"
   RemoveItem "/Library/Application Support/Symantec/AntiVirus.kextcache"
   RemoveItem "/Library/Application Support/Symantec/Application Aliases"
   RemoveItem "/Library/Application Support/Symantec/Assistants/Client Firewall"
   RemoveItem "/Library/Application Support/Symantec/Assistants/NIS Assistant Startup.app"
   RemoveItem "/Library/Application Support/Symantec/Assistants/Norton Confidential"
   RemoveItem "/Library/Application Support/Symantec/Assistants/Norton Confidential Startup.app"
   RemoveItem "/Library/Application Support/Symantec/Assistants/Norton Firewall"
   RemoveItem "/Library/Application Support/Symantec/Assistants/Norton Internet Security"
   RemoveItem "/Library/Application Support/Symantec/Assistants/NPF Assistant Startup.app"
   RemoveItem "/Library/Application Support/Symantec/Assistants/SCF Assistant Startup.app"
   RemoveItem "/Library/Application Support/Symantec/Assistants/Symantec Setup Assistant.app"
   RemoveItem "/Library/Application Support/Symantec/Assistants/Symantec Setup Assistant.bundle"
   RemoveItem "/Library/Application Support/Symantec/Assistants" -e
   RemoveItem "/Library/Application Support/Symantec/Daemon/debug.log"
   RemoveItem "/Library/Application Support/Symantec/Daemon/error.log"
   RemoveItem "/Library/Application Support/Symantec/Daemon/SymDaemon.bundle"
   RemoveItem "/Library/Application Support/Symantec/Daemon/timer"
   RemoveItem "/Library/Application Support/Symantec/Daemon/timer.log"
   RemoveItem "/Library/Application Support/Symantec/Daemon" -e
   RemoveItem "/Library/Application Support/Symantec/DeepSight"
   RemoveItem "/Library/Application Support/Symantec/ErrorReporting"
   RemoveItem "/Library/Application Support/Symantec/Firewall"
   RemoveItem "/Library/Application Support/Symantec/IntrusionPrevention"
   RemoveItem "/Library/Application Support/Symantec/Licensing"
   RemoveItem "/Library/Application Support/Symantec/LiveUpdate"
   RemoveItem "/Library/Application Support/Symantec/Mexico"
   RemoveItem "/Library/Application Support/Symantec/NisLaunch"
   RemoveItem "/Library/Application Support/Symantec/Norton AntiVirus"
   RemoveItem "/Library/Application Support/Symantec/Norton Application Aliases"
   RemoveItem "/Library/Application Support/Symantec/Norton DNS"
   RemoveItem "/Library/Application Support/Symantec/Norton Family Safety"
   RemoveItem "/Library/Application Support/Symantec/Norton Personal Firewall"
   RemoveItem "/Library/Application Support/Symantec/Norton Privacy Control.bundle"
   RemoveItem "/Library/Application Support/Symantec/Norton Safety Minder"
   RemoveItem "/Library/Application Support/Symantec/Norton Utilities"
   RemoveItem "/Library/Application Support/Symantec/NortonM"
   RemoveItem "/Library/Application Support/Symantec/Protector"
   RemoveItem "/Library/Application Support/Symantec/Registry"
   RemoveItem "/Library/Application Support/Symantec/Scheduler"
   RemoveItem "/Library/Application Support/Symantec/SEP"
   RemoveItem "/Library/Application Support/Symantec/Settings"
   RemoveItem "/Library/Application Support/Symantec/Silo"
   RemoveItem "/Library/Application Support/Symantec/SMC"
   RemoveItem "/Library/Application Support/Symantec/SNAC"
   RemoveItem "/Library/Application Support/Symantec/Submissions"
   RemoveItem "/Library/Application Support/Symantec/Symantec AntiVirus"
   RemoveItem "/Library/Application Support/Symantec/SymQuickMenu"
   RemoveItem "/Library/Application Support/Symantec/SymSAQuickMenu"
   RemoveItem "/Library/Application Support/Symantec/SymUIAgent"
   RemoveItem "/Library/Application Support/Symantec/SymWebKitUtils"
   RemoveItem "/Library/Application Support/Symantec/Uninstaller"
   RemoveItem "/Library/Application Support/Symantec/WebFraud"
   RemoveItem "/Library/Application Support/Symantec" -e
   RemoveItem "/Library/Application Support/symantec_uninstalldashboard" "*"
   RemoveItem "/Library/Application Support/SymRun"
   RemoveItem "/Library/Authenticators/SymAuthenticator.bundle"
   RemoveItem "/Library/CFMSupport/Norton Shared Lib"
   RemoveItem "/Library/CFMSupport/Norton Shared Lib Carbon"
   RemoveItem "/Library/Contextual Menu Items/NAVCMPlugIn.plugin"
   RemoveItem "/Library/Contextual Menu Items/SAVCMPlugIn.plugin"
   RemoveItem "/Library/Contextual Menu Items/SymFileSecurityCM.plugin"
   RemoveItem "/Library/Documentation/Help/LiveUpdate Help"
   RemoveItem "/Library/Documentation/Help/LiveUpdate-Hilfe"
   RemoveItem "/Library/Documentation/Help/Norton AntiVirus Help"
   RemoveItem "/Library/Documentation/Help/Norton AntiVirus-Hilfe"
   RemoveItem "/Library/Documentation/Help/Norton Help"
   RemoveItem "/Library/Documentation/Help/Norton Help Scripts"
   RemoveItem "/Library/Documentation/Help/Norton Help Scripts Folder"
   RemoveItem "/Library/Documentation/Help/Norton Utilities Help"
   RemoveItem "/Library/Frameworks/mach_inject_bundle.framework"
   RemoveItem "/Library/InputManagers/Norton Confidential for Safari"
   RemoveItem "/Library/InputManagers/Norton Safety Minder"
   RemoveItem "/Library/InputManagers/SymWebKitUtils"
   RemoveItem "/Library/Internet Plug-Ins/Norton Confidential for Safari.plugin"
   RemoveItem "/Library/Internet Plug-Ins/Norton Family Safety.plugin"
   RemoveItem "/Library/Internet Plug-Ins/Norton Safety Minder.plugin"
   RemoveItem "/Library/Internet Plug-Ins/NortonInternetSecurityBF.plugin"
   RemoveItem "/Library/Internet Plug-Ins/NortonSafetyMinderBF.plugin"
   RemoveItem "/Library/LaunchAgents/com.symantec" "*"
   RemoveItem "/Library/LaunchDaemons/com.norton" "*"
   RemoveItem "/Library/LaunchDaemons/com.symantec" "*"
   RemoveItem "/Library/Logs/Norton" "*"
   RemoveItem "/Library/Logs/Symantec" "*"
   RemoveItem "/Library/Logs/SymAPErr.log"
   RemoveItem "/Library/Logs/SymAPOut.log"
   RemoveItem "/Library/Logs/SymDeepsight" "*"
   RemoveItem "/Library/Logs/SymFWLog.log"
   RemoveItem "/Library/Logs/SymFWRules.log" "*"
   RemoveItem "/Library/Logs/SymScanServerDaemon.log"
   RemoveItem "/Library/Plug-ins/DiskImages/NUMPlugin.bundle"
   RemoveItem "/Library/Plug-ins/DiskImages/VRPlugin.bundle"
   RemoveItem "/Library/Plug-ins/DiskImages" -e -u
   RemoveItem "/Library/Plug-ins" -e -u
   RemoveItem "/Library/PreferencePanes/APPrefPane.prefPane"
   RemoveItem "/Library/PreferencePanes/FileSaver.prefPane"
   RemoveItem "/Library/PreferencePanes/Norton Family Safety.prefPane"
   RemoveItem "/Library/PreferencePanes/Norton Safety Minder.prefPane"
   RemoveItem "/Library/PreferencePanes/Ribbon.Norton.prefPane"
   RemoveItem "/Library/PreferencePanes/SymantecQuickMenu.prefPane"
   RemoveItem "/Library/PreferencePanes/SymAutoProtect.prefPane"
   RemoveItem "/Library/PrivateFrameworks/NPF.framework"
   RemoveItem "/Library/PrivateFrameworks/NPFCoreServices.framework"
   RemoveItem "/Library/PrivateFrameworks/NPFDataSource.framework"
   RemoveItem "/Library/PrivateFrameworks/PlausibleDatabase.framework"
   RemoveItem "/Library/PrivateFrameworks/SymAppKitAdditions.framework"
   RemoveItem "/Library/PrivateFrameworks/SymAVScan.framework"
   RemoveItem "/Library/PrivateFrameworks/SymBase.framework"
   RemoveItem "/Library/PrivateFrameworks/SymConfidential.framework"
   RemoveItem "/Library/PrivateFrameworks/SymDaemon.framework"
   RemoveItem "/Library/PrivateFrameworks/SymFirewall.framework"
   RemoveItem "/Library/PrivateFrameworks/SymInternetSecurity.framework"
   RemoveItem "/Library/PrivateFrameworks/SymIPS.framework"
   RemoveItem "/Library/PrivateFrameworks/SymIR.framework"
   RemoveItem "/Library/PrivateFrameworks/SymLicensing.framework"
   RemoveItem "/Library/PrivateFrameworks/SymNetworking.framework"
   RemoveItem "/Library/PrivateFrameworks/SymOxygen.framework"
   RemoveItem "/Library/PrivateFrameworks/SymPersonalFirewall.framework"
   RemoveItem "/Library/PrivateFrameworks/SymScheduler.framework"
   RemoveItem "/Library/PrivateFrameworks/SymSharedSettings.framework"
   RemoveItem "/Library/PrivateFrameworks/SymSubmission.framework"
   RemoveItem "/Library/PrivateFrameworks/SymSystem.framework"
   RemoveItem "/Library/PrivateFrameworks/SymUIAgent.framework"
   RemoveItem "/Library/PrivateFrameworks/SymUIAgentUI.framework"
   if [ ! -e "$VolumePrefix/Library/PrivateFrameworks/SymWebKitUtils.framework/Versions/A/Resources/SymWKULoader.dylib" \
        -o \( $CreateFilesRemovedListOnly = true -a $ListOnlyFilesThatExist = false \) ] ; then
      RemoveItem "/Library/PrivateFrameworks/SymWebKitUtils.framework"
   fi
   RemoveItem "/Library/PrivilegedHelperTools/com.symantec" "*"
   RemoveItem "/Library/PrivilegedHelperTools/NATRemoteLock.app"
   IFS='
'
   for EachReceiptLine in `echo "$ReceiptsTable" | grep . | grep -v '^#'` ; do
      ReceiptName=`echo "$EachReceiptLine" | awk -F "	" '{print $1}'`
      ReceiptArg=`echo "$EachReceiptLine" | awk -F "	" '{print $2}'`
      if [ "z$ReceiptArg" = z-a ] ; then
         RemoveItem "/Library/Receipts/$ReceiptName" "*"
         RemoveItem "/Library/Receipts/$ReceiptName"Dev "*"
      else
         if [ "z$ReceiptName" = zSymWebKitUtils.pkg -o "z$ReceiptName" = zSymWebKitUtilsDev.pkg ] ; then
            # If SymWKULoader exists and CleanUpSymWebKitUtils does not, skip deletion of SymWebKitUtils receipt
            [ -e "$VolumePrefix/Library/PrivateFrameworks/SymWebKitUtils.framework/Versions/A/Resources/SymWKULoader.dylib" -a ! -e /Library/StartupItems/CleanUpSymWebKitUtils ] && continue
         fi
         RemoveItem "/Library/Receipts/$ReceiptName"
         if [ "`echo "$ReceiptName" | grep '\.pkg$'`" ] ; then
            ReceiptName="`basename "$ReceiptName" .pkg`Dev.pkg"
            RemoveItem "/Library/Receipts/$ReceiptName"
         fi
      fi
   done
   RemoveItem "/Library/ScriptingAdditions/SymWebKitUtils.osax"
   RemoveItem "/Library/ScriptingAdditions/SymWebKitUtilsSL.osax"
   RemoveItem "/Library/Services/ScanService.service"
   RemoveItem "/Library/Services/SymSafeWeb.service"
   RemoveItem "/Library/Services" -e -u
   RemoveItem "/Library/StartupItems/NortonAutoProtect"
   RemoveItem "/Library/StartupItems/NortonAutoProtect.kextcache"
   RemoveItem "/Library/StartupItems/NortonLastStart"
   RemoveItem "/Library/StartupItems/NortonMissedTasks"
   RemoveItem "/Library/StartupItems/NortonPersonalFirewall"
   RemoveItem "/Library/StartupItems/NortonPrivacyControl"
   RemoveItem "/Library/StartupItems/NUMCompatibilityCheck"
   RemoveItem "/Library/StartupItems/SMC"
   RemoveItem "/Library/StartupItems/SymAutoProtect"
   RemoveItem "/Library/StartupItems/SymAutoProtect.kextcache"
   RemoveItem "/Library/StartupItems/SymDCInit"
   RemoveItem "/Library/StartupItems/SymMissedTasks"
   RemoveItem "/Library/StartupItems/SymProtector"
   RemoveItem "/Library/StartupItems/SymQuickMenuOSFix"
   RemoveItem "/Library/StartupItems/SymWebKitUtilsOSFix"
   RemoveItem "/Library/StartupItems/TrackDelete"
   RemoveItem "/Library/StartupItems/VolumeAssist"
   RemoveItem "/Library/Symantec/tmp"
   RemoveItem "/Library/Symantec" -E -u
   RemoveItem "/Library/Widgets/NAV.wdgt"
   RemoveItem "/Library/Widgets/Symantec Alerts.wdgt"
   RemoveItem "/Library/Widgets" -E -u
   RemoveItem "/Norton AntiVirus Installer Log"
#  Folder with files erroneously created by an early Corsair installer:
   RemoveItem "/opt/Symantec"
#  Folder erroneously created by that Corsair installer - removed if empty:
   RemoveItem "/opt" -E -u
#  Folder erroneously created by NPF 300.001 - removed if empty:
   RemoveItem "/Personal" -e -u
   RemoveItem "/private/etc/liveupdate.conf"
   RemoveItem "/private/etc/mach_init.d/SymSharedSettings.plist"
   RemoveItem "/private/etc/Symantec.conf"
   RemoveItem "/private/tmp/com.symantec.liveupdate.reboot"
   RemoveItem "/private/tmp/com.symantec.liveupdate.restart"
   RemoveItem "/private/tmp/jlulogtemp"
   RemoveItem "/private/tmp/LiveUpdate." "*"
   RemoveItem "/private/tmp/liveupdate"
   RemoveItem "/private/tmp/lulogtemp"
   RemoveItem "/private/tmp/SymSharedFrameworks" "*"
   RemoveItem "/private/tmp/symask"
   RemoveItem "/private/var/db/NATSqlDatabase.db"
   RemoveItem '/private/var/db/receipts/$(SYM_SKU_REVDOMAIN).install.bom'
   RemoveItem '/private/var/db/receipts/$(SYM_SKU_REVDOMAIN).install.plist'
   RemoveItem "/private/var/db/receipts/com.Symantec" "*"
   RemoveItem "/private/var/db/receipts/com.symantec" "*"
   RemoveItem "/private/var/tmp/com.Symantec" "*"
   RemoveItem "/private/var/tmp/com.symantec" "*"
   RemoveItem "/private/var/log/nortondns.log"
   RemoveItem "/private/var/log/Npfkernel.log.fifo"
   RemoveItem "/private/var/root/Library/Bundles/NAVIR.bundle"
   RemoveItem "/private/var/root/Library/Bundles" -E -u
   RemoveItem "/private/var/root/Library/Contextual Menu Items/NAVCMPlugIn.plugin"
   RemoveItem "/private/var/root/Library/Contextual Menu Items" -E -u
#  Folder erroneously created by NPF 300.001 - removed if empty:
   RemoveItem "/Solutions" -e -u
#  Folder erroneously created by NPF 300.001 - removed if empty:
   RemoveItem "/Support/Norton" -e -u
#  Folder erroneously created by NPF 300.001 - removed if empty:
   RemoveItem "/Support" -e -u
   RemoveItem "/symaperr.log"
   RemoveItem "/symapout.log"
#  Four frameworks erroneously installed by early builds of NAV 9.0.1:
   RemoveItem "/SymAppKitAdditions.framework"
   RemoveItem "/SymBase.framework"
   RemoveItem "/SymNetworking.framework"
   RemoveItem "/SymSystem.framework"
   RemoveItem "/System/Library/Authenticators/SymAuthenticator.bundle"
   RemoveItem "/System/Library/CFMSupport/Norton Shared Lib Carbon"
   RemoveItem "/System/Library/CoreServices/NSWemergency"
   RemoveItem "/System/Library/CoreServices/NUMemergency"
   RemoveItem "/System/Library/Extensions/DeleteTrap.kext"
   RemoveItem "/System/Library/Extensions/KTUM.kext"
   RemoveItem "/System/Library/Extensions/NPFKPI.kext"
   RemoveItem "/System/Library/Extensions/SymDC.kext"
   RemoveItem "/System/Library/Extensions/SymEvent.kext"
   RemoveItem "/System/Library/Extensions/symfs.kext"
   RemoveItem "/System/Library/Extensions/SymInternetSecurity.kext"
   RemoveItem "/System/Library/Extensions/SymIPS.kext"
   RemoveItem "/System/Library/Extensions/SymOSXKernelUtilities.kext"
   RemoveItem "/System/Library/Extensions/SymPersonalFirewall.kext"
   RemoveItem "/System/Library/StartupItems/NortonAutoProtect"
   RemoveItem "/System/Library/StartupItems/SymMissedTasks"
   RemoveItem "/System/Library/Symantec"
   RemoveItem "/System/Library/SymInternetSecurity.kext"
   RemoveItem "/SystemWorks Installer Log"
   RemoveItem "/Users/dev/bin/smellydecode"
   RemoveItem "/Users/dev/bin" -E -u
   RemoveItem "/Users/dev" -E -u
   RemoveItem "/Users/Shared/NAV Corporate"
   RemoveItem "/Users/Shared/NIS Corporate"
   RemoveItem "/Users/Shared/RemoveSymantecMacFilesRemovesThese.txt"
   RemoveItem "/Users/Shared/RemoveSymantecMacFilesLog.txt"
   RemoveItem "/Users/Shared/RemoveSymantecMacFilesRemovesThese.txt"
   RemoveItem "/Users/Shared/RemoveSymantecMacFilesLog.txt"
   RemoveItem "/Users/Shared/SymantecRemovalToolRemovesThese.txt"
   RemoveItem "/Users/Shared/SymantecRemovalToolLog.txt"
   RemoveItem "/usr/bin/MigrateQTF"
   RemoveItem "/usr/bin/navx"
   RemoveItem "/usr/bin/npfx"
   RemoveItem "/usr/bin/savx"
   RemoveItem "/usr/bin/scfx"
   RemoveItem "/usr/bin/symsched"
   RemoveItem "/usr/lib/libsymsea.1.0.0.dylib"
   RemoveItem "/usr/lib/libsymsea.dylib"
   RemoveItem "/usr/lib/libwpsapi.dylib"
   RemoveItem "/usr/local/bin/KeyGenerator"
   RemoveItem "/usr/local/bin/MigrateQTF"
   RemoveItem "/usr/local/bin" -E -u
   RemoveItem "/usr/local/lib/libecomlodr.dylib"
   RemoveItem "/usr/local/lib/libgecko3parsers.dylib"
   RemoveItem "/usr/local/lib" -E -u
   RemoveItem "/usr/local" -E -u
   RemoveItem "/usr/share/man/man1/NAVScanIDs.h"
   RemoveItem "/var/db/receipts/com.symantec" "*"
   RemoveItem "/var/log/luxtool.log" "*"
   if [ -f "$VolumePrefix/etc/syslog.conf" -a $CreateFilesRemovedListOnly = false ] ; then
      # Remove Norton Personal Firewall entries from /etc/syslog.conf
      sed -e "/Norton Personal Firewall/d" -e "/Npfkernel.log.fifo/d" "$VolumePrefix/etc/syslog.conf" > /private/tmp/NPF.syslog.conf
      /bin/cp -f /private/tmp/NPF.syslog.conf "$VolumePrefix/etc/syslog.conf"
      /bin/rm -f /private/tmp/NPF.syslog.conf
   fi
   RemoveFilesFromLibraryAndUserDirectories "$1"
   RemoveItem /Library/Preferences/Network -E -u
   if [ -s "$FilesRemovedFilesOnlyList" ] ; then
      sort -f "$FilesRemovedFilesOnlyList" | uniq | grep . >> "$FilesRemovedList"
   fi
}

RemoveEmptyDirectory()
{
   # Usage:     RemoveEmptyDirectory $1
   # Argument:  $1 = Full path name of directory
   # Summary:   Removes directory $1 if it is empty or if it contains
   #            only .DS_Store and/or .localized (the next best thing
   #            to being empty).
   #
   # If $1 is a directory and not a link
   if [ -d "$1" -a ! -L "$1" ] ; then
      # If folder contains only .DS_Store and/or .localized, or is empty
      if [ -z "`ls "$1" 2>/dev/null | grep -v "^\.DS_Store\|^\.localized"`" ] ; then
         $ShowFilesAsRemoved && echo "   Removing: \"$1\""
         # Clear immutable bit to remove any Finder lock
         chflags -R nouchg "$1" 2>/dev/null 1>&2
         /bin/rm -rf "$1" 2>/dev/null 1>&2   # Remove folder
      fi
   fi
}

RemoveFilesFromLibraryAndUserDirectories()
{
   # Usage:     RemoveFilesFromLibraryAndUserDirectories $1
   # Argument:  $1 = Name of volume from which to remove preferences.
   #                 The name must begin with "/Volumes/"
   #                 unless it is "/" (boot volume).
   # Summary:   Removes all Symantec files & folders from each user's
   #            preferences, /Library/Caches, and /Library/Preferences.
   #            Removes help files from /Library/Documentation. Removes
   #            folders incorrectly created by NAV 7.0.2 from each
   #            user's home directory.
   #
   CurrentVolumeBeingUsed="$1"
   if [ "$1" = "/" ] ; then
      VolumeToCheck=""
   else
      VolumeToCheck="$1"
   fi
   # set IFS to only newline to get all user names
   IFS='
'
   for UserName in `ls "$VolumeToCheck/Users" 2>/dev/null` "root" "/" ; do
      if [ "$UserName" = "root" ] ; then
         dir="/private/var/root/Library"
         dir2="/private/var/root"
      elif [ "$UserName" = "/" ] ; then
         dir="/Library"
         dir2=""
      else
         dir="/Users/$UserName/Library"
         dir2="/Users/$UserName"
      fi
      # If dir is not a directory, skip to the next name
      [ ! -d "$VolumeToCheck$dir" ] && continue
      cd "$VolumeToCheck/"
      # If a user, delete folders from user's home directory that were
      # incorrectly created by NAV 7.0.2
      if [ "$UserName" != "/" ] ; then
         RemoveItem "$dir2/Applications/LiveUpdate Folder (OS X)"
         RemoveItem "$dir2/Applications/Norton AntiVirus (OS X)"
         RemoveItem "$dir2/Applications" -e -u
      fi
      RemoveItem "$dir/Application Support/NortonZone"
      # If a user directory
      if [ "$dir2" ] ; then
         RemoveItem "$dir/Application Support/Symantec"
      else
         # Make second attempt to remove "/Application Support/Symantec/ErrorReporting"
         RemoveItem "$dir/Application Support/Symantec/ErrorReporting"
         RemoveItem "$dir/Application Support/Symantec" -e
      fi
      RemoveItem "$dir/Documentation/Help/Norton Privacy Control Help"
      RemoveItem "$dir/Documentation/Help/Norton Personal Firewall Help"
      RemoveItem "$dir/Caches/com.apple.Safari/Extensions/Norton" "*" -u
      RemoveItem "$dir/Caches/com.apple.Safari/Extensions/Symantec" "*" -u
      RemoveItem "$dir/Caches/com.norton" "*" -u
      RemoveItem "$dir/Caches/com.symantec" "*" -u
      RemoveItem "$dir/Caches/Norton" "*" -u
      RemoveItem "$dir/Caches/Symantec" "*" -u
      RemoveItem "$dir/Preferences/ByHost/com.symantec" "*"
      RemoveItem "$dir/Preferences/com.norton" "*"
      RemoveItem "$dir/Preferences/com.symantec" "*" -x 'com\.symantec\.sacm.*' -x 'com\.symantec\.smac.*'
      RemoveItem "$dir/Preferences/LiveUpdate Preferences"
      RemoveItem "$dir/Preferences/LU Admin Preferences"
      RemoveItem "$dir/Preferences/LU Host Admin.plist"
      RemoveItem "$dir/Preferences/NAV8.0.003.plist"
      RemoveItem "$dir/Preferences/Network/com.symantec" "*"
      RemoveItem "$dir/Preferences/Norton AntiVirus Prefs Folder"
      RemoveItem "$dir/Preferences/Norton Application Aliases"
      RemoveItem "$dir/Preferences/Norton Personal Firewall Log"
      RemoveItem "$dir/Preferences/Norton Scheduler OS X.plist"
      RemoveItem "$dir/Preferences/Norton Utilities Preferences"
      RemoveItem "$dir/Preferences/Norton Zone"
      RemoveItem "$dir/Preferences/wcid"
      RemoveItem "$dir/Safari/Extensions/NortonSafetyMinderBF" "*"
   done
}

RemoveInvisibleFilesFromVolume()
{
   # Usage:     RemoveInvisibleFilesFromVolume $1
   # Argument:  $1 = Volume name. The name should begin with "/Volumes/"
   #                 unless it is "/" (boot volume).
   # Summary:   Removes the invisible Symantec for OS X files - Norton FS
   #            and AntiVirus QuickScan files - from $1.
   #
   ! $RemoveInvisibleFiles && return
   CurrentVolumeBeingUsed="$1"
   cd "$1"
   if $CreateFilesRemovedListOnly ; then
      echo "Finding invisible Symantec files on: $1" >&2
   elif $ShowFilesAsRemoved ; then
      echo "Locating invisible Symantec files in: $1"
   else
      echo "Removing invisible Symantec files from: $1"
   fi
   RemoveItem "/.SymAVQSFile"
   RemoveItem "/NAVMac800QSFile"
   RemoveItem "/Norton FS Data"
   RemoveItem "/Norton FS Index"
   RemoveItem "/Norton FS Volume"
   RemoveItem "/Norton FS Volume 2"
}

RemoveItem()
{
   # Usage:     RemoveItem FilePath [-e | -E] [-u] [-x <pattern>] [FileExtension]
   #
   # Summary:   Deletes the file or folder passed, FilePath, from the
   #            current directory.
   #
   # Options:
   #    -e      Delete FilePath only if it is a directory that is empty or
   #            that contains only ".DS_Store" and/or ".localized" files.
   #            If the folder could not be deleted, error message is shown.
   #    -E      Same as the -e option, except no error message is shown if
   #            the folder could not be deleted.
   #    -u      Item is not removed by Symantec Uninstaller.app.
   #    -x <Pattern>
   #            Pattern to exclude from file list. Pattern will become
   #            ^FilePath/Pattern$ so add wildcards as needed. Make sure
   #            to prefix special characters you wish to match with \
   #            (example: to match a period, \.). You may pass several
   #            -x <pattern> groupings.
   #    <FileExtension>
   #            All files that match FilePath*FileExtension are deleted.
   #            To match any files that begin with FilePath, pass "*" as
   #            FileExtension (don't pass * unquoted). Only the last
   #            FileExtension passed will be used
   #
   # Note:      Make sure to run the SetupCleanup function before the
   #            first run of this function and run the FinishCleanup
   #            function before exiting the script.
   #            Make sure to change directory to root of the volume you
   #            want the file or folder removed from before calling this
   #            function.
   #            FilePath must be the first argument. The other options
   #            may appear after FilePath in any order.
   #
   local ExclusionPattern=""
   # If / or no file name passed, return
   [ "z$1" = z/ -o -z "$1" ] && return 
   VolumeFromWhichToRemove="`pwd`"
   FilePath="$1"
   if [ "$VolumeFromWhichToRemove" = "/" ] ; then
      FullFilePath="$FilePath"
   else
      FullFilePath="$VolumeFromWhichToRemove$FilePath"
   fi
   PathDir=`dirname "$FullFilePath"`
   PathBasePattern=`basename "$FullFilePath" | sed s/"\."/"\\\\\."/g`
   shift
   DeleteOnlyIfEmptyDir=false
   SkipErrorMessageIfEmptyDirNotFound=false
   ExtensionPassed=""
   ShouldNotBeRemovedBySymantecUninstaller=false
   while [ "$1" ] ; do
      if [ "z$1" = z-e ] ; then
         DeleteOnlyIfEmptyDir=true
         SkipErrorMessageIfEmptyDirNotFound=false
      elif [ "z$1" = z-E ] ; then
         DeleteOnlyIfEmptyDir=true
         SkipErrorMessageIfEmptyDirNotFound=true
      elif [ "z$1" = z-u ] ; then
         ShouldNotBeRemovedBySymantecUninstaller=true
      elif [ "z$1" = z-x ] ; then
         if [ "$2" ] ; then
            shift
            if [ "$ExclusionPattern" ] ; then
               ExclusionPattern="$ExclusionPattern\|^$PathDir/$1$"
            else
               ExclusionPattern="^$PathDir/$1$"
            fi
         fi
      else
         ExtensionPassed="$1"
      fi
      shift
   done
   if [ "z$ExtensionPassed" = "z*" ] ; then
      ListOfPaths=`ls -d "$PathDir/"* 2>/dev/null | grep -i "^$PathDir/$PathBasePattern" | sort -f`
      PathToShow="$FullFilePath*"
   elif [ "$ExtensionPassed" ] ; then
      ExtensionPassedPattern=`printf "%s" "$ExtensionPassed" | sed s/"\."/"\\\\\."/g`
      ListOfPaths=`ls -d "$PathDir/"* 2>/dev/null | grep -i "^$PathDir/$PathBasePattern.*$ExtensionPassedPattern$" | sort -f`
      PathToShow="$FullFilePath*$ExtensionPassed"
   else
      ListOfPaths=`ls -d "$FullFilePath" 2>/dev/null`
      PathToShow="$FullFilePath"
   fi
   # If there are items to exclude from the list and there are matching items
   if [ "z$ExclusionPattern" != z -a -n "$ListOfPaths" ] ; then
      ListOfPaths=`printf "%s" "$ListOfPaths" | grep -i -v -e "$ExclusionPattern"`
   fi
   if $CreateFilesRemovedListOnly ; then
      # If -E passed, then don't list the item
      $SkipErrorMessageIfEmptyDirNotFound && return
      if ! $ListOnlyFilesThatExist ; then
         echo "$PathToShow`$DeleteOnlyIfEmptyDir && echo " [folder deleted only if empty]"`" >> "$FilesRemovedList"
      # Else if file exists
      elif [ "$ListOfPaths" ] ; then
         IFS='
'
         if $DeleteOnlyIfEmptyDir ; then
            ItemsToAddToList="$ListOfPaths"
         else
            ItemsToAddToList=""
            for EachItemListed in $ListOfPaths ; do
               if [ -L "$EachItemListed" -o -f "$EachItemListed" ] ; then
                  ItemsToAddToList="$ItemsToAddToList
$EachItemListed"
               else
                  ItemsToAddToList="$ItemsToAddToList
`find "$EachItemListed" 2>/dev/null`"
               fi
            done
         fi
         for EachItemFound in $ItemsToAddToList ; do
            if $ShouldNotBeRemovedBySymantecUninstaller ; then
               AddedText="$NotRemovedBySymantecUninstallerText"
            elif [ "`echo "$EachItemFound" | grep -F "$NotRemovedBySymantecUninstaller"`" ] ; then
               AddedText="$NotRemovedBySymantecUninstallerText"
            else
               AddedText=""
            fi
            echo "$EachItemFound`$DeleteOnlyIfEmptyDir && echo " [folder deleted only if empty]"`$AddedText" >> "$FilesRemovedFilesOnlyList"
         done
         NoFilesToRemove=false
         FilesFoundOnThisVolume=true
      fi
      return
   fi
   IFS='
'
   for EachFullPath in $ListOfPaths ; do
      # If -e or -E was passed
      if $DeleteOnlyIfEmptyDir ; then
         #   remove directory only if empty
         RemoveEmptyDirectory "$EachFullPath"
         # If -E passed, then skip error reporting
         $SkipErrorMessageIfEmptyDirNotFound && continue
      else
         $ShowFilesAsRemoved && echo "   Removing: \"$EachFullPath\""
         # Clear immutable bit to remove any Finder lock
         chflags -R nouchg "$EachFullPath" 2>/dev/null 1>&2
         /bin/rm -rf "$EachFullPath" 2>/dev/null 1>&2   # Remove file/folder
      fi
      # If file still exists
      if [ "`ls -d "$EachFullPath" 2>/dev/null`" ] ; then
         TheFileWasRemoved=false
      else
         TheFileWasRemoved=true
         SomeFileWasRemoved=true
      fi
      # If the file/folder was not removed
      if ! $TheFileWasRemoved ; then
         if ! $ErrorOccurred ; then
            # Create LogFile
            echo "Symantec files/folders not removed:" >"$LogFile"
            chmod a=rw "$LogFile"
            ErrorOccurred=true
         fi
         echo "   $EachFullPath" >>"$LogFile"
      # Else if boot volume
      elif [ "$CurrentVolumeBeingUsed" = "/" ] ; then
         RestartMayBeNeeded=true
         SomeFileWasRemovedFromBootVolume=true
      else
         SomeFileWasRemovedFromNonBootVolume=true
      fi
      NoFilesToRemove=false
      FilesFoundOnThisVolume=true
   done
}

RemoveNortonZoneDirectories()
{
   # Usage:     RemoveNortonZoneDirectories user_home_directory
   # Summary:   Removes Norton Zone paths listed in zoneDirectoryManagerRegistryKey in
   #            user_home_directory/Preference/com.symantec.nds.Norton-Zone.plist
   #
   local UserHomeDir="$1"
   local ZonePath
   local ZonePaths
   [ ! -d "$UserHomeDir" ] && return
   ZonePaths=`defaults read "$UserHomeDir/Library/Preferences/"com.symantec.nds.Norton-Zone zoneDirectoryManagerRegistryKey 2>/dev/null | grep = | awk -F '"' '{print $2}'`
   IFS='
'
   for ZonePath in $ZonePaths ; do
      RemoveItem "$ZonePath"
   done
   RemoveItem "$UserHomeDir/Norton Zone" "*"
}

RemoveNortonZoneSavedSessions()
{
   # Usage:     RemoveNortonZoneSavedSessions volume
   # Summary:   Removes Norton Zone saved sessions, based on keychain_cleanUp.command script.
   #            If volume is not / (current boot volume), removal is skipped.
   #            If volume is not specified, / is assumed.
   #
   local VolumeBeingPurged="$1"
   local EachLoginKeychain
   # If volume not specified, assume it is boot volume
   [ -z "$VolumeBeingPurged" ] && VolumeBeingPurged=/
   # If volume being cleaned up is not the boot volume, skip purge
   [ "z$VolumeBeingPurged" != z/ ] && return
   if $CreateFilesRemovedListOnly ; then
      echo "Norton Zone saved sessions would be purged if present." >> "$FilesRemovedList"
      echo "" >> "$FilesRemovedList"
      return
   fi
   echo "Attempting to remove Norton Zone saved sessions"
   for EachLoginKeychain in `ls -d /Users/*/Library/Keychains/login.keychain 2>/dev/null` ; do
      /usr/bin/security delete-generic-password "$EachLoginKeychain" -s com.norton.mexico.auth 2>/dev/null 1>&2
   done
}

RestartComputer()
{
   # Usage:     RestartComputer
   # Summary:   Prompts to see if user would like to restart. Restarts
   #            computer using 'reboot' command if 'yes' or 'y' is
   #            entered; exits the script otherwise.
   # Note:      User must be root or an admin for reboot to work, so this
   #            function should only be used in scripts run as root or
   #            admin user.
   #
   echo
   if $RunningFromWithinAppBundleOrSupportFolder ; then
      ExitScript $FinishedExitCode
   elif $QuitWithoutRestarting ; then
      echo "Exited the script without restarting the computer."
      ExitScript $FinishedExitCode
   elif ! $RestartAutomatically ; then
      echo "Do you wish to restart the computer now (WARNING: Unsaved changes"
      printf "in other open applications will be lost if you do!) (y/n)? "
      if `YesEntered` ; then
         RestartAutomatically=true
      fi
      echo
   fi
   if $RestartAutomatically ; then
      if $PauseBeforeRestarting ; then
         printf "Computer will restart in 3 seconds (ctrl-C to cancel restart)..."
         sleep 1
         printf " 3"
         sleep 1
         printf " 2"
         sleep 1
         printf " 1"
         sleep 1
      fi
      echo
      echo "Computer is restarting..."
      reboot
   else
      echo "Exited the script without restarting the computer."
      ExitScript $FinishedExitCode
   fi
}

RestoreSaved()
{
   # Usage:     RestoreSaved
   # Summary:   Restores the files saved by the Save function.
   # Note:      Make sure to change directory to the root of the
   #            volume to which files will be restored before
   #            calling this function.
   #
   ! $FilesWereSaved && return
   mkdir -p "Library/Application Support/Norton Solutions Support/LiveUpdate/Registry" 2>/dev/null
   /bin/cp -Rpf "$SavedFilesDir/LUsm "* "Library/Application Support/Norton Solutions Support/LiveUpdate/Registry" 2>/dev/null
   /usr/sbin/chown root:admin "`pwd`/"
   /usr/sbin/chown root:admin "Applications"
   /usr/sbin/chown root:admin "Library"
   /usr/sbin/chown root:admin "Library/Application Support"
   /usr/sbin/chown root:admin "Library/Application Support/Norton Solutions Support"
   /usr/sbin/chown root:admin "Library/Application Support/Norton Solutions Support/LiveUpdate"
   /usr/sbin/chown root:admin "Library/Application Support/Norton Solutions Support/LiveUpdate/Registry"
   /usr/sbin/chown root:admin "Library/Application Support/Norton Solutions Support/LiveUpdate/Registry/LUsm "*
   /bin/chmod 1775 "`pwd`/".
   /bin/chmod 775 "Applications"
   /bin/chmod 775 "Library"
   /bin/chmod 775 "Library/Application Support"
   /bin/chmod 755 "Library/Application Support/Norton Solutions Support"
   /bin/chmod 755 "Library/Application Support/Norton Solutions Support/LiveUpdate"
   /bin/chmod 755 "Library/Application Support/Norton Solutions Support/LiveUpdate/Registry"
   /bin/chmod 644 "Library/Application Support/Norton Solutions Support/LiveUpdate/Registry/LUsm "*
   /bin/rm -rf "$SavedFilesDir" 2>/dev/null
}

RunPredeleteScripts()
{
   # Usage:     RunPredeleteScripts [$1]
   # Argument:  $1 = Path of current volume.
   # Summary:   If $1 is "" or /, predelete scripts in receipts listed in
   #            ReceiptsTable are run.
   #
   local EachReceiptLine
   local EachReceiptMatchingAll
   local ReceiptList
   local ReceiptListMatchingAll=""
   local VolumePathPassed="$1"
   [ "z$VolumePathPassed" = z/ ] && VolumePathPassed=""
   if $CreateFilesRemovedListOnly ; then
      if [ "$VolumePathPassed" ] ; then
         echo "Receipt predelete scripts would not be run on that volume." >> "$FilesRemovedList"
      elif $DoRunPredeleteScripts ; then
         echo "Receipt predelete scripts would be run as they are found." >> "$FilesRemovedList"
      else
         echo "Receipt predelete scripts would not be run because the -d option was specified." >> "$FilesRemovedList"
      fi
      return
   elif [ "$VolumePathPassed" ] ; then
      echo "Receipt predelete scripts were not run on that volume."
      return
   elif ! $DoRunPredeleteScripts ; then
      echo "Receipt predelete scripts were not run because the -d option was specified."
      return
   fi
   SYMANTEC_SAVED_DATA_DIR="/private/tmp/$FullScriptName-SYMANTEC_SAVED_DATA_DIR-`date +"%Y%m%d%H%M%S"`"
   mkdir -p "$SYMANTEC_SAVED_DATA_DIR" 2>/dev/null
   IFS='
'
   echo "Looking for predelete scripts in Symantec Uninstaller's Receipts folder"
   for PredeleteScript in `find "/Library/Application Support/Symantec/Uninstaller" 2>/dev/null | grep -E 'predelete$|pre_delete$'` ; do
      if [ -x "$PredeleteScript" ] ; then
         echo "--- Running $PredeleteScript ---"
         export SYMANTEC_SAVED_DATA_DIR
         if $ShowPredeleteErrors ; then
            "$PredeleteScript"
         else
            "$PredeleteScript" 2>/dev/null 1>&2
         fi
      fi
   done
   echo "Looking for predelete scripts in /Library/Receipts"
   ReceiptList=`echo "$ReceiptsTable" | grep '\.pkg' | grep -v '^#'`
   for EachReceiptMatchingAll in `echo "$ReceiptsTable" | grep '	-a' | grep -v '^#' | awk -F '	' '{print $1}'` ; do
      ReceiptListMatchingAll="$ReceiptListMatchingAll
`ls -d "/Library/Receipts/$EachReceiptMatchingAll"* 2>/dev/null`"
   done
   for EachReceiptMatchingAll in $ReceiptListMatchingAll ; do
      ReceiptList="$ReceiptList
`basename "$EachReceiptMatchingAll"`"
   done
   for EachReceiptLine in $ReceiptList ; do
      ReceiptArg=`echo "$EachReceiptLine" | awk -F "	" '{print $2}'`
      [ "z$ReceiptArg" = z-s ] && continue
      ReceiptName=`echo "$EachReceiptLine" | awk -F "	" '{print $1}'`
      [ -z "`echo "$ReceiptName" | grep '\.pkg$'`" ] && continue
      if [ -d "/Library/Receipts/$ReceiptName" ] ; then
         for PredeleteScript in `find "/Library/Receipts/$ReceiptName" 2>/dev/null | grep -E 'predelete$|pre_delete$'` ; do
            if [ -x "$PredeleteScript" ] ; then
               echo "--- Running $PredeleteScript ---"
               export SYMANTEC_SAVED_DATA_DIR
               if $ShowPredeleteErrors ; then
                  "$PredeleteScript"
               else
                  "$PredeleteScript" 2>/dev/null 1>&2
               fi
            fi
         done
      fi
      ReceiptName="`basename "$ReceiptName" .pkg`Dev.pkg"
      if [ -d "/Library/Receipts/$ReceiptName" ] ; then
         for PredeleteScript in `find "/Library/Receipts/$ReceiptName" 2>/dev/null | grep -E 'predelete$|pre_delete$'` ; do
            if [ -x "$PredeleteScript" ] ; then
               echo "--- Running $PredeleteScript ---"
               export SYMANTEC_SAVED_DATA_DIR
               if $ShowPredeleteErrors ; then
                  "$PredeleteScript"
               else
                  "$PredeleteScript" 2>/dev/null 1>&2
               fi
            fi
         done
      fi
   done
   rm -rf "$SYMANTEC_SAVED_DATA_DIR" 2>/dev/null
}

SaveFiles()
{
   # Usage:     SaveFiles
   # Summary:   Saves file(s) in /private/tmp. Use the RestoreSaved
   #            function to restore it.
   # Note:      Make sure to change directory to root of the volume you
   #            want the file or folder removed from before calling this
   #            function.
   #
   FilesWereSaved=false
   $CreateFilesRemovedListOnly && return
   [ -z "`ls -d "Library/Application Support/Norton Solutions Support/LiveUpdate/Registry/LUsm "* 2>/dev/null`" ] && return
   /bin/rm -rf "$SavedFilesDir" 2>/dev/null
   mkdir "$SavedFilesDir" 2>/dev/null
   /bin/cp -Rp "Library/Application Support/Norton Solutions Support/LiveUpdate/Registry/LUsm "* "$SavedFilesDir"
   FilesWereSaved=true
}

SetupCleanup()
{
   # Usage:     SetupCleanup
   # Summary:   Initializes variables needed for the RemoveItem function.
   #
   ErrorOccurred=false
   NoFilesToRemove=true
   /bin/rm -rf "$FilesRemovedList" "$FilesRemovedFilesOnlyList" 2>/dev/null 1>&2
   if $CreateFilesRemovedListOnly ; then
      if $ListOnlyFilesThatExist ; then
         echo "Summary of what $FullScriptName would do, based on files" > "$FilesRemovedList"
         echo "`$RemoveCrontabEntries && echo "and crontab entries "`that currently exist:" >> "$FilesRemovedList"
      else
         echo "Summary of what $FullScriptName would attempt to do:" > "$FilesRemovedList"
      fi
   fi
}

ShowContents()
{
   # Usage1:    ShowContents [-c] File [TextToShow]
   # Usage2:    ShowContents [-c] -s String [TextToShow]
   # Summary:   Displays contents of File or String. If there are more than
   #            23 lines, more command is used, using TextToShow as the
   #            name of the file; if TextToShow is not passed, "....." is
   #            used. If -c is specified, screen is cleared beforehand. 
   #
   if [ "z$1" = z-c ] ; then
      shift
      clear >&2
   fi  
   if [ "z$1" = z-s ] ; then
      shift
      if [ `printf "%s\n" "$1" | grep -c ""` -gt 23 ] ; then
         ShowContentsCurrentDir=`pwd`
         ShowContentsTempFolder="/private/tmp/$FullScriptName-ShowContents-`date +"%Y%m%d%H%M%S"`"
         mkdir "$ShowContentsTempFolder" 2>/dev/null
         [ ! -d "$ShowContentsTempFolder" ] && return 1
         cd "$ShowContentsTempFolder" 2>/dev/null
         [ "$2" ] && ShowContentsTempFile="$2" || ShowContentsTempFile="....."
         printf "%s\n" "$1" >"$ShowContentsTempFile"
         more -E "$ShowContentsTempFile"
         echo
         cd "$ShowContentsCurrentDir" 2>/dev/null
         rm -rf "$ShowContentsTempFolder" 2>/dev/null
      else
         printf "%s\n" "$1"
      fi
   elif [ -f "$1" ] ; then
      if [ `grep -c "" "$1"` -gt 23 ] ; then
         ShowContentsCurrentDir=`pwd`
         ShowContentsTempFolder="/private/tmp/$FullScriptName-ShowContents-`date +"%Y%m%d%H%M%S"`"
         mkdir "$ShowContentsTempFolder" 2>/dev/null
         [ ! -d "$ShowContentsTempFolder" ] && return 1
         [ "$2" ] && ShowContentsTempFile="$2" || ShowContentsTempFile="....."
         cat "$1" >"$ShowContentsTempFolder/$ShowContentsTempFile"
         cd "$ShowContentsTempFolder" 2>/dev/null
         more -E "$ShowContentsTempFile"
         echo
         cd "$ShowContentsCurrentDir" 2>/dev/null
         rm -rf "$ShowContentsTempFolder" 2>/dev/null
      else
         cat "$1"
      fi
   else
      return 1
   fi
   return 0
}

ShowFullFilePath()
{
   # Usage:     ShowFullFilePath [-a] [-P | -L] [-e] Path [[-e] Path]
   # Version:   1.0.2
   # Summary:   Prints the full path starting at / of Path if Path exists
   #            and Path is accessible by the user calling this function.
   #            Run this function as root to ensure full path displaying.
   #            If there is more than one existing file that matches the
   #            name, then only the first path that the shell matches is
   #            printed unless -a or more than one path is specified.
   #            You can specify wild card characters ? and * and other
   #            argument operators in the Path (e.g., "../*", "a?.txt",
   #            "[ab]*").
   # Options:   -a   Show all matching paths, sorted alphanumerically. If
   #                 -P is not passed, the same file may be shown multiple
   #                 times if there is more than one matching link that
   #                 points to it.
   #            -e <Path>
   #                 Treat argument after -e as a path. Use -e to treat
   #                 -a, -e, -L, or -P as a path.
   #            -L   Show logical path, even if a file pointed to by a link
   #                 doesn't exist. This is the default.
   #            -P   Show physical path. If a link points to a file that
   #                 does not exist, the path won't be shown.
   # History: 1.0.1 - Added -e option and ability to pass multiple paths.
   #                  Arguments can now be passed in any order.
   #                  Fixed error that could occur when resolving links
   #                  with long paths.
   #          1.0.2 - Modified for case-sensitive volume compatibility.
   #                  Made temporary file names more distinctive.
   #
   local SFFPArgCount=$#
   local SFFPCurrentDir
   local SFFPCurrentDirTranslated
   local SFFPEachLine
   local SFFPEachPath
   local SFFPFile
   local SFFPLDir
   local SFFPLLinkLS
   local SFFPLLinkPath
   local SFFPLPath
   local SFFPPathOption=-L
   local SFFPSaveIFS="$IFS"
   local SFFPShowAll=false
   local SFFPTempBase=/private/tmp/ShowFullFilePath-`/usr/bin/basename "$0"`-`/bin/date +"%Y%m%d%H%M%S"`
   local SFFPTempFile="$SFFPTempBase.tmp"
   local SFFPTempFile2="$SFFPTempBase-2.tmp"
   /bin/rm -f "$SFFPTempFile" 2>/dev/null
   while [ $SFFPArgCount != 0 ] ; do
      case "$1" in
         -a)
            SFFPShowAll=true
            ;;
         -L|-P)
            SFFPPathOption="$1"
            ;;
         *)
            [ "z$1" = z-e ] && shift
            if [ "$1" ] ; then
               [ -s "$SFFPTempFile" ] && SFFPShowAll=true
               /usr/bin/printf "%s\n" "$1" >>"$SFFPTempFile"
            fi
            ;;
      esac
      shift
      let SFFPArgCount=$SFFPArgCount-1
   done
   [ ! -s "$SFFPTempFile" ] && return
   SFFPCurrentDir=`/bin/pwd`
   SFFPCurrentDirTranslated=`/bin/pwd $SFFPPathOption 2>/dev/null`
   if [ ! -d "$SFFPCurrentDirTranslated" ] ; then
      /bin/rm -f "$SFFPTempFile" 2>/dev/null
      return
   fi
   cd "$SFFPCurrentDirTranslated" 2>/dev/null
   if [ $? != 0 ] ; then
      /bin/rm -f "$SFFPTempFile" 2>/dev/null
      return
   fi
   /usr/bin/printf "" >"$SFFPTempFile2"
   IFS='
'
   for SFFPEachLine in `/bin/cat "$SFFPTempFile" 2>/dev/null` ; do
      cd "$SFFPCurrentDirTranslated" 2>/dev/null
      [ $? != 0 ] && break
      if [ "z$SFFPPathOption" = z-P ] ; then
         SFFPLPath="$SFFPEachLine"
         while [ -L "$SFFPLPath" ] ; do
            [ ! -e "$SFFPLPath" ] && break
            cd "`/usr/bin/dirname "$SFFPLPath" 2>/dev/null`" 2>/dev/null
            [ $? != 0 ] && break
            SFFPLDir=`/bin/pwd -P 2>/dev/null`
            [ ! -d "$SFFPLDir" ] && break
            SFFPLLinkLS=`/bin/ls -ld "$SFFPLPath" 2>/dev/null`
            [ -z "$SFFPLLinkLS" ] && break
            # If link or link target contains " -> " in its name
            if [ "`echo "z$SFFPLLinkLS" | grep ' -> .* -> '`" ] ; then
               SFFPLLinkPath=`/usr/bin/printf "%s" "$SFFPLLinkLS" | /usr/bin/awk -v THESTR="$SFFPLPath -> " '{ match($0,THESTR) ; print substr($0,RSTART+RLENGTH)}'`
            else
               SFFPLLinkPath=`echo "$SFFPLLinkLS" | awk -F " -> " '{print $2}'`
            fi
            # If link target begins with /
            if [ "`/usr/bin/printf "%s" "$SFFPLLinkPath" | grep '^/'`" ] ; then
               SFFPLPath="$SFFPLLinkPath"
            else
               SFFPLPath="$SFFPLDir/$SFFPLLinkPath"
            fi
            [ "`/usr/bin/printf "%s" "$SFFPLPath" | grep '^//'`" ] && SFFPLPath=`echo "$SFFPLPath" | /usr/bin/awk '{print substr($0,2)}'`
         done
         cd "$SFFPCurrentDirTranslated" 2>/dev/null
         [ $? != 0 ] && break
         if [ ! -e "$SFFPLPath" ] ; then
            $SFFPShowAll && continue || break
         fi
         SFFPEachPath="$SFFPLPath"
      else
         SFFPEachPath="$SFFPEachLine"
      fi
      if [ -d "$SFFPEachPath" ] ; then
         cd "$SFFPEachPath" 2>/dev/null
         if [ $? != 0 ] ; then
            $SFFPShowAll && continue || break
         fi
         SFFPFile=""
      elif [ -d "`/usr/bin/dirname "$SFFPEachPath" 2>/dev/null`" ] ; then
         cd "`/usr/bin/dirname "$SFFPEachPath" 2>/dev/null`" 2>/dev/null
         if [ $? != 0 ] ; then
            $SFFPShowAll && continue || break
         fi
         SFFPFile=`basename "$SFFPEachPath" 2>/dev/null`
         [ "z$SFFPFile" = z/ -o "z$SFFPFile" = z. -o "z$SFFPFile" = z.. ] && SFFPFile=""
      elif $SFFPShowAll ; then
         continue
      else
         break
      fi
      SFFPDir=`/bin/pwd $SFFPPathOption 2>/dev/null`
      if [ ! -d "$SFFPDir" ] ; then
         $SFFPShowAll && continue || break
      fi
      SFFPPath="$SFFPDir`[ "z$SFFPFile" != z -a "z$SFFPDir" != z/ -a "z$SFFPDir" != z// ] && echo /`$SFFPFile"
      if [ ! -e "$SFFPPath" -a ! -L "$SFFPPath" ] ; then
         $SFFPShowAll && continue || break
      fi
      [ "`echo "$SFFPPath" | grep '^//'`" ] && SFFPPath=`echo "$SFFPPath" | /usr/bin/awk '{print substr($0,2)}'`
      echo "$SFFPPath" >>"$SFFPTempFile2"
      # If neither option -a nor more than one path was passed, don't show any more names
      ! $SFFPShowAll && break
   done
   IFS=$SFFPSaveIFS
   [ -s "$SFFPTempFile2" ] && /usr/bin/sort -f "$SFFPTempFile2" | /usr/bin/uniq
   /bin/rm -f "$SFFPTempFile" "$SFFPTempFile2" 2>/dev/null
   cd "$SFFPCurrentDir" 2>/dev/null
}

ShowUsage()
{
   # Usage:     ShowUsage
   # Summary:   Displays script usage message and exits script.
   #
   TEMPFILETEMPLATE="/private/tmp/SymantecTemp"
   TEMPFILE="$TEMPFILETEMPLATE`date +"%Y%m%d%H%M%S"`-1"
   ShowVersion >>"$TEMPFILE"
   $AutoRunScript && echo "
Note:    This script requires no user interaction if run as root. You can
         run this script on several machines at once by using Symantec
         Administration Console for Macintosh to send this script." >>"$TEMPFILE"
   echo "
WARNING: This script will remove all files and folders created by Symantec
         Mac OS X products (except Symantec Administration Console and
         LiveUpdate Administration Utility files) and any files within
         those folders. Therefore, you will lose ALL files that reside in
         those folders, including any that you have created.

Usage:   $FullScriptName [options] [volume ...]

Summary: If no option or volume is specified, then all Symantec files are
         removed from the current boot volume, including the invisible
         Symantec files (i.e., AntiVirus QuickScan and Norton FS files),
         and Symantec crontab entries are removed from all users' crontabs;
         otherwise, for each volume specified, all Symantec files and
         Symantec crontab entries will be removed from that volume if no
         options are specified. If files are removed from the current boot
         volume, receipt predelete scripts are run unless -d is specified.

         If a volume does not have OS X installed on it, then only the
         invisible Symantec files are removed from that volume.

         Each volume name may begin with \"/Volumes/\", unless it is \"/\".
         The easiest way to specify a volume is to drag the volume onto the
         Terminal window.

Note:    The Terminal application does not support high ASCII or
         double-byte character entry via keyboard or via drag-and-drop.
         If you want to have files removed from a volume that is not
         the current boot volume and that has a name containing high
         ASCII or double-byte characters, use the -A option.

Options: -A     Remove all Symantec files from all mounted volumes.
                Crontab entries are also removed from the current boot
                volume, but not from other volumes. If a volume does not
                have OS X installed on it, then only the invisible Symantec
                files are removed from that volume.
         -c     Only remove crontab entries from all users' crontabs.
                Nothing is removed from any volume.
         -C     Do not remove crontab entries.
         -d     Bypass the running of receipt predelete scripts. It is best
                to have predelete scripts run for more thorough uninstalls.
         -e     Show errors when run predelete scripts are run. Predelete
                scripts are run only when removing files from the current
                boot volume.
         -f     Do not show files as they are removed. If -f is not
                specified, file names are shown as files are removed.
         -h     Display help.
         -i     Only remove invisible Symantec files.
         -I     Does not remove invisible Symantec files.
         -l     List only files that are currently installed and that
                would be deleted. As of version 6.0.0, contents of folders
                are also shown. Nothing is deleted by this option.
         -L     List all files that $FullScriptName will attempt
                to find and delete. Nothing is deleted by this option.
         -m     Show output from -l, -L, or -R options using more program.
                This is no longer the default action as of version 5.52
                of $FullScriptName.
         -p     Eliminate pause before restarting computer. If option -p
                is not specified, then there is a three second delay
                before the restart occurs.
         -q     Quit script without restarting. This also suppresses
                the prompt to restart.
         -Q     Quits Terminal application when script is done. If
                Terminal is being run by more than one user at once,
                Terminal is not quit.
         -QQ    Quits Terminal application for all users when script is
                done.
         -R     This option is equivalent to the -l option.
         -re    Automatically restart computer when script is done if
                there are Symantec processes and/or kexts in memory and
                there were non-invisible files removed from /.
         -V     Show version only.

Examples:
         $FullScriptName
                Deletes all Symantec files and Symantec crontab entries
                from the boot volume.

         $FullScriptName /Volumes/OS\ 10.2
                Deletes all Symantec files and Symantec crontab entries
                from the volume named \"OS 10.2\".
                Nothing is deleted from the boot volume.

         $FullScriptName Runner /
                Deletes all Symantec files and Symantec crontab entries
                from the volume named \"Runner\" and from the boot volume.

         $FullScriptName -i \"Test Disk\"
                Deletes only invisible Symantec files from the volume named
                \"Test Disk\".

         $FullScriptName -A -re
                Deletes all Symantec files and Symantec crontab entries
                from all mounted volumes that have OS X installed on them.
                Deletes only invisible Symantec files from volumes that do
                not have OS X installed on them.
                Computer is restarted automatically if necessary.

         $FullScriptName -i -A
                Deletes only invisible Symantec files from all volumes.

         $FullScriptName -I
                Deletes all but the invisible Symantec files from the boot
                volume. Crontab entries are removed from the boot volume.

         $FullScriptName -C
                Deletes all Symantec files from the boot volume. No crontab
                entries are removed.

         $FullScriptName -L -A
                Lists all the files that $FullScriptName looks
                for on all volumes. The files may or may not be currently
                installed. Nothing is deleted.

         $FullScriptName -R -A
                Lists only the Symantec files that are currently installed
                on all volumes. Files within existing folders will also be
                shown. Nothing is deleted.

         $FullScriptName -l -i
                Lists the invisible Symantec files that are currently
                installed on the boot volume. Nothing is deleted.

         $FullScriptName -r -A
                Removes only the receipts from /Library/Receipts
                from all mounted volumes.

Note:    You must be root or an admin user to run this script. You can
         simply double-click on $FullScriptName to remove all
         Symantec files and crontab entries from the boot volume.

         The -r option to remove only receipts is no longer available as
         of $FullScriptName version 5.52." >>"$TEMPFILE"
   ShowContents "$TEMPFILE"
   /bin/rm "$TEMPFILE" 2>/dev/null
   ExitScript 0
}

ShowUsageHelp()
{
   # Usage:     ShowUsageHelp [$1]
   # Argument:  $1 = Value with which to exit script (2-255).
   # Summary:   Displays script usage help message and exits script with
   #            value passed to $1 or with 0 if nothing is passed to $1.
   #
   echo
   echo "For help, type:"
   echo
   echo "   $FullScriptName -h"
   echo
   [ -n "$1" ] && exit "$1"
   exit 0
}

ShowVersion()
{
   # Usage:     ShowVersion
   # Summary:   Displays the name and version of script.
   #
   echo "********* $FullScriptName $Version *********"
}

SymantecIsInMemory()
{
   # Usage:     SymantecIsInMemory
   # Summary:   If a Symantec process or kext is in memory, true is shown
   #            and 0 is returned; otherwise, false is shown and 1 is
   #            returned. Sample call:
   #               if `SymantecIsInMemory`
   #
   local SymantecIsInMemoryResult=false
   if [ "`ps -wwax | grep -i "/Application Support/Norton\|/Application Support/Symantec\|/Applications/Norton\|/Applications/Symantec\|PrivateFrameworks/Sym\|/StartupItems/.*Norton\|/StartupItems/NUMCompatibilityCheck\|/StartupItems/SMac Client\|/StartupItems/Sym\|/StartupItems/TrackDelete\|/StartupItems/VolumeAssist" | grep -v " grep -\|/LiveUpdateAdminUtility/"`" ] ; then
      SymantecIsInMemoryResult=true
   else
      kextstat 2>/dev/null 1>&2
      if [ $? -gt 0 ] ; then
         if [ "`kmodstat | grep -i Symantec | grep -v " grep -"`" ] ; then
            SymantecIsInMemoryResult=true
         fi
      elif [ "`kextstat | grep -i Symantec | grep -v " grep -"`" ] ; then
         SymantecIsInMemoryResult=true
      fi
   fi
   echo $SymantecIsInMemoryResult
   ! $SymantecIsInMemoryResult && return 1
   return 0
}

YesEntered()
{
   # Usage:     YesEntered
   # Summary:   Reads a line from standard input. If "y" or "yes"
   #            was entered, true is shown and 0 is returned; otherwise,
   #            false is shown and 1 is returned. The case of letters is
   #            ignored. Sample call:
   #               if `YesEntered`
   #
   read YesEnteredString
   YesEnteredString=`echo "z$YesEnteredString" | awk '{print tolower(substr($0,2))}'`
   if [ "'$YesEnteredString" = "'y" -o "'$YesEnteredString" = "'yes" ] ; then
      echo true
      return 0
   fi
   echo false
   return 1
}

# *** Beginning of Commands to Execute ***

ScriptPath=`ShowFullFilePath "$0" -P`
ScriptDir=`dirname "$ScriptPath"`
if [ $# -eq 0 ] ; then   # If no arguments were passed to script
   # Run script as if it was double-clicked in Finder so that
   # screen will be cleared and quit message will be displayed.
   RunScriptAsStandAlone=true
else
   # Run script in command line mode so that
   # screen won't be cleared and quit message won't be displayed.
   RunScriptAsStandAlone=false
fi
# If script was run from support folder or from within an app bundle
if [ "`echo "$ScriptDir" | grep -e "$LaunchLocationGrepPattern"`" ] ; then
   RunScriptAsStandAlone=false
   RunningFromWithinAppBundleOrSupportFolder=true
else
   RunningFromWithinAppBundleOrSupportFolder=false
fi
if $RunScriptAsStandAlone ; then
   clear >&2
fi
if [ "z$1" = z-h ] ; then
   ShowUsage
elif [ "z$1" = z-V ] ; then
   echo $Version
   ExitScript 0
fi
if [ "`whoami`" != "root" ] ; then   # If not root user,
   if $PublicVersion ; then
      GetAdminPassword true   #    Prompt user for admin password
   else
      ShowVersion >&2
      echo >&2
   fi
   # Run this script again as root
   sudo -p "Please enter your admin password: " "$0" "$@"
   ErrorFromSudoCommand=$?
   # If unable to authenticate
   if [ $ErrorFromSudoCommand -eq 1 ] ; then
      echo "You entered an invalid password or you are not an admin user. Script aborted." >&2
      ExitScript 1
   fi
   if $PublicVersion ; then
      sudo -k   # Make sudo require a password the next time it is run
   fi
   exit $ErrorFromSudoCommand #    Exit so script doesn't run again
fi
NumberOfArgumentsLeft=$#
while [ $NumberOfArgumentsLeft != 0 ] ; do
   AssignOptions "$1"
   shift
   NumberOfArgumentsLeft=`expr $NumberOfArgumentsLeft - 1`
done
# If no volumes were passed to script, the boot volume will be searched
if [ -z "$VolumesToUse" ] ; then
   BootVolumeWillBeSearched=true
fi
if [ $PublicVersion = true -a $CreateFilesRemovedListOnly = false -a \
     $RemoveCrontabEntriesOnly = false -a $RemoveInvisibleFilesOnly = false -a \
     $AutoRunScript = false -a $RunningFromWithinAppBundleOrSupportFolder = false ] ; then
   DetermineAction
fi
if [ $RemoveFromAllVolumes = true -a $CreateFilesRemovedListOnly = false -a $RemoveCrontabEntriesOnly = false -a $RemoveInvisibleFilesOnly = false -a $AutoRunScript = false -a $RunningFromWithinAppBundleOrSupportFolder = false ] ; then
   echo
   printf "Are you sure you want to remove Symantec files from ALL mounted volumes (y/n)? "
   if `YesEntered` ; then
      echo
   else
      echo
      echo "Script aborted. No files were removed."
      ExitScript 0
   fi
fi
SetupCleanup
WillTense=will
if $CreateFilesRemovedListOnly ; then
   echo "Generating a list of files that would be removed by" >&2
   echo "   $FullScriptName (no files will be removed at this time)..." >&2
   WillTense=would
elif $RemoveInvisibleFilesOnly ; then
   echo "Removing AntiVirus QuickScan files and Norton FS files..."
else
   if $BootVolumeWillBeSearched ; then
      if [ $RestartAutomatically = true -a $RemoveCrontabEntriesOnly = false ] ; then
         echo
         echo "Note: Computer will be restarted automatically if necessary."
         echo
      elif $QuitWithoutRestarting ; then
         echo
         echo "Note: This script will automatically quit when finished."
         echo
      fi
   fi
   echo "Removing Symantec files..."
   ! $RemoveInvisibleFiles && echo "Invisible Symantec files will not be deleted."
fi
if $RemoveCrontabEntriesOnly ; then
   echo "Only crontab entries $WillTense be removed."
fi
! $RemoveCrontabEntries && echo "Symantec crontab entries $WillTense not be removed."
! $RemoveInvisibleFiles && echo "AntiVirus QuickScan and Norton FS files $WillTense not be removed."
if $RemoveFromAllVolumes ; then
   VolumesToUse="/
"`ls -d /Volumes/*`
elif ! $RemoveFromOtherVolumes ; then
   VolumesToUse=/
fi
ListOfVolumesToUse=`echo "$VolumesToUse" | sort -f | uniq`
IFS='
'
for EachVolume in $ListOfVolumesToUse ; do
   [ -L "$EachVolume" ] && continue
   FilesFoundOnThisVolume=false
   RemoveAllNortonFiles "$EachVolume"
   if [ $CreateFilesRemovedListOnly = true -a $FilesFoundOnThisVolume = false -a $ListOnlyFilesThatExist = true ] ; then
      echo "No matching files were found on \"`basename "$EachVolume"`\"." >> "$FilesRemovedList"
   fi
done
FinishCleanup
FinishedExitCode=$?
if [ $BootVolumeWillBeSearched = true -a $CreateFilesRemovedListOnly = false ] ; then
   if `SymantecIsInMemory` ; then
      echo
      echo "NOTE: You should now restart the computer to get Symantec processes"
      echo "      and kexts out of memory."
      RestartComputer
   elif [ -e /Library/StartupItems/CleanUpSymWebKitUtils ] ; then
      echo
      echo "NOTE: You should now restart the computer to have CleanUpSymWebKitUtils"
      echo "      finish removing SymWebKitUtils.framework."
      RestartComputer
   fi
fi
ExitScript $FinishedExitCode

# *** End of Commands to Execute ***
