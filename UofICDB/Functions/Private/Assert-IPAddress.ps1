<#
.Synopsis
   Determines the validity and address family of a provided IP address.
.DESCRIPTION
Determines the validity and address family of a provided IP address.
.EXAMPLE
   Assert-IPAddress -IPAddress '192.168.1.1'
.EXAMPLE
   Assert-IPAddress -IPAddress '2001:db8::1:0:0:1'
#>
function Assert-IPAddress {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]    
        [String]$IPAddress
    )
    
    begin {
        
    }
    
    process {
        $IPAddress = $IPAddress.trim()
        [System.Net.IPAddress]$IP = $Null
        
        #This method will return a boolean result for if the IP is valid or not and store the instofmrion in an IPAddres object.
        if(![System.Net.IpAddress]::TryParse($IPAddress,[ref]$IP)){
            throw "'$($IPAddress)' is not a valid IP address."
        }
        else{
            [PSCustomObject]@{
                IPAddress = $IPAddress
                IsValid = $True
                AddressFamily = (($IP.AddressFamily -eq 'InterNetwork') ? 'v4' : 'v6')
            }
        }
    }
    
    end {
        
    }
}