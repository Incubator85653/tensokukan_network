@set pingBin=bin\psping.exe
@set pingAddr=%1

@set pingArgs=-n 1 %pingAddr%

@%pingBin% %pingArgs%