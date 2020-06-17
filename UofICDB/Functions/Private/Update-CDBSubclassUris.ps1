<#
.Synopsis
   Creates a cache of sorts for the SubClass URIs in CDB and enables the tab completion of this information in other cmdlets.
.DESCRIPTION
   Creates a cache of sorts for the SubClass URIs in CDB and enables the tab completion of this information in other cmdlets.
.EXAMPLE
   Update-CDBSubclassUris
#>
function Update-CDBSubclassUris {
    [CmdletBinding(SupportsShouldProcess)]
    param (
    )

    begin {

    }

    process {
        $Script:SubClassURIs.clear()

        #A GET on the root of the api gives a listing of all SubClasses and their relevant URIs.
        $Return = Invoke-CDBRestCall -RelativeURI '/api/v2/'

        #What is returned is a JSON with a property per Subclass type which means to split it up we have to do this ugly bit here.
        #Subclasses are things like building, network, domain, etc.
        ($Return | Get-Member | Where-Object -FilterScript {$_.MemberType -eq 'NoteProperty'}).Name | ForEach-Object -Process {
            $Script:SubClassURIs.add($_,$Return.$_)
        }
    }

    end {

    }
}