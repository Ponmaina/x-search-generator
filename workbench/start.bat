@echo off
REM Windows 用ランチャー。ダブルクリックで起動します。
cd /d "%~dp0"
where py >nul 2>nul
if %errorlevel%==0 (
  py server.py
) else (
  python server.py
)
pause
