@cd /d %~dp0
@set TENCO_INFO="tenco.info" pta_c.exe pta_tenco.info.ini
@set STATIC_TENCO_INFO="static.tenco.info" pta_c.exe pta_static.tenco.info.ini

@start /min %STATIC_TENCO_INFO%
@start /min %TENCO_INFO%
@exit