@cd /d %~dp0
start /wait clean_temps.cmd
start /wait delete_source.cmd
@cd ..
copySource.cmd & exit