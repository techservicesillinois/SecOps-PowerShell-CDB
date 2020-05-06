<#
.Synopsis
   This cmdlet will identify which CDB network a given host's IP belongs to. Currently only IPv4 is supported.
.DESCRIPTION
   This cmdlet will identify which CDB network a given host's IP belongs to. Currently only IPv4 is supported.
.PARAMETER IPAddress
    IP address of the host.
.EXAMPLE
    Get-CDBNetworkByHostIP -IPAddress 192.168.1.1
#>
function Get-CDBNetworkByHostIP {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]    
        [String]$IPAddress
    )
    
    begin {
        
    }
    
    process {           
        if((Assert-IPAddress -IPAddress $IPAddress).AddressFamily -ne 'v4'){
            throw 'Only IPv4 is supported at this time.'
        }

        [int]$TotalObjects = (Invoke-CDBRestCall -RelativeURI $Script:SubClassURIs['network'].list_endpoint -Limit 1).meta.total_count
        [int]$Offset = 0
        [int]$ChunkSize = 100


        While($TotalObjects -gt 0 -or $Match){
            
            (Invoke-CDBRestCall -RelativeURI $Script:SubClassURIs['network'].list_endpoint -Filter $Filter -Limit $ChunkSize -Offset $Offset).Objects | ForEach-Object -Process {
                $AddressSplit = ($_.ipv4_network -split '/')
                $HostAddresses = (Get-Subnet -IP $AddressSplit[0] -MaskBits $AddressSplit[1]).HostAddresses

                if($IPAddress -in $HostAddresses){
                    $Match = $_
                    break
                }

                $Offset += $ChunkSize
                $TotalObjects -= $ChunkSize
            }
        }

        if($Null -eq $Match){
            Write-Verbose -Message "No CDB network found for $($IPAddress)"
        }
        else{
            $Match
        }
    }
    
    end {
        
    }
}