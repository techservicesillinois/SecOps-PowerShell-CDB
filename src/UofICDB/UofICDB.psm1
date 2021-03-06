﻿[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'

#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"
    . $_.fullname
}

[String]$SettingsPath = Join-Path -Path $PSScriptRoot -ChildPath 'Settings.json'
$Script:Settings = Get-Content -Path $SettingsPath | ConvertFrom-Json

$Script:SubClassURIs = @{}

[String]$Script:SavedCredsDir = Join-Path -Path $([System.Environment]::GetFolderPath(28)) -ChildPath 'PSCDBAuth2.txt'
[String]$Script:OldSavedCredsDir = Join-Path -Path $([System.Environment]::GetFolderPath(28)) -ChildPath 'PSCDBAuth.txt'

if(Test-Path -Path $Script:OldSavedCredsDir){
    Remove-Item -Path $Script:OldSavedCredsDir -Force
}

if(Test-Path -Path $Script:SavedCredsDir){
    $SavedCreds = Get-Content -Path $Script:SavedCredsDir | ConvertFrom-Json
    $Script:Authorization = New-Object -TypeName PSCredential -ArgumentList ($SavedCreds.Username,($SavedCreds.Password | ConvertTo-SecureString))
    Update-CDBSubclassUris
}
else{
    $Script:Authorization = $null
}