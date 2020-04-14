function New-CDBRestSplat {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter(Mandatory=$true)]
        [String]$Category,
        [String]$Filter
    )
    
    begin {
        
    }
    
    process {
        if($Filter -and $Filter[0] -ne '&'){
            $Filter = "&$($Filter)"
        }

        $EncodedText = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Credential.UserName,$Credential.GetNetworkCredential().Password)))
        
        $IVRSplat = @{
            'Headers' = @{
                'Authorization' = 'Basic {0}' -f $EncodedText
            }

            'Uri' = '{0}{1}?format=json{2}' -f $Script:Settings.CDBURI, $Category, $Filter
        }

        $IVRSplat
    }
    
    end {
        
    }
}