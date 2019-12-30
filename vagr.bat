@echo off

set vbox="C:\Program Files\Oracle\VirtualBox\VBoxManage"

set file_dir=%~dp0
set lib=%file_dir%\lib
set ssh_path=%file_dir%\lib\ssh\bin

set valid_commands="add" "init" "destroy" "rename" "up" "pause" "resume" "down" "reload" "add_shared" "setup_shared" "del_shared" "add_port" "del_port" "ssh" "list" "manual"

set arg1=%1
goto CHECK_ARGS

:CHECK_ARGS 
if "%arg1%"=="" (goto PRINT_ERROR) else (goto CHECK_VALID)
exit /b

:CHECK_VALID
set valid=false
for %%a in (%valid_commands%) do (
	if "%arg1%" == %%a (
		if "%arg1%" == "add" (goto ADD_VM)
		if "%arg1%" == "init" (goto SETUP)
		if "%arg1%" == "destroy" (goto REMOVE_VM)
		if "%arg1%" == "rename" (goto RENAME_VM)
		if "%arg1%" == "up" (goto START_VM)
		if "%arg1%" == "pause" (goto PAUSE_VM)
		if "%arg1%" == "resume" (goto RESUME_VM)
		if "%arg1%" == "down" (goto STOP_VM)
		if "%arg1%" == "reload" (goto RELOAD_VM)
		if "%arg1%" == "add_shared" (goto ADD_SHARE)
		if "%arg1%" == "del_shared" (goto DEL_SHARE)
		if "%arg1%" == "add_port" (goto ADD_PORT)
		if "%arg1%" == "del_port" (goto DELETE_PORT)
		if "%arg1%" == "ssh" (goto SSH)
		if "%arg1%" == "list" (goto LIST)
		if "%arg1%" == "manual" (goto MANUAL)
	)
)
if "%valid%" == "false" (
	goto PRINT_ERROR
	exit /b
)

:ADD_VM
set arg2=%2
if "%arg2%" == "" (goto PRINT_ERROR)
echo Adding Vagr machine ... 
%vbox% import "%arg2%"
exit /b

:SETUP
set arg2=%2
if "%arg2%" == "" (
	echo No Vagr machine specified but still setting up.
	%lib%\write_vagr -m ""
) else (
	%vbox% modifyvm "%arg2%" --nic1 nat
	%vbox% modifyvm "%arg2%" --natpf1 "ssh, tcp, 127.0.0.1, 2222, , 22"
	%lib%\write_vagr -m %arg2% -p "ssh tcp 127.0.0.1 2222 _ 22"

	%vbox% sharedfolder add "%arg2%" --name home --hostpath "%cd%" --automount
	%lib%\write_vagr -e -f "%cd%"
	echo Vagr machine all set up!
	echo 	User: buddy
	echo 	Password: 1234567890
	echo 	IP Address: 127.0.0.1
	echo 	Port: 2222
	echo 	Current folder "%file_dir%": in /media/sf_home
)
exit /b

:REMOVE_VM
tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" (
	del "tasklist.txt"
	echo Cannot remove Vagr machine because it is currently running.
	exit /b
) else (
	del "tasklist.txt"
	echo Removing Vagr machine...
	%lib%\execute_vagr --remove 
	del Vagr.json 
	exit /b
)

:RENAME_VM
set arg2=%2
if "%arg2%" == "" (goto PRINT_ERROR)

set arg3=%3
if "%arg3%" == "" (goto PRINT_ERROR)

tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" (
	del "tasklist.txt"
	echo Cannot rename Vagr machine because it is currently running.
	exit /b
) else (
	del "tasklist.txt"
	echo Renamed %arg2% to %arg3%
	%vbox% modifyvm "%arg2%" --name "%arg3%"
	%lib%\write_vagr -e -m %arg3%
	exit /b
)


:START_VM
tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" (
	del "tasklist.txt"
	echo Cannot start because Vagr machine already running.
	exit /b
) else (
	del "tasklist.txt"
	echo Starting VM... 
	echo 	User: buddy
	echo 	Password: 1234567890
	echo 	IP Address: 127.0.0.1
	echo 	Port: 2222
	%lib%\execute_vagr --start
	exit /b
)

:PAUSE_VM
tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" (
	del "tasklist.txt"
	echo Pausing VM...
	%lib%\execute_vagr --pause
	exit /b
) else (
	del "tasklist.txt"
	echo Cannot pause because Vagr machine is not running.
	exit /b
)

:RESUME_VM
tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" (
	del "tasklist.txt"
	echo Resuming VM...
	%lib%\execute_vagr --resume
	exit /b
) else (
	del "tasklist.txt"
	echo Cannot resume because Vagr machine is not running.
	exit /b
)

:STOP_VM
tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" (
	del "tasklist.txt"
	echo Stopping VM... 
	%lib%\execute_vagr --stop
	exit /b
) else (
	del "tasklist.txt"
	echo Cannot stop because Vagr machine is not running.
	exit /b
)

:RELOAD_VM
tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" (
	del "tasklist.txt"
	echo Reloading VM...
	%lib%\execute_vagr --reload 
	exit /b
) else (
	del "tasklist.txt"
	echo Cannot reload because Vagr machine is not running.
	exit /b
)

:ADD_SHARE
set arg2=%2
if "%arg2%" == "" (goto PRINT_ERROR)

set arg3=%~3
if "%arg3%" == "" (goto PRINT_ERROR)

tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" (
	del "tasklist.txt"
	echo Cannot add %arg2% folder because Vagr machine is running.
	exit /b
) else (
	del "tasklist.txt"
	%lib%\execute_vagr --add_shared %arg2% "%arg3%"
	%lib%\write_vagr -e -f %arg2%
	exit /b 
)

:DEL_SHARE
set arg2=%2
if "%arg2%" == "" (goto PRINT_ERROR)

tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" ( 
	del "tasklist.txt"
	echo Cannot remove %arg2% folder because Vagr machine is running.
	exit /b
) else (
	del "tasklist.txt"
	%lib%\execute_vagr --del_shared %arg2%
	exit /b 
)

:ADD_PORT
set arg2=%2
set arg3=%3
set arg4=%4
set arg5=%5
set arg6=%6

tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" ( 
	del "tasklist.txt"
	echo Cannot add port because Vagr machine is running.
	exit /b
) else (
	del "tasklist.txt"
	if "%arg2%" == "" (
		goto PRINT_ERROR
	) else if "%arg3%" == "" (
		goto PRINT_ERROR
	) else if "%arg4%" == "" (
		goto PRINT_ERROR
	) else if "%arg5%" == "" (
		%lib%\write_vagr -e -p "%arg2% tcp _ %arg3% _ %arg4%"
		%lib%\execute_vagr --add_port "%arg2%, tcp, , %arg3%, , %arg4%"
	) else if "%arg6%" == "" (
		%lib%\write_vagr -e -p "%arg2% tcp %arg3% %arg4% _ %arg5%"
		%lib%\execute_vagr --add_port "%arg2%, tcp, %arg3%, %arg4%, ,%arg5%"
	) else (
		%lib%\write_vagr -e -p "%arg2% tcp _ %arg3% %arg4% %arg5% %arg6%"
		%lib%\execute_vagr --add_port "%arg2%, tcp, %arg3%, %arg4%, %arg5%, %arg6%"
	)
	exit /b
)

:DELETE_PORT
set arg2=%2
if "%arg2%" == "" (goto PRINT_ERROR)

tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" ( 
	del "tasklist.txt"
	echo Cannot delete port because Vagr machine is running.
	exit /b
) else (
	del "tasklist.txt"
	%lib%\execute_vagr --delete_port %arg2%
	exit /b
)

:SSH
tasklist > "tasklist.txt"
findstr "VBoxHeadless.exe" "tasklist.txt"> NUL
if "%ERRORLEVEL%" == "0" ( 
	del "tasklist.txt"

	if exist "Vagr.json" (

		echo SSHing to VM... 
		echo 	User: buddy
		echo 	Password: 1234567890
		echo 	IP Address: 127.0.0.1
		echo 	Port: 2222

		%ssh_path%\ssh buddy@127.0.0.1 -p 2222
		exit /b
	) else (
		echo Missing: Vagr.json
		echo Run: vagr setup [vmname/uuid]
		exit /b
	)

) else (
	del "tasklist.txt"
	echo Cannot SSH because Vagr machine is not running.
	exit /b
)

:LIST
set arg2=%2
if "%arg2%" == "" (
	%vbox% list vms
) else if "%arg2%" == "--running" (
	%vbox% list runningvms
) else if "%arg2%" == "--shared" (
	%lib%\execute_vagr --list_shared
) else if "%arg2%" == "--ports" (
	%lib%\execute_vagr --list_ports
) else if "%arg2%" == "--name" (
	%lib%\execute_vagr --name
) else (goto PRINT_ERROR)
exit /b

:MANUAL
type %file_dir%\vagr_manual
exit /b

:PRINT_ERROR
echo Usage:
echo 	vagr [command]
echo Commands:
echo 	add [ovfname/ovaname] 
echo 	init [vmname/uuid] 
echo 	rename [vmname/uuid] [new name]
echo 	destroy 
echo 	start     
echo 	pause 
echo 	resume    
echo 	down      	
echo 	reload    
echo 	add_shared [name] [folder path]
echo 	del_shared [name]
echo 	add_port  [rulename] [host ip] [host port] [guest ip] [guest port]
echo 	del_port  [rulename]
echo 	ssh
echo 	list [--running] [--name] [--shared] [--ports] 
echo 	manual

exit /b
