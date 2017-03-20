@set del=del /q
@set rd=rd /s /q

@REM files
@set main=tsk_net.rb

@set config=config.yaml
@set config_default=config_default.yaml
@set env=env.yaml
@set variables=variables.yaml
@set string=string.yaml

@REM folders
@set lib=lib
@set bin=bin

%del% %main%
%del% %config%
%del% %config_default%
%del% %env%
%del% %variables%
%del% %string%


%rd% %lib%
%rd% %bin%

pause