@cd /d %~dp0
start /wait update_source.cmd
start /wait auto_build.cmd
exit