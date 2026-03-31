# StatiCrypt 暗号化ツール（パスワード検証付き）
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "================================"
Write-Host " StatiCrypt 暗号化ツール"
Write-Host "================================"
Write-Host ""

$hashFile = Join-Path $PSScriptRoot ".pwdhash"
$sourceFile = Join-Path $PSScriptRoot "x-search-generator.html"
$outputFile = Join-Path $PSScriptRoot "index.html"

function Get-PasswordHash($password) {
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($password)
    $hash = $sha256.ComputeHash($bytes)
    return [System.BitConverter]::ToString($hash).Replace("-", "").ToLower()
}

function Read-PlainPassword($prompt) {
    $secure = Read-Host $prompt -AsSecureString
    return [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    )
}

# 現在のパスワード検証
if (Test-Path $hashFile) {
    $storedHash = (Get-Content $hashFile -Raw).Trim()
    $currentPw = Read-PlainPassword "現在のパスワードを入力してください"
    $enteredHash = Get-PasswordHash $currentPw

    if ($enteredHash -ne $storedHash) {
        Write-Host ""
        Write-Host "パスワードが正しくありません。" -ForegroundColor Red
        Read-Host "Enterキーで終了"
        exit 1
    }
    Write-Host "確認OK" -ForegroundColor Green
}

# 新しいパスワード入力
Write-Host ""
$newPw  = Read-PlainPassword "新しいパスワードを入力してください"
$newPw2 = Read-PlainPassword "もう一度入力してください"

if ($newPw -ne $newPw2) {
    Write-Host ""
    Write-Host "パスワードが一致しません。" -ForegroundColor Red
    Read-Host "Enterキーで終了"
    exit 1
}

# 暗号化
Write-Host ""
Write-Host "暗号化中..."
Set-Location $PSScriptRoot
$result = & npx staticrypt x-search-generator.html -p $newPw -d encrypted --short 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "エラーが発生しました: $result" -ForegroundColor Red
    Read-Host "Enterキーで終了"
    exit 1
}
Move-Item -Force "encrypted\x-search-generator.html" "index.html"
Remove-Item -Force "encrypted" -ErrorAction SilentlyContinue

# 新しいハッシュを保存
$newHash = Get-PasswordHash $newPw
Set-Content -Path $hashFile -Value $newHash -NoNewline

Write-Host ""
Write-Host "完了しました！ index.html が更新されました。" -ForegroundColor Green
Read-Host "Enterキーで終了"
