using namespace System.Management.Automation

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
    Limit on results returned. The stock default is 20 and this is controled via the settings.json of the module.
.PARAMETER Id
    The specific Id of the item you are looking for.
.PARAMETER Recursive
    Attempt to resolve properties of objects that are links to other CDB items.
.EXAMPLE
   Get-CDBItem -id 1770

   This will return the specific item with Id 1770
.EXAMPLE
   Get-CDBItem -SubClass system -Filter 'ipv4_address=64.22.187.105'

   This will return a system with the IP of 64.22.187.105. Keep in mind CDB does not allow filtering on all properties.
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

        [Parameter(ParameterSetName = 'Id')]
        [int]$Id,

        [Switch]$Recursive
    )
    
    begin {
        
    }
    
    process {
        $Return = [System.Collections.ArrayList]@()

        if($Id){
            #All items have an ID that is accesbible via the item directory but these just return the specific subclass URI for the item.
            #The actual item properties are not stored on this it is just a redirect to the actual subclass with the information.
            #So when looking up a specific item we have to run two calls.
            $Redirect = (Invoke-CDBRestCall -RelativeURI "/api/v2/item/$($Id)/").subclass
            $Return += Invoke-CDBRestCall -RelativeURI $Redirect
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
        }

        $Return
    }
    
    end {
        
    }
}