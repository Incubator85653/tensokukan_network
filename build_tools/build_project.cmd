@cd /d %~dp0
start /wait update_source.cmd
start /wait auto_build.cmd
start /wait create_dist.cmd
start /wait delete_source.cmd
exit