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
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential,
        [Switch]$Save
    )

    begin {
    }

    process {
        if($PSCmdlet.ShouldProcess("Creating session for $($Credential.UserName)")){
            $Script:Authorization = $Credential
            Update-CDBSubclassUris
        }

        if($Save){
            if($PSCmdlet.ShouldProcess("Caching credentials for $($Credential.UserName) at $($Script:SavedCredsDir)")){
                @{
                    Username = $Credential.Username
                    # The password is encrypted when it's written to disk and is only retrievable by the user/system combination.
                    Password = $Credential.Password | ConvertFrom-SecureString
                } | ConvertTo-Json | Out-File -FilePath $Script:SavedCredsDir
            }
        }
    }

    end {
    }
}
