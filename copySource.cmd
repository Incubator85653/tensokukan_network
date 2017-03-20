@cd /d %~dp0
@set build_dir=build_tools

@set lib=lib
@set bin=bin

@set config=config.yaml
@set env=env.yaml
@set string=string.yaml
@set variables=variables.yaml

@set main=tsk_net.rb

echo A| xcopy %lib% %build_dir%\%lib% /s /i
echo A| xcopy %bin% %build_dir%\%bin% /s /i

echo A| xcopy %config% %build_dir%
echo A| xcopy %env% %build_dir%
echo A| xcopy %string% %build_dir%
echo A| xcopy %variables% %build_dir%

echo A| xcopy %main% %build_dir%
pause