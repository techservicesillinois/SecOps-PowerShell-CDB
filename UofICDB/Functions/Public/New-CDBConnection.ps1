<#
.Synopsis
   This cmdlet will cache your CDB credentials for the session to be used with the other cmdlets in the UofICDB module.
.DESCRIPTION
   This cmdlet will cache your CDB credentials for the session to be used with the other cmdlets in the UofICDB module.
.PARAMETER Credential
    Your CDB API credentials. This will likely not be your NetID
.PARAMETER Save
    This will encrypt the encoded credentials and store them $ENV:LOCALAPPDATA\PSCDBAuth.txt on Windows or /home//.local/share/ on Linux for use between sessions. This will only be readable by the account that saves it on the machine it was saved.
.EXAMPLE
    $Credential = Get-Credential
    New-CDBConnection -Credential $Credential
#>
function New-CDBConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential,
        [Switch]$Save
    )

    begin {

    }

    process {
        $Script:Authorization = 'Basic {0}' -f ([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Credential.UserName,$Credential.GetNetworkCredential().Password))))
        Update-CDBSubclassUris

        if($Save){
            #documentation for the encryption can be found here: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/convertfrom-securestring?view=powershell-7 and https://docs.microsoft.com/en-us/dotnet/standard/security/how-to-use-data-protection
            #Windows Data Protection API (DPAPI) is used in this context.
            $Script:Authorization | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File -FilePath $Script:SavedCredsDir -Force
        }
    }

    end {

    }
}