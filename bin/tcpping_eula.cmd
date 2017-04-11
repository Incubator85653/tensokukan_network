@cd /d %~dp0

@set pingBin=tcping.exe
@echo --------------------------------------------------------------
@echo tcping by Eli Fulkerson
@echo Please see http://www.elifulkerson.com/projects/ for updates.
@echo --------------------------------------------------------------

@REM Show EULA and test if bin exist.

@cd bin >nul 2>nul
@%pingBin% >nul
@cd .. >nul 2>nul