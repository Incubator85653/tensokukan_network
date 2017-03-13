@set del=del /q
@set rd=rd /s /q

@REM files
@set config=config.yaml
@set config_default=config_default.yaml
@set env=env.yaml
@set variables=variables.yaml

@REM folders
@set lib=lib

%del% %config%
%del% %config_default%
%del% %env%
%del% %variables%

%rd% %lib%

pause