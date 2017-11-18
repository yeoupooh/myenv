@echo off

set _CMD=%1
set _SET_MYENV_FILE=_set.myenv.bat

call _set.myenv.bat
if "%MYENV_HOME%" == "" (
    echo MYENV_HOME is not set in the %_SET_MYENV_FILE%.
    call :unset_local
    exit /b
)

set _ROLLBACK_PATHS_BATCH_FILE=%MYENV_HOME%\_rollback.paths.bat

if "%_CMD%" == "" goto :help
if "%_CMD%" == "init" goto :generate_rollback
if "%_CMD%" == "rollback" goto :execute_rollback
if "%_CMD%" == "set" goto :update_env %*
if "%_CMD%" == "unset" goto :update_env %*
goto :help
exit /b

:help
echo %0 ^<command^> [env name]
echo commands:
echo    init              Generate rollback batch file.
echo    rollback          Execute rollback batch file.
echo    set ^<env name^>    Set given environment.
echo    unset ^<env name^>  Unset given environment.
exit /b

:unset_local
set _CMD=
set _ROLLBACK_PATHS_BATCH_FILE=
set _ENV_FILE=
exit /b

:generate_rollback
echo Generating Rollback batch file...
(
    echo @echo off
    echo echo Rollbacking...
) > %_ROLLBACK_PATHS_BATCH_FILE%
echo set PATH=%PATH% >> %_ROLLBACK_PATHS_BATCH_FILE%
(
    echo echo Rollbacked.
) >> %_ROLLBACK_PATHS_BATCH_FILE%
echo Generated.
echo PATH=%PATH%
call :unset_local
exit /b

:execute_rollback
if not exist %_ROLLBACK_PATHS_BATCH_FILE% (
    echo Rollback file not found.
    exit /b
)
echo PATH=%PATH%
call %_ROLLBACK_PATHS_BATCH_FILE%
echo PATH=%PATH%
call :unset_local
exit /b

:update_env
set _ENV_FILE=%MYENV_HOME%\_env.%2.%1.bat
if not exist %_ENV_FILE% (
    echo env file [%_ENV_FILE%] not found.
    exit /b
)
echo PATH=%PATH%
echo Executing %_ENV_FILE%...
call %_ENV_FILE% %CMD%
echo Executed.
echo PATH=%PATH%
call :unset_local
exit /b
