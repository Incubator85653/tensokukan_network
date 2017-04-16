@cd /d %~dp0

@set start=start /wait

@set step1=build_1-mkexy.cmd
@set step2=build_2-add_icon.cmd
@set step3=build_3-exe.cmd

%start% %step1%
%start% %step2%
%start% %step3%

exit