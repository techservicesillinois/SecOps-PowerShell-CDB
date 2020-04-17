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