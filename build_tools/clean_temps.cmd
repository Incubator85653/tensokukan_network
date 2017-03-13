@REM Go to script actual file location.

@cd /d %~dp0

@REM Del commands
set del=del /q


@REM Set files to delete.

@set errorTxt="error.txt"
@set lastReportTrack="last_report_trackrecord.xml"

@set ProgramName=tsk_report

@set TskNetExe="%ProgramName%.exe"
@set TskNetExy="%ProgramName%.exy"

@REM Delete files.

%del% %errorTxt%
%del% %lastReportTrack%
%del% %TskNetExe%
%del% %TskNetExy%

@REM Exit cmd window shortly.
timeout /t 5