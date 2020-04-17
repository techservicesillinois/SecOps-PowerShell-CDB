[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'

#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"   
    . $_.fullname
}

[String]$SettingsPath = Join-Path -Path $PSScriptRoot -ChildPath 'Settings.json'
$Script:Settings = Get-Content -Path $SettingsPath | ConvertFrom-Json

$Script:Authorization = [String]::Empty
$Script:SubClassURIs = @()