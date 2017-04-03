@set pingBin=bin\tcping.exe
@set pingAddr=%1 %2

@set pingArgs=-n 1 %pingAddr%

@%pingBin% %pingArgs%