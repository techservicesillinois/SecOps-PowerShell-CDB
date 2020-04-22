<#
.Synopsis
   Makes a REST method call on the given relative URI for CDB. Utilizes credentials created with New-CDBConnection.
   It is reccomended to use Get-CDBItem unless you specifically have a use case not supported by that cmdlet.
.DESCRIPTION
   Makes a REST method call on the given relative URI for CDB. Utilizes credentials created with New-CDBConnection.
   It is reccomended to use Get-CDBItem unless you specifically have a use case not supported by that cmdlet.
.PARAMETER RelativeURI
    The relativeURI you wish to make a call to. Ex: /api/v2/supporthours/4/
.PARAMETER Filter
    An optional set of filters for results. Properties for a given SubClass can be found with Get-CDBSubclassSchema.
.PARAMETER Limit
    Limit on results returned. The stock default is 20 and this is controled via the settings.json of the module.
.EXAMPLE
   Invoke-CDBRestCall -RelativeURI /api/v2/supporthours/4/

   This will return the object located at /api/v2/supporthours/4/
#>
function Invoke-CDBRestCall {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]    
        [String]$RelativeURI,
        [String[]]$Filter,
        [int]$Limit = $Script:Settings.DefaultReturnLimit,
        [int]$Offset = 0
    )
    
    begin {
        if($Script:Authorization -eq [String]::Empty){
            Write-Verbose -Message 'No CDB connection established. Please provide credentials.'
            New-CDBConnection
        }
    }
    
    process {
        $QueryString = "?format=json&limit=$($Limit)&offset=$($Offset)&"
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