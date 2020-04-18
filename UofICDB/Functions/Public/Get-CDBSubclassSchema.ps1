using namespace System.Management.Automation

#These classes are a necessary workaround to use variables as validate sets. Hopefully Microsoft bakes this in someday.
class ValidSubClassGenerator : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        return ($Script:SubClassURIs).Keys
    }
}

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