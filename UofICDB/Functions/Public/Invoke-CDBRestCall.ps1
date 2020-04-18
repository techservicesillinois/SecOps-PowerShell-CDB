function Invoke-CDBRestCall {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]    
        [String]$RelativeURI,
        [String[]]$Filter,
        [int]$Limit = 20
    )
    
    begin {
        if($Script:Authorization -eq [String]::Empty){
            Write-Verbose -Message 'No CDB connection established. Please provide credentials.'
            New-CDBConnection
        }
    }
    
    process {
        $QueryString = "?format=json&limit=$($Limit)&"
        $QueryString += $Filter -join '&'
        
        $IVRSplat = @{
            'Headers' = @{
                'Authorization' = $Script:Authorization
            }

            'Uri' = "$($Script:Settings.CDBURI)$($RelativeURI)$($QueryString)"
        }

        Invoke-RestMethod @IVRSplat
    }
    
    end {
        
    }
}