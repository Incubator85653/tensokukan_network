@cd /d %~dp0
@set TENCO_INFO="tenco.info" ptproxy-4jvg5d.exe tenco.info.json
@set STATIC_TENCO_INFO="static.tenco.info" ptproxy-kevb81.exe static.tenco.info.json

@start /min %STATIC_TENCO_INFO%
@start /min %TENCO_INFO%