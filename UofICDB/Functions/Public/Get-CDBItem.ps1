using namespace System.Management.Automation

#These classes are a necessary workaround to use variables as validate sets. Hopefully Microsoft bakes this in someday.
class ValidSubClassGenerator : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        return ($Script:SubClassURIs).Keys
    }
}

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