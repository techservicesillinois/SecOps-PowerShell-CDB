[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
[String]$PublicFunctionPath = Join-Path -Path $FunctionPath -ChildPath 'Public'

#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"
    
    . $_.fullname

    if($_.Directory -like "$($PublicFunctionPath)\*"){
        Export-ModuleMember -Function $_.BaseName
    }
}

[String]$SettingsPath = Join-Path -Path $PSScriptRoot -ChildPath 'Settings.json'
$Script:Settings = Get-Content -Path $SettingsPath | ConvertFrom-Json