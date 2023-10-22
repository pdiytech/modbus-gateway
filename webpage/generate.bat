@echo off

SET TEMP_PATH=%~dp0
SET ROOT_PATH=%TEMP_PATH:~0,-8%
SET GZIP_PATH=%ROOT_PATH%scripts\gzip\bin\gzip.exe
SET GZIP_OPT=-9 -k
SET XXD_PATH=%ROOT_PATH%scripts\xxd\xxd.exe
SET XXD_OPT=-i

SET MINIFY_PATH=minify.py

SET MINIFY_DIR=_minify
SET COMPRESSED_DIR=_gzip

@REM SET TARGET_DIR=%ROOT_PATH%components\emon_webpage\pages
SET TARGET_DIR=%ROOT_PATH%main\services\web\pages

echo 1. Check filepath and directory path

: Check that file/path exist
if not exist "%GZIP_PATH%" (
  echo Error: gzip not found
  pause
  goto:eof
) else (
  echo Found gzip.exe at %GZIP_PATH%
)
if not exist "%XXD_PATH%" (
  echo Error: xxd not found
  pause
  goto:eof
) else (
  echo Found gzip.exe at %XXD_PATH%
)
if not exist "%MINIFY_PATH%" (
  echo Error: Minify scripts not found
  pause
  goto:eof
)
if not exist "%MINIFY_DIR%" (
  echo Create dir \%MINIFY_DIR%
  mkdir %MINIFY_DIR%
)
if not exist "%COMPRESSED_DIR%" (
  echo Create dir \%COMPRESSED_DIR%
  mkdir %COMPRESSED_DIR%
)
if not exist "%TARGET_DIR%" (
  echo Create dir \%TARGET_DIR%
  mkdir %TARGET_DIR%
)
: Delete file
echo 2. Delete old files
del /s /q %COMPRESSED_DIR%\*
del /s /q %MINIFY_DIR%\*
del /s /q css\*.gz
del /s /q *.gz

echo 3. Minify files
: minify html and style
python minify.py index.html
IF %errorlevel% NEQ 0 ( 
  echo Error: minify index.html
  goto:eof
)
python minify.py css/style.css
IF %errorlevel% NEQ 0 ( 
  echo Error: minify index.html
  goto:eof
)

echo 4. Compress files
: Compress from /minify
set GZIP_CMD=%GZIP_PATH% %GZIP_OPT%
%GZIP_CMD% %MINIFY_DIR%\index.html
move %MINIFY_DIR%\index.html.gz %COMPRESSED_DIR%\index.html
%GZIP_CMD% %MINIFY_DIR%\style.css
move %MINIFY_DIR%\style.css.gz %COMPRESSED_DIR%\style.css

: Compress from /css
%GZIP_CMD% css\bootstrap-grid.min.css
move css\bootstrap-grid.min.css.gz %COMPRESSED_DIR%\bootstrap-grid.min.css
%GZIP_CMD% css\bootstrap.min.css
move css\bootstrap.min.css.gz %COMPRESSED_DIR%\bootstrap.min.css

: Compress from /js
%GZIP_CMD% js\bootstrap.min.js
move js\bootstrap.min.js.gz %COMPRESSED_DIR%\bootstrap.min.js

: Compress from /
%GZIP_CMD% jquery.min.js
move jquery.min.js.gz %COMPRESSED_DIR%\jquery.min.js
%GZIP_CMD% favicon.ico
move favicon.ico.gz %COMPRESSED_DIR%\favicon.ico

echo 5. Generate source files
: Generate to header source file
%XXD_PATH% -i %COMPRESSED_DIR%\index.html             %TARGET_DIR%\index.html.h
%XXD_PATH% -i %COMPRESSED_DIR%\jquery.min.js          %TARGET_DIR%\jquery.min.js.h
%XXD_PATH% -i %COMPRESSED_DIR%\bootstrap.min.js       %TARGET_DIR%\bootstrap.min.js.h
%XXD_PATH% -i %COMPRESSED_DIR%\style.css              %TARGET_DIR%\style.css.h
%XXD_PATH% -i %COMPRESSED_DIR%\bootstrap.min.css      %TARGET_DIR%\bootstrap.min.css.h
%XXD_PATH% -i %COMPRESSED_DIR%\bootstrap-grid.min.css %TARGET_DIR%\bootstrap-grid.min.css.h
%XXD_PATH% -i %COMPRESSED_DIR%\favicon.ico            %TARGET_DIR%\favicon.ico.h

echo 6. Make array as 'const'

python make_const.py %TARGET_DIR%\index.html.h
python make_const.py %TARGET_DIR%\jquery.min.js.h
python make_const.py %TARGET_DIR%\bootstrap.min.js.h
python make_const.py %TARGET_DIR%\style.css.h
python make_const.py %TARGET_DIR%\bootstrap.min.css.h
python make_const.py %TARGET_DIR%\bootstrap-grid.min.css.h
python make_const.py %TARGET_DIR%\favicon.ico.h

echo Success
