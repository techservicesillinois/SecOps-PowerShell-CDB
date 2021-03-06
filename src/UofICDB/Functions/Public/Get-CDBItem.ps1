﻿using namespace System.Management.Automation

#These classes are a necessary workaround to use variables as validate sets. Hopefully Microsoft bakes this in someday.
class ValidSubClassGenerator : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        return ($Script:SubClassURIs).Keys
    }
}

<#
.Synopsis
   Returns item(s) from CDB given criteria.
.DESCRIPTION
   Returns item(s) from CDB given criteria.
.PARAMETER SubClass
    The specific type of item. Ex: building, network, service, etc.
    Tab completion is supported.
.PARAMETER Filter
    An optional set of filters for results. Properties for a given SubClass can be found with Get-CDBSubclassSchema.
.PARAMETER Limit
    Limit on results returned. The stock default is 20 and this is controled via the settings.json of the module. CDB hard caps this at 1000.
.PARAMETER Id
    The specific Id of the item you are looking for.
.PARAMETER Recursive
    Attempt to resolve properties of objects that are links to other CDB items. Can only be used with Id and NetworkByHostIP since this can be intensive on CDB with a high result count.
.PARAMETER ReturnAll
    Returns all items of the given SubClass from CDB.
.PARAMETER NetworkByHostIP
    Returns the network item that the given IP address belongs to. Supports both IPv4 and IPv6.
.EXAMPLE
   Get-CDBItem -id 1770

   This will return the specific item with Id 1770
.EXAMPLE
   Get-CDBItem -SubClass system -Filter 'ipv4_address=64.22.187.105'

   This will return a system with the IP of 64.22.187.105. Keep in mind CDB does not allow filtering on all properties.
.EXAMPLE
   Get-CDBItem -NetworkByHostIP '64.22.187.105'

   This will return the network that '64.22.187.105' falls in.
#>
function Get-CDBItem {
    [CmdletBinding(DefaultParametersetname='Id')]
    param (
        [Parameter(Mandatory=$true,ParameterSetName = 'Filter')]
        [ValidateSet( [ValidSubClassGenerator] )]
        [String]$SubClass,

        [Parameter(ParameterSetName = 'Filter')]
        [String[]]$Filter,

        [Parameter(ParameterSetName = 'Filter')]
        [int]$Limit = $Script:Settings.DefaultReturnLimit,

        [Parameter(ParameterSetName = 'Filter')]
        [Switch]$ReturnAll,

        [parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Id')]
        [int]$Id,

        [Parameter(ParameterSetName = 'NetworkByHostIP')]
        [String]$NetworkByHostIP,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'NetworkByHostIP')]
        [Switch]$Recursive
    )

    begin {

    }

    process {
        if($NetworkByHostIP){
            #This is possible by manually specifying the filter but its tedious and unintuitive for the user so we do the work for them as this is a very common use case.
            #The IP address family (v4 or v6) is determined and the filter genereted.
            $ResolvedAddress = Assert-IPAddress -IPAddress $NetworkByHostIP
            Write-Verbose -Message "IPAddress resolved to $($ResolvedAddress.IPAddress) of address family $($ResolvedAddress.AddressFamily)."

            $Filter = (
                "ip$($ResolvedAddress.AddressFamily)_address_low__lte=$($ResolvedAddress.IPAddress)",
                "ip$($ResolvedAddress.AddressFamily)_address_high__gte=$($ResolvedAddress.IPAddress)"
            )

            $SubClass = 'network'
        }

        if($Limit -gt 1000){
            Write-Warning -Message 'CDB only supports limits up to 1000. Consider using -ReturnAll to get the full collection of items.'
        }

        $Return = [System.Collections.ArrayList]@()

        if($Id){
            #All items have an ID that is accesbible via the item directory but these just return the specific subclass URI for the item.
            #The actual item properties are not stored on this it is just a redirect to the actual subclass with the information.
            #So when looking up a specific item we have to run two calls.
            $Redirect = (Invoke-CDBRestCall -RelativeURI "/api/v2/item/$($Id)/").subclass
            $Return += Invoke-CDBRestCall -RelativeURI $Redirect
        }
        elseif($ReturnAll){
            if($PSBoundParameters.Keys -contains 'Limit'){
                Write-Warning -Message 'Ignoring provided limit since ReturnAll was also specified.'
            }

            #CDB has a hard cap of 1000 items returned in a single call. So to get all results we have to first get the total count from the meta data and then iterate through batches of 1000 results using the offset parameter.
            [int]$TotalObjects = (Invoke-CDBRestCall -RelativeURI $Script:SubClassURIs[$SubClass].list_endpoint -Limit 1).meta.total_count
            Write-Verbose -Message "$($TotalObjects) total objects of subclass $($SubClass) available."
            [int]$Offset = 0
            While($TotalObjects -gt 0){
                $Return += (Invoke-CDBRestCall -RelativeURI $Script:SubClassURIs[$SubClass].list_endpoint -Filter $Filter -Limit 1000 -Offset $Offset).Objects
                $Offset += 1000
                $TotalObjects -= 1000
            }
        }
        else{
            $Return += (Invoke-CDBRestCall -RelativeURI $Script:SubClassURIs[$SubClass].list_endpoint -Filter $Filter -Limit $Limit).Objects
        }

        if($Recursive){
            #This currently only works for top level URIs not something like contacts that is an array of JSON objects. It will find all properties that are relative URIs then replace them with the object they link to.
            foreach($Item in $Return){
                $Item.psobject.Properties | Where-Object -FilterScript {$_.value -like "/api/v2/*" -and $_.value -ne $Item.resource_uri} | ForEach-Object -Process {
                    $Item.$($_.Name) = Invoke-CDBRestCall -RelativeURI $_.value
                }
            }

            $Item.contacts = ($Item.contacts).contact.trimstart('/api/v2/item/').trim('/') | Get-CDBItem
        }

        if($Return){
            $Return
        }
        Else{
            throw "No CDB results for the provided parameters."
        }
    }

    end {

    }
}