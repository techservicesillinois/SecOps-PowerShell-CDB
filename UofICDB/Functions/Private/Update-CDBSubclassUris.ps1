function Update-CDBSubclassUris {
    [CmdletBinding()]
    param (
    )
    
    begin {
        
    }
    
    process {
        $Script:SubClassURIs.clear()
        
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