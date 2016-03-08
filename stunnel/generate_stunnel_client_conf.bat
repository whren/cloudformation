@echo off

SETLOCAL ENABLEDELAYEDEXPANSION
set ec2InstancePublicDNSName=none
set localBindHost=127.0.0.1
set localBindPort=22
set certificateDownloadPath=%USERPROFILE%\Downloads
set stunnelConfExportPath=%cd%
set /p ec2InstancePublicDNSName="Enter EC2 instance public DNS name (default : !ec2InstancePublicDNSName!): "
set /p localBindHost="Enter desired local bind host (default : !localBindHost!): "
set /p localBindPort="Enter desired local bind port (default : !localBindPort!): "
set /p certificateDownloadPath="Enter the downloaded certificate path (default : !certificateDownloadPath!): "
set /p stunnelConfExportPath="Enter the stunnel.conf export path (default : !stunnelConfExportPath!): "
SETLOCAL DISABLEDELAYEDEXPANSION

set number_of_files_choosen=0

:LOOP_FILE_SELECTION
SET index=1

SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%f IN (%certificateDownloadPath%\*.pem) DO (
   SET file!index!=%%f
   ECHO !index! - %%f
   SET /A index=!index!+1
)

SETLOCAL DISABLEDELAYEDEXPANSION

@ECHO.

IF %number_of_files_choosen% EQU 0 (
	SET /P selection="Select CA file (server) by number: "
) else (
	SET /P selection="Select Certificate file (client) by number: "
)

SET file%selection% >nul 2>&1

IF ERRORLEVEL 1 (
   ECHO invalid number selected   
   EXIT /B 1
)

IF %number_of_files_choosen% EQU 0 (
	CALL :RESOLVE ca %%file%selection%%%
	SETLOCAL ENABLEDELAYEDEXPANSION
	ECHO Selected file name: !ca_file_name!
	@ECHO.
	SETLOCAL DISABLEDELAYEDEXPANSION
) else (
	CALL :RESOLVE cert %%file%selection%%%
	SETLOCAL ENABLEDELAYEDEXPANSION
	ECHO Selected file name: !cert_file_name!
	@ECHO.
	SETLOCAL DISABLEDELAYEDEXPANSION
)

set /A number_of_files_choosen=%number_of_files_choosen%+1

IF %number_of_files_choosen% EQU 2 (
	GOTO :ECHO_STUNNEL_CONF
)

GOTO :LOOP_FILE_SELECTION

:RESOLVE
SET %1_file_name=%2
GOTO :EOF

:ECHO_STUNNEL_CONF
pause
@echo ; **************************************************************************> %stunnelConfExportPath%\stunnel.conf
@echo ; * Global options                                                         *>> %stunnelConfExportPath%\stunnel.conf
@echo ; **************************************************************************>> %stunnelConfExportPath%\stunnel.conf
@echo.>> %stunnelConfExportPath%\stunnel.conf
@echo ; Initialize Microsoft CryptoAPI interface>> %stunnelConfExportPath%\stunnel.conf
@echo engine = capi>> %stunnelConfExportPath%\stunnel.conf
@echo.>> %stunnelConfExportPath%\stunnel.conf
@echo ; Some performance tunings>> %stunnelConfExportPath%\stunnel.conf
@echo socket = l:TCP_NODELAY=1>> %stunnelConfExportPath%\stunnel.conf
@echo socket = r:TCP_NODELAY=1>> %stunnelConfExportPath%\stunnel.conf
@echo.>> %stunnelConfExportPath%\stunnel.conf
@echo ; **************************************************************************>> %stunnelConfExportPath%\stunnel.conf
@echo ; * Service definitions                                                    *>> %stunnelConfExportPath%\stunnel.conf
@echo ; **************************************************************************>> %stunnelConfExportPath%\stunnel.conf
@echo.>> %stunnelConfExportPath%\stunnel.conf
@echo [aws-ssl-ssh]>> %stunnelConfExportPath%\stunnel.conf
@echo client = yes>> %stunnelConfExportPath%\stunnel.conf
(@echo verify = 3)>> %stunnelConfExportPath%\stunnel.conf
@echo CAfile = %ca_file_name%>> %stunnelConfExportPath%\stunnel.conf
@echo cert = %cert_file_name%>> %stunnelConfExportPath%\stunnel.conf
@echo accept = %localBindHost%:%localBindPort%>> %stunnelConfExportPath%\stunnel.conf
@echo connect = %ec2InstancePublicDNSName%:443>> %stunnelConfExportPath%\stunnel.conf

@rem type %stunnelConfExportPath%\stunnel.conf
@rem @echo.
@rem @echo.

@echo.
@echo Configuration file generated in %stunnelConfExportPath%\stunnel.conf

GOTO :EOF

@REM dir %certificateDownloadPathName% /b *.pem

