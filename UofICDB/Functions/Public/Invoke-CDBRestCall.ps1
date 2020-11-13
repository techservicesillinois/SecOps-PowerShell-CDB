﻿<#
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
        if($null -eq $Script:Authorization){
            Write-Verbose -Message 'No CDB connection established. Please provide credentials.'
            New-CDBConnection
        }
    }

    process {
        #These querystring additions are only applicable for v2 of the api and some features require using v1
        if($RelativeURI -like "/api/v2/*"){
            $QueryString = "?format=json&limit=$($Limit)&offset=$($Offset)&"
            $QueryString += $Filter -join '&'
        }

        $IVRSplat = @{
            'Headers' = @{
                'Authorization' = ('Basic {0}' -f ([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Script:Authorization.UserName,$Script:Authorization.GetNetworkCredential().Password)))))
            }

            'Uri' = "$($Script:Settings.CDBURI)$($RelativeURI)$($QueryString)"
        }

        Invoke-RestMethod @IVRSplat
    }

    end {

    }
}