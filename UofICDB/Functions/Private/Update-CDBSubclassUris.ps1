function Update-CDBSubclassUris {
    [CmdletBinding()]
    param (
    )
    
    begin {
        
    }
    
    process {
        $Script:SubClassURIs.clear()
        
        $Splat = New-CDBRestSplat -RelativeURI '/api/v2/'
        $Return = Invoke-RestMethod @Splat

        #What is returned is a JSON with a property per Subclass type which means to split it up we have to do this ugly bit here.
        #Subclasses are things like building, network, domain, etc.
        ($Return | Get-Member | Where-Object -FilterScript {$_.MemberType -eq 'NoteProperty'}).Name | ForEach-Object -Process {
            $Script:SubClassURIs += [PSCustomObject]@{
                Name = $_
                list_endpoint = $Return.$_.list_endpoint
                schema = $Return.$_.schema
            }
        }
    }
    
    end {
        
    }
}