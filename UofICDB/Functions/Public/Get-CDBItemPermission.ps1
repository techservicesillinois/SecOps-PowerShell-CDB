<#
.Synopsis
    Returns a given items CDB permissions.
.DESCRIPTION
    Returns a given items CDB permissions.
.PARAMETER Id
    The specific Id of the item you are looking for.
.EXAMPLE
    Get-CDBItemPermission -id 1770
.EXAMPLE
    Get-CDBItem -Id 1778 | Get-CDBItemPermission
#>
function Get-CDBItemPermission {
    param (
        [parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [int]$Id
    )

    begin {
    }

    process {
        $Return = (Invoke-CDBRestCall -RelativeURI "/api/v1/item/$($Id)/?permissions=true").$Id | Select-Object -Property 'id','name','permissions'

        $Properties = @(
            @{ Name = 'NetId';  Expression = {$_.Name}},
            @{ Name = 'Iris';  Expression = {$_.Value.Iris}},
            @{ Name = 'ISSRequests';  Expression = {$_.Value.'ISS Requests' -eq 'Yes' ? $True : $False}},
            @{ Name = 'DNSRequests';  Expression = {$_.Value.'DNS Requests' -eq 'Yes' ? $True : $False}}
        )
        
        [PSCustomObject]@{
            Id = $Return.Id
            Name = $Return.Name
            Permissions = $Return.permissions.psobject.Properties | Select-Object -Property $Properties
        }
    }

    end {
    }
}
