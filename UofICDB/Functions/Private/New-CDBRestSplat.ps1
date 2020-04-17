function New-CDBRestSplat {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]    
        [String]$RelativeURI,
        [String]$Filter
    )
    
    begin {
        if($Script:Authorization -eq [String]::Empty){
            Write-Verbose -Message 'No CDB connection established. Please provide credentials.'
            New-CDBConnection
        }
    }
    
    process {
        if($Filter -and $Filter[0] -ne '&'){
            $Filter = "&$($Filter)"
        }
        
        $IVRSplat = @{
            'Headers' = @{
                'Authorization' = $Script:Authorization
            }

            'Uri' = '{0}{1}?format=json{2}' -f $Script:Settings.CDBURI,$RelativeURI,$Filter
        }

        $IVRSplat
    }
    
    end {
        
    }
}