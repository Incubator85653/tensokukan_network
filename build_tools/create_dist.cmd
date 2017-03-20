@cd /d %~dp0
@set rd=rd /s /q

@set dist=dist

@set bin=bin

@set config=config.yaml
@set env=env.yaml
@set string=string.yaml
@set variables=variables.yaml

@set main=tsk_net.exe

%rd% %dist%

echo D| xcopy %bin% %dist%\%bin% /s /i

echo F| xcopy %config% %dist%\%config%
echo F| xcopy %env% %dist%\%env%
echo F| xcopy %string% %dist%\%string%
echo F| xcopy %variables% %dist%\%variables%

echo F| xcopy %main% %dist%\%main%

exit