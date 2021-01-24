@echo off

set _CMD=%1
set _SET_MYENV_FILE=_set.myenv.bat

call _set.myenv.bat
if "%MYENV_HOME%" == "" (
    echo [myenv] MYENV_HOME is not set in the %_SET_MYENV_FILE%.
    call :unset_local
    exit /b
)

set _ROLLBACK_PATHS_BATCH_FILE=%MYENV_HOME%\tmp\_rollback.paths.bat

if "%_CMD%" == "" goto :help
if "%_CMD%" == "init" goto :generate_rollback
if "%_CMD%" == "rollback" goto :execute_rollback
if "%_CMD%" == "set" goto :update_env %*
if "%_CMD%" == "unset" goto :update_env %*
if "%_CMD%" == "list" goto :list_envs %*
goto :help
exit /b

:help
echo %0 ^<command^> [env name]
echo commands:
echo    init              	Generate rollback batch file.
echo    rollback          	Execute rollback batch file.
echo    list              	List environments.
echo    set ^<env name^>    Set given environment.
echo    unset ^<env name^>  Unset given environment.
exit /b

:unset_local
set _CMD=
set _ROLLBACK_PATHS_BATCH_FILE=
set _ENV_FILE=
exit /b

:generate_rollback
echo [myenv] Generating Rollback batch file...
(
    echo @echo off
    echo echo [myenv] Rollbacking...
) > %_ROLLBACK_PATHS_BATCH_FILE%
echo set PATH=%PATH%>> %_ROLLBACK_PATHS_BATCH_FILE%
(
    echo echo [myenv] Rollbacked.
) >> %_ROLLBACK_PATHS_BATCH_FILE%
echo [myenv] Generated.
echo [myenv] PATH=%PATH%
call :unset_local
exit /b

:execute_rollback
if not exist %_ROLLBACK_PATHS_BATCH_FILE% (
    echo [myenv] Rollback file not found.
    exit /b
)
echo [myenv] PATH=%PATH%
call %_ROLLBACK_PATHS_BATCH_FILE%
echo [myenv] PATH=%PATH%
call :unset_local
exit /b

:update_env
set _ENV_FILE=%MYENV_HOME%\env\_env.%2.%1.bat
if not exist %_ENV_FILE% (
    echo [myenv] env file [%_ENV_FILE%] not found.
    exit /b
)
@REM echo PATH=%PATH%
echo [myenv] Setting '%2' environment...
call %_ENV_FILE% %CMD%
echo [myenv] Done.
@REM echo PATH=%PATH%
call :unset_local
exit /b

:list_envs
dir /b %MYENV_HOME%\env\_env.*.set.bat
call :unset_local
exit /b
