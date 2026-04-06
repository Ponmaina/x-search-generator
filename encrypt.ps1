# StatiCrypt encrypt tool with password verification
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

Write-Host "================================"
Write-Host " StatiCrypt 暗号化ツール"
Write-Host "================================"
Write-Host ""

$hashFile = Join-Path $PSScriptRoot ".pwdhash"

function Get-PasswordHash($password) {
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($password)
    $hash = $sha256.ComputeHash($bytes)
    return [System.BitConverter]::ToString($hash).Replace('-', '').ToLower()
}

function Read-HiddenPassword($prompt) {
    $secure = Read-Host $prompt -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { return [Runtime.InteropServices.Marshal]::PtrToStringAuto($ptr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
}

if (Test-Path $hashFile) {
    $storedHash = (Get-Content $hashFile -Encoding UTF8 -Raw).Trim()
    $currentPw = Read-HiddenPassword "現在のパスワードを入力"
    if ((Get-PasswordHash $currentPw) -ne $storedHash) {
        Write-Host ""
        Write-Host "パスワードが正しくありません。" -ForegroundColor Red
        Read-Host "Enterで終了"
        exit 1
    }
    Write-Host "確認OK" -ForegroundColor Green
}

Write-Host ""
$newPw  = Read-HiddenPassword "新しいパスワードを入力"
$newPw2 = Read-HiddenPassword "もう一度入力"

if ($newPw -ne $newPw2) {
    Write-Host ""
    Write-Host "パスワードが一致しません。" -ForegroundColor Red
    Read-Host "Enterで終了"
    exit 1
}

Write-Host ""
Write-Host "暗号化中..."
Set-Location $PSScriptRoot
& npx staticrypt x-search-generator.html -p $newPw -d encrypted
if ($LASTEXITCODE -ne 0) {
    Write-Host "エラーが発生しました。" -ForegroundColor Red
    Read-Host "Enterで終了"
    exit 1
}
Move-Item -Force "encrypted\x-search-generator.html" "index.html"
Remove-Item -Recurse -Force "encrypted" -ErrorAction SilentlyContinue

Set-Content -Path $hashFile -Value (Get-PasswordHash $newPw) -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "完了しました！index.html が更新されました。" -ForegroundColor Green
Read-Host "Enterで終了"
