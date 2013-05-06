
set boost_dir=C:\GitHub\boost-svn
set thrust_dir=C:\GitHub\thrust

set INCLUDE=%INCLUDE%;%boost_dir%;%thrust_dir%
nmake -f .\MakeFile.win 