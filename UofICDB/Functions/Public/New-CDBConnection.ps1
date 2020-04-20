<#
.Synopsis
   This cmdlet will cache your CDB credentials for the session to be used with the other cmdlets in the UofICDB module.
.DESCRIPTION
   This cmdlet will cache your CDB credentials for the session to be used with the other cmdlets in the UofICDB module.
.PARAMETER Credential
    Your CDB API credentials. This will likely not bet your NetID
.EXAMPLE
    $Credential = Get-Credential
    New-CDBConnection -Credential $Credential
#>
function New-CDBConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential
    )
    
    begin {
        
    }
    
    process {
        $Script:Authorization = 'Basic {0}' -f ([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Credential.UserName,$Credential.GetNetworkCredential().Password))))
        Update-CDBSubclassUris
    }
    
    end {
        
    }
}