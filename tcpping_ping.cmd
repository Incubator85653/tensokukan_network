@chcp 936

@set pingBin=bin\psping.exe
@set pingAddr=127.0.0.1:26420

@set pingArgs=-n 1 %pingAddr%

@%pingBin% %pingArgs%