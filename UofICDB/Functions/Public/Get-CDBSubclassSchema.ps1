using namespace System.Management.Automation

#These classes are a necessary workaround to use variables as validate sets. Hopefully Microsoft bakes this in someday.
class ValidSubClassGenerator : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        return ($Script:SubClassURIs).Keys
    }
}

<#
.Synopsis
   Returns the schema for the given CDB subclass. This is a listing of the properties and their data types. Useful for crafting filters for Get-CDBItem.
.DESCRIPTION
   Returns the schema for the given CDB subclass. This is a listing of the properties and their data types. Useful for crafting filters for Get-CDBItem.
.PARAMETER SubClass
    The specific type of item. Ex: building, network, service, etc.
    Tab completion is supported.
.EXAMPLE
   Get-CDBSubclassSchema -SubClass system
#>
function Get-CDBSubclassSchema {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet( [ValidSubClassGenerator] )]
        [String]$SubClass
    )
    
    begin {
        
    }
    
    process {
        (Invoke-CDBRestCall -RelativeURI $Script:SubClassURIs[$SubClass].schema).fields
    }
    
    end {
        
    }
}