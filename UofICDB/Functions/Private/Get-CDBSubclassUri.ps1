function Get-CDBSubclassUri {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter(Mandatory=$true)]
        [String]$ItemUri
    )
    
    begin {
        
    }
    
    process {
        $Splat = New-CDBRestSplat -Credential $Credential -Category $ItemUri
        Invoke-RestMethod @Splat
    }
    
    end {
        
    }
}