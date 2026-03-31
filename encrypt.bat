@echo off
chcp 65001 > nul
echo ================================
echo  StatiCrypt 暗号化ツール
echo ================================
echo.
set /p "PASSWORD=パスワードを入力してください: "
echo.
echo 暗号化中...
npx staticrypt x-search-generator.html -p %PASSWORD% -d encrypted --short
if %errorlevel% neq 0 (
    echo エラーが発生しました。
    pause
    exit /b 1
)
move /y encrypted\x-search-generator.html index.html > nul
rmdir encrypted > nul 2>&1
echo 完了しました！ index.html が更新されました。
echo.
pause
