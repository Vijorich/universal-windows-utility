@echo off & setlocal EnableDelayedExpansion
@title = UberCleaner

SET v=1.5

verify on
cd /d "%~dp0"
COLOR A
rem													Startup check
rem ========================================================================================================
rem Created by Vijorich


:StartupCheck
title = �஢�ઠ...

for /f "tokens=6 delims=[]. " %%G in ('ver') Do (
	set _build=%%G
	if "%%G" lss "10586" (
		call :message "�� ����� windows �� �����ন������!"
		pause
		exit
	)
) 

for /f %%i in ('PowerShell -Command "[Enum]::GetNames([Net.SecurityProtocolType]) -contains 'Tls12'"') do (
	if "%%i" == "False" (
		call :message "��� ����� PowerShell �� �����ন���� TLS1.2 !"
		echo:  ������� PowerShell https://aka.ms/PSWindows
		pause
		exit
	)
)

rem													Updater
rem ========================================================================================================
rem Created by Vijorich

:Updater
title = ���� ����������...
set _myname=%~n0
set _myparams=%*

if not "!_myname:~0,9!"=="[updated]" (
	if exist "[updated]!_myname!.bat" (
		fc "[updated]!_myname!.bat" "!_myname!.bat.old" >nul
		if not "!errorlevel!"=="0" (
			ren "[updated]!_myname!.bat" "[updated]!_myname!.bat.old"
			del /f "!_myname!.bat.old" "[updated]!_myname!.bat.old"
			call :download https://raw.githubusercontent.com/Vijorich/Uber-anal/main/UpdateLog.txt "UpdateLog.txt"
			call :message "Uber cleaner �������� �� ���ᨨ !v!"
			title = ���᮪ ����������!
			type UpdateLog.txt
			del /f "UpdateLog.txt"
			timeout 26 >nul
			cls && goto ConfigCheck
		)
		ren "[updated]!_myname!.bat" "[updated]!_myname!.bat.old"
		del /f "!_myname!.bat.old" "[updated]!_myname!.bat.old"
		cls && goto ConfigCheck
	)
	call :message "��� ���������� UC..."
	call :download https://raw.githubusercontent.com/Vijorich/Uber-anal/main/Main.bat "[updated]%_myname%.bat"
	if exist "[updated]!_myname!.bat" (
	
		fc "[updated]!_myname!.bat" "!_myname!.bat" >nul
		if "!errorlevel!"=="0" (
			
			del /f "[updated]!_myname!.bat"
			
			cls && goto ConfigCheck
		)
		start /min cmd /c "[updated]!_myname!.bat" !_myparams!
	) else (
		cls && goto ConfigCheck
	)
) else (
	if "!_myname!"=="[updated]" (
		call :message "�� �� ����� ���� ����� � ������� 䠩� "[updated]" � ��� � �ਯ� �� �ᯮ�짮���� ������?"
		timeout 300 >nul
	) else (
		if exist "!_myname:~9!.bat" ( ren "!_myname:~9!.bat" "!_myname:~9!.bat.old" )
		copy /b /y "!_myname!.bat" "!_myname:~9!.bat"
		start cmd /c "!_myname:~9!.bat" !_myparams!
	)
)
exit /b

rem													Config check
rem ========================================================================================================
rem Created by Vijorich


:ConfigCheck
title = ��� ���䨣 ���⪨...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v StateFlags0777"
cls
if %errorlevel% == 0 (echo ���䨣 ���⪨ ������) else (call :CleanerSetup)


rem													System config
rem ========================================================================================================
rem Created by Vijorich


:GatherInfo
title = ������ ���ଠ��...

for /f %%a in ('powershell -command "Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | Foreach {[int](($_.Sum/1GB))}"') do (set _memory=%%a)

if %_build% GEQ 22000 (
	set _winver=11
) else (
	set _winver=10
)


call :message

rem													Main menu
rem ========================================================================================================
rem Created by Vijorich


:MainMenu
setlocal EnableDelayedExpansion
title = UberCleaner !v!
setlocal DisableDelayedExpansion

echo		1. ���� ���⪨
echo		2. �ਬ����� .reg 䠩��
echo		3. �몫���� १�ࢭ�� �࠭����
echo		4. ����ந�� mmagent
echo		5. �ਬ����� �奬� ��⠭��
echo		6. �⪫���� ०�� ����ୠ樨
echo		9. ��� �� �ணࠬ��
echo		0. �����ঠ�� ����!
call :message
choice /C:12345690 /N
set _erl=%errorlevel%
if %_erl%==1 cls && call :message && goto CleanupMenu
if %_erl%==2 cls && call :message && goto RegEditMenu
if %_erl%==3 cls && goto offReservedStorage
if %_erl%==4 cls && call :message "����ࠨ���.." && goto MmagentSetup
if %_erl%==5 cls && call :message && goto PowerSchemesMenu
if %_erl%==6 cls && powercfg -h off && call :message "����� ����ୠ樨 �⪫�祭"
if %_erl%==7 exit 
if %_erl%==8 cls && call :message "�� ����� ᤥ���� ���⭮ ����� uber cleaner v1.4!" && goto CheerUpAuthorMenu
goto MainMenu

:offReservedStorage
call :message "�������.."
start /wait /min %SystemRoot%\System32\Dism.exe /Online /Set-ReservedStorageState /State:Disabled
cls
call :message "����ࢭ�� �࠭���� �⪫�祭�!"
goto MainMenu


rem													Cleanup Menu
rem ========================================================================================================
rem Created by Vijorich


:CleanupMenu
title = ���� ���⪨
echo		1. �㦭� �� ��� ���⪠?
echo		2. ������ ~1min-5min
echo		3. ��������㥬�� ~5min-1hour
echo		9. �������� � ������� ����
echo		0. ��? ����? �㤠? .���
call :message
choice /C:12390 /N
set _erl=%errorlevel%
if %_erl%==1 cls && goto checkUp
if %_erl%==2 cls && goto fastCleanup
if %_erl%==3 cls && goto recommendedCleanup
if %_erl%==4 cls && call :message && goto MainMenu
if %_erl%==5 cls && call :message && goto MainMenu
goto CleanupMenu

:checkUp
title = ������ ��� �� ������, ��� � 祬 �����
call :message "����� ��ᬮ�ਬ.."
Dism.exe /Online /Cleanup-Image /AnalyzeComponentStore
Pause
cls
call :message && goto MainMenu

:fastCleanup
setlocal DisableDelayedExpansion
title = ����-���-��� �㪠 ��� ��� ���� �㦭� ����� ����� ࠧ-ࠧ-ࠧ! ����! �����! ����!
call :message "����, ���, ���"

Start /min /high .\cleanmgrplus\Cleanmgr+.exe /cp .\cleanmgrplus\std.cleanup
CD %WINDIR%\Temp && RMDIR /S /Q .  >nul 2>&1
CD %SYSTEMDRIVE%\Temp && RMDIR /S /Q .  >nul 2>&1
CD %Temp% && RMDIR /S /Q .  >nul 2>&1
CD %Tmp% && RMDIR /S /Q .  >nul 2>&1
DEL /F /S /Q %SYSTEMDRIVE%\*.log >nul 2>&1
DEL /F /S /Q %SYSTEMDRIVE%\*.bak >nul 2>&1
DEL /F /S /Q %SYSTEMDRIVE%\*.gid >nul 2>&1
start /min /wait WSReset.exe >nul 2>&1
taskkill /f /im WinStore.App.exe >nul 2>&1
ipconfig /release >nul 2>&1
arp -d * >nul 2>&1
nbtstat -R >nul 2>&1
ipconfig /flushdns >nul 2>&1
ipconfig /renew >nul 2>&1
endlocal
cls
call :message "��⮢�!" && goto MainMenu

:recommendedCleanup
setlocal DisableDelayedExpansion
title = �� ���, ���? ��� � ��� ������-� �����? ��, ᮢᥬ �㤠�, �� ��? ������ ���, ��� � ��� �����-�, ��! 
call :message "����, ���, ���"

Start /min /high .\cleanmgrplus\Cleanmgr+.exe /cp .\cleanmgrplus\max.cleanup
CD %WINDIR%\Temp && RMDIR /S /Q . >nul 2>&1
CD %SYSTEMDRIVE%\Temp && RMDIR /S /Q . >nul 2>&1
CD %Temp% && RMDIR /S /Q . >nul 2>&1
CD %Tmp% && RMDIR /S /Q . >nul 2>&1
CD %WINDIR%\Prefetch && RMDIR /S /Q . >nul 2>&1
CD %WINDIR%\SoftwareDistribution\Download && RMDIR /S /Q . >nul 2>&1
DEL /F /S /Q %SYSTEMDRIVE%\*.log >nul 2>&1
DEL /F /S /Q %SYSTEMDRIVE%\*.bak >nul 2>&1
DEL /F /S /Q %SYSTEMDRIVE%\*.gid >nul 2>&1
start /min /wait WSReset.exe >nul 2>&1
taskkill /f /im WinStore.App.exe >nul 2>&1
ipconfig /release >nul 2>&1
arp -d * >nul 2>&1
nbtstat -R >nul 2>&1
ipconfig /flushdns >nul 2>&1
ipconfig /renew >nul 2>&1
Dism /online /Cleanup-Image /StartComponentCleanup /ResetBase >nul 2>&1
Dism /online /Cleanup-Image /SPSuperseded >nul 2>&1
vssadmin delete shadows /all /quiet >nul 2>&1
echo Y | chkdsk /f /r /b
shutdown /r /t 60 /c "��१ ������ ��१���㧪�, ��࠭�� �� �����!"
endlocal
exit

:cleanupInfo
start .\cleanmgrplus\readme.txt
call :message && goto CleanupMenu


rem													Reg Edit Menu
rem ========================================================================================================
rem Created by Vijorich


:RegEditMenu
title = ���� �ਬ��� ॣ � ����� ���� ��� �� �뢠��
echo		1. ���� �ਬ����� ४�����㥬� .reg 䠩��
echo		2. �ਬ����� ����� ��筮 (��� �� ���ᨨ 設���)
echo		3. ���쪮 ��� 10 設���
echo		4. ���쪮 ��� 11 設���
echo		9. �������� � ������� ����!
call :message
choice /C:12349 /N
set _erl=%errorlevel%
if %_erl%==1 cls && goto RegEditFullReg
if %_erl%==2 cls && call :message && goto RegEditFirstPage
if %_erl%==3 cls && call :message && goto RegEditWindows10Only
if %_erl%==4 cls && call :message && goto RegEditWindows11Only
if %_erl%==5 cls && call :message && goto MainMenu
goto RegEditMenu


:RegEditFullReg

if %_build% GEQ 22000 (
	call :regEditImport "\Windows 11 Only\w11 context menu fix" "\Windows 11 Only\w11 notifications" "\Windows 11 Only\w11 priority" "\Windows 11 Only\w11 share item"
    call :regEditTrustedImport "\Windows 11 Only\w11 defender X"
	cls && call :message "�ਬ���� ��騥 .ॣ 䠩�� � ��� 設��� 11!" && goto MainMenu
) else (
	call :regEditImport "\Windows 10 Only\w10 3d objects" "\Windows 10 Only\w10 newnetworkwindowoff" "\Windows 10 Only\w10 notifications" "\Windows 10 Only\w10 priority" "\Windows 10 Only\w10 share item" "\Windows 10 Only\w10 showsecondsinsystemclock"
    call :regEditTrustedImport "\Windows 10 Only\w10 defender X"
	cls && call :message "�ਬ���� ��騥 .ॣ 䠩�� � ��� 設��� 10!" && goto MainMenu
)

:regEditFullRegForAll
call :regEditImport "appcompability" "attachmentmanager" "autoupdate" "backgroundapps" "filesystem" "explorer" "driversearching" "cloudcontent"
call :regEditImport "systemprofile" "search" "regionalformats" "menushowdelay" "maintenance" "latestclr" "inspectre" "gamedvr" "fse"
call :regEditImport "uac" "telemetry" "systemrestore"
call :regEditTrustedImport "networkfolder X"

:RegEditFirstPage
title = ��ࢠ� ��࠭��
echo		1. �⪫���� ⥫������ � ��祥 (�. � ��� 䠩��)
echo		2. �⪫���� �� ��⮮���������
echo		3. �⪫�祭�� ��������⮢ ᮢ���⨬���
echo		4. �⪫�祭�� 䮭���� �ਫ������
echo		5. ��⨬����� 䠩����� ��⥬�
echo		6. ������� �㭪�� largesystemcache
echo		7. �⪫�祭�� ��� ���
echo		8. �������� ��࠭��
echo		9. ��������
echo		0. �� �.���
call :message
choice /C:1234567890 /N
set _erl=%errorlevel%
if %_erl%==1 cls && goto telemetry
if %_erl%==2 cls && goto autoUpdate
if %_erl%==3 cls && goto appCompability
if %_erl%==4 cls && goto backgroundApps
if %_erl%==5 cls && goto filesystemOptimization
if %_erl%==6 cls && goto largesystemCache
if %_erl%==7 cls && goto gameDVR
if %_erl%==8 cls && call :message && goto RegEditSecondPage
if %_erl%==9 cls && call :message && goto RegEditMenu
if %_erl%==10 cls && goto regEditInfo
goto RegEditFirstPage

:telemetry
call :regEditImport "inspectre" "uac" "maintenance" "attachmentmanager" "telemetry"
call :message "��窨 �⪫�祭�!"
goto RegEditFirstPage

:autoUpdate
call :regEditImport "autoupdate" "cloudcontent" "driversearching"
call :message "��⮮��������� �⪫�祭�!"
goto RegEditFirstPage

:appCompability
call :regEditImport "appcompability"
call :message "���������� ᮢ���⨬��� �⪫�祭�!"
goto RegEditFirstPage

:backgroundApps
call :regEditImport "backgroundapps"
call :message "������ �ਫ������ �⪫�祭�!"
goto RegEditFirstPage

:filesystemOptimization
call :regEditImport "filesystem" "explorer"
call :regEditTrustedImport "networkfolder X"
call :message "�������� ��⥬� ��⨬���஢���!"
goto RegEditFirstPage

:largesystemCache
call :regEditImport "largesystemcache"
call :message "�㭪�� largesystemcache ����祭�!"
goto RegEditFirstPage

:gameDVR
call :regEditImport "gamedvr"
call :message "��� ��� �⪫�祭!"
goto RegEditFirstPage

:regEditInfo
start .\regpack\readme.txt
call :message && goto RegEditFirstPage


:RegEditSecondPage
title = ���� ��࠭��
echo		1. �����饭�� ��ண� ��ᬮ��騪� ��
echo		2. ����� ����প� ������ ����襪
echo		3. ��⠭����� ��ଠ��� �ଠ�� ����, �६��� � �������� ��⥬� 
echo		4. �⪫���� ��� ���� � ���� ���᪠
echo		5. �����襭�� ��業� �ᯮ��㥬�� ����ᮢ ��� ���-�ਮ�� �����
echo		6. �⪫�祭�� �祪 ����⠭�������
echo		7. ������쭮� �⪫�祭�� ��⨬���樨 �� ���� ��࠭
echo		8. �������� ��࠭��
echo		9. �।���� ��࠭��
echo		0. ��������
call :message
choice /C:1234567890 /N
set _erl=%errorlevel%
if %_erl%==1 cls && goto backOldPhotoViewer
if %_erl%==2 cls && goto menuShowDelay
if %_erl%==3 cls && goto regionalFormats
if %_erl%==4 cls && goto search
if %_erl%==5 cls && goto systemProfile
if %_erl%==6 cls && goto systemRestore
if %_erl%==7 cls && goto fse
if %_erl%==8 cls && call :message && goto RegEditThirdPage
if %_erl%==9 cls && call :message && goto RegEditFirstPage
if %_erl%==10 cls && call :message && goto RegEditMenu
goto RegEditSecondPage

:backOldPhotoViewer
call :regEditImport "backoldphotoviewer"
call :message "���� ��ᬮ��騪 �� ������!"
goto RegEditSecondPage

:menuShowDelay
call :regEditImport "menushowdelay"
call :message "����প� ������ ���� �࠭�!"
goto RegEditSecondPage

:regionalFormats
call :regEditImport "regionalformats"
call :message "��ଠ�� ��⠭�������!"
goto RegEditSecondPage

:search
call :regEditImport "search"
call :message "���-���� �⪫�祭!"
goto RegEditSecondPage

:systemProfile
call :regEditImport "systemprofile"
call :message "��業� �ᯮ��㥬�� ����ᮢ 㬥��襭!"
goto RegEditSecondPage

:systemRestore
call :regEditImport "systemrestore"
call :message "��窨 ����⠭������� �⪫�祭�!"
goto RegEditSecondPage

:fse
call :regEditImport "fse"
call :message "��⨬����� �� ���� ��࠭ �⪫�祭�!"
goto RegEditSecondPage


:RegEditThirdPage
title = ����� ��࠭��
echo		1. �ᯮ�짮����� ⮫쪮 ��᫥���� ���ᨩ .NET
echo		2. �⪫�祭�� ��� ��ᯫ��⮢, �஬� CFG
echo		3. �⪫�祭�� ࠡ��� �㦡 microsoft edge
echo		8. �।���� ��࠭��
echo		9. ��������
call :message
choice /C:12389 /N
set _erl=%errorlevel%
if %_erl%==1 cls && goto latestCLR
if %_erl%==2 cls && goto exploitsCFG
if %_erl%==3 cls && goto exploitsCFG
if %_erl%==4 cls && call :message && goto RegEditSecondPage
if %_erl%==5 cls && call :message && goto RegEditMenu
goto RegEditThirdPage

:latestCLR
call :regEditImport "latestclr"
call :message "�ᯮ�짮����� ⮫쪮 ��᫥���� ���ᨩ .NET ����祭�!"
goto RegEditThirdPage

:exploitsCFG
call :regEditImport "exploitscfg"
call :message "�� ��ᯫ����, �஬� CFG �⪫�祭�"
goto RegEditThirdPage

:edge
call :regEditImport "edge"
call :message "� ���! ��� 㡨�� edge("
goto RegEditThirdPage

:RegEditWindows10Only
title = ���쪮 ��� 10 設���
echo		1. ��������� �⪫���� 㢥�������� � 業�� 㢥��������
echo		2. �������� �ਮ��� ��� ���
echo		3. ������� "��ࠢ���" �� ���⥪�⭮�� ����
echo		4. ������� ����� "��ꥬ�� ��ꥪ��"
echo		5. ��������� �⪫���� ��䥭���, smartscreen, ��ᯫ����
echo		6. �뢥�� ᥪ㭤� � ��⥬�� ���
echo		7. �⪫���� 㢥�������� �� ������祭�� ����� ��
echo		9. ��������
call :message
choice /C:12345679 /N
set _erl=%errorlevel%
if %_erl%==1 cls && goto windows10Notifications
if %_erl%==2 cls && goto windows10Priority
if %_erl%==3 cls && goto windows10ShareItem
if %_erl%==4 cls && goto windows103dObjects
if %_erl%==5 cls && goto windows10Defender
if %_erl%==6 cls && goto windows10ShowSecondsInSystemClock
if %_erl%==7 cls && goto windows10NewnetworkWindow
if %_erl%==8 cls && call :message && goto RegEditMenu
goto RegEditWindows10Only

:windows10Notifications
call :regEditImport "\Windows 10 Only\w10 notifications"
call :message "����������� � 業�� 㢥�������� �⪫�祭�!"
goto RegEditWindows10Only

:windows10Priority
call :regEditImport "\Windows 10 Only\w10 priority"
call :message "�ਮ��� ��� ��� 㢥��祭!"
goto RegEditWindows10Only

:windows10ShareItem
call :regEditImport "\Windows 10 Only\w10 share item"
call :message "�㭪� ��ࠢ��� 㤠���!"
goto RegEditWindows10Only

:windows103dObjects
call :regEditImport "\Windows 10 Only\w10 3d objects"
call :message "�㭪� ��ꥬ�� ��ꥪ�� 㤠���!"
goto RegEditWindows10Only

:windows10Defender
call :regEditTrustedImport "\Windows 10 Only\w10 defender X"
call :message "���� ����!"
goto RegEditWindows10Only

:windows10ShowSecondsInSystemClock
call :regEditImport "\Windows 10 Only\w10 showsecondsinsystemclock"
call :message "���㭤� � ��� ����祭�!"
goto RegEditWindows10Only

:windows10NewnetworkWindow
call :regEditImport "\Windows 10 Only\w10 newnetworkwindowoff"
call :message "����������� �� ������祭�� ����� �� �몫�祭�!"
goto RegEditWindows10Only


:RegEditWindows11Only
title = ���쪮 ��� 11 設���
echo		1. ��䨪��� ����� ���⥪�⭮� ����
echo		2. �������� �ਮ��� ��� ���
echo		3. ������� "��ࠢ���" �� ���⥪�⭮�� ����
echo		4. ��������� �⪫���� ��䥭���, smartscreen, ��ᯫ����
echo		5. ��������� �⪫���� 㢥��������
echo		9. ��������
call :message
choice /C:123459 /N
set _erl=%errorlevel%
if %_erl%==1 cls && goto windows11ContextMenuFix
if %_erl%==2 cls && goto windows11Priority
if %_erl%==3 cls && goto windows11ShareItem
if %_erl%==4 cls && goto windows11Defender
if %_erl%==5 cls && goto windows11Notifications
if %_erl%==6 cls && call :message && goto RegEditMenu
goto RegEditWindows11Only

:windows11ContextMenuFix
call :regEditImport "\Windows 11 Only\w11 context menu fix"
call :message "����� ���⥪�⭮� ���� ��ࠢ����!"
goto RegEditWindows11Only

:windows11Priority
call :regEditImport "\Windows 11 Only\w11 priority"
call :message "�ਮ��� ��� ��� 㢥��祭!"
goto RegEditWindows11Only

:windows11ShareItem
call :regEditImport "\Windows 11 Only\w11 share item"
call :message "�㭪� ��ࠢ��� 㤠���!"
goto RegEditWindows11Only

:windows11Defender
call :regEditTrustedImport "\Windows 11 Only\w11 defender X"
call :message "���� ����!"
goto RegEditWindows11Only

:windows11Notifications
call :regEditImport "\Windows 11 Only\w11 notifications"
call :message "����������� �⪫�祭�!"
goto RegEditWindows11Only


rem													mmagent
rem ========================================================================================================
rem Created by Vijorich


:MmagentSetup
title = ����� �����, �� ����ன�� sysmain ����

call :message "�� 祬 � ��� ��⠭������� ��⥬�?"
echo 1) SSD
echo 1) HDD
choice /C:12 /N
set _erl=%errorlevel%
if %_erl%==1 cls && call :message "����ࠨ���.." && goto MmagentSetupSSD
if %_erl%==2 cls && call :message "����ࠨ���.." && goto MmagentSetupHDD

:MmagentSetupHDD
call :regEditImport "prefetcher"
cls && call :message "����஥�� ��� hdd!" && goto MainMenu

:MmagentSetupSSD
set /a _mmMemory=%_memory%*32

if %_mmMemory% LEQ 128 (
	set _mmMemory=128
) else (
	if %_mmMemory% GEQ 1024 (
		set _mmMemory=1024
	)
)

if %_build% GEQ 22000 (
	call :powershell "enable-mmagent -ApplicationPreLaunch" "enable-mmagent -MC" "disable-mmagent -PC" "set-mmagent -MaxOperationAPIFiles %_mmMemory%"
	cls && call :message "����஥�� ��� ssd, windows 11!" && goto MainMenu
) else (
	call :powershell "enable-mmagent -ApplicationPreLaunch" "disable-mmagent -MC" "disable-mmagent -PC" "set-mmagent -MaxOperationAPIFiles %_mmMemory%"
	cls && call :message "����஥�� ��� ssd, windows 10!" && goto MainMenu
)


rem													Power Schemes
rem ========================================================================================================
rem Created by Vijorich


:PowerSchemesMenu
title = �奬�� �奬�� ����뢠��
echo		1. ������஢��� �奬�, ����� �㦭�� � 㤠���� ���ᯮ����騥��
echo		2. ������஢��� �奬� � ����� �㦭��
echo		3. ������� ���ᯮ����騥��
echo		9. �������� � ������� ����
call :message
choice /C:1239 /N
set _erl=%errorlevel%
if %_erl%==1 cls && goto powerSchemesMix
if %_erl%==2 cls && goto powerSchemesImport
if %_erl%==3 cls && goto powerSchemesDelete
if %_erl%==4 cls && call :message && goto MainMenu
goto PowerSchemesMenu

:powerSchemesMix
call :message "�롥�� �㦭�� �奬�!"
call :applyPowerSchemes
type .\powerschemes\readme.txt
pause
for /f "skip=2 tokens=2,4 delims=:()" %%G in ('powercfg -list') do (powercfg -delete %%G)
cls
call :message "��⮢�!"
goto MainMenu

:powerSchemesImport
call :message "�롥�� �㦭�� �奬�!"
call :applyPowerSchemes
type .\powerschemes\readme.txt
pause
cls
call :message "��⮢�!"
goto MainMenu

:powerSchemesDelete
for /f "skip=2 tokens=2,4 delims=:()" %%G in ('powercfg -list') do (powercfg -delete %%G)
cls
call :message "������!" 
goto MainMenu

:applyPowerSchemes
MD %Temp%\schemes > nul

robocopy .\powerschemes %Temp%\schemes diohas_D.pow >nul
robocopy .\powerschemes %Temp%\schemes diohas_MS.pow >nul
robocopy .\powerschemes %Temp%\schemes diohas_U.pow >nul
robocopy .\powerschemes %Temp%\schemes diohas_Ultra.pow >nul
robocopy .\powerschemes %Temp%\schemes Shingeki_no_Windows.pow >nul

powercfg /import %Temp%\schemes\diohas_D.pow >nul
powercfg /import %Temp%\schemes\diohas_MS.pow >nul
powercfg /import %Temp%\schemes\diohas_U.pow >nul
powercfg /import %Temp%\schemes\diohas_Ultra.pow >nul
powercfg /import %Temp%\schemes\Shingeki_no_Windows.pow >nul

start powercfg.cpl
CD %Temp% && RMDIR /S /Q schemes
goto :eof

rem													Functions
rem ========================================================================================================
rem Created by Vijorich


:download
(
	PowerShell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%~1', '%~2')"
) >nul 2>&1
goto :eof

:message
setlocal DisableDelayedExpansion
echo:
echo:  %~1
echo:
endlocal
goto :eof

:powerShell
(
powershell -executionpolicy bypass -command "%~1" ; "%~2" ; "%~3" ; "%~4" ; "%~5" 
) >nul 2>&1
goto :eof

:regEditImport
setlocal DisableDelayedExpansion
regedit /s ".\regpack\%~1.reg" ; ".\regpack\%~2.reg" ; ".\regpack\%~3.reg" ; ".\regpack\%~4.reg" ; ".\regpack\%~5.reg" ; ".\regpack\%~6.reg" ; ".\regpack\%~7.reg" ; ".\regpack\%~8.reg" ; ".\regpack\%~9.reg"
endlocal
goto :eof

:regEditTrustedImport
setlocal DisableDelayedExpansion
".\regpack\PowerRun\PowerRun.exe" Regedit.exe /S ".\regpack\%~1.reg" ; ".\regpack\%~2.reg" ; ".\regpack\%~3.reg"
endlocal
goto :eof


rem													Cheers
rem ========================================================================================================
rem Created by Vijorich


:CheerUpAuthorMenu
title = � ��ࠫ��!
echo 1. ����� ᬥ��� ���� ॡ�⠬ �� �孮����!
echo 2. ��饪�⠢ ������ �����᪨ �� youtube ������
echo.
echo ������� ���� �� �������:
echo 3. donationalerts
echo 4. donatepay
echo.
echo ����� �����ন���� �� 15 �㡫�� � �����!: 
echo 5. boosty
echo.
echo 9. �������� � ������� ����
call :message
choice /C:123459 /N
set _erl=%errorlevel%
if %_erl%==1 cls && start https://discord.gg/mB6DprqmR9 && call :message
if %_erl%==2 cls && start https://www.youtube.com/channel/UCtTvQl-7zOJjTZw0s2m82aQ && call :message
if %_erl%==3 cls && start https://www.donationalerts.com/r/vijorich && call :message
if %_erl%==4 cls && start https://new.donatepay.ru/@906344 && call :message
if %_erl%==5 cls && start https://boosty.to/vijor && call :message
if %_erl%==6 cls && call :message && goto MainMenu
goto CheerUpAuthorMenu