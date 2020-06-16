[String]$ModuleRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'UofICDB'
Import-Module -Name $ModuleRoot -ArgumentList $True

BeforeAll {
    $secStringPassword = ConvertTo-SecureString -String $ENV:TestAPIPw -AsPlainText
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($ENV:TestAPIUser, $secStringPassword)

    [int]$TestId = 1770 #This will likely break at some point and need updating. We have tests based around this object existing in CDB.
}

Describe 'New-CDBConnection'{
    context 'Non-saved credentials'{
        It 'Does not throw'{
            {New-CDBConnection -Credential $Credential} | Should -Not -Throw
        }

        InModuleScope 'UofICDB' {
            It 'Sets the credentials at the module level'{
                $Script:Authorization -ne [String]::Empty | Should -Be $True
            }
        }
    }

    context 'Saved credentials'{
        BeforeAll {
            New-CDBConnection -Credential $Credential -Save
        }

        InModuleScope 'UofICDB' {
            It 'Saves credentials when told to'{
                Test-Path -Path $Script:SavedCredsDir | Should -Be $True
            }

            It 'Encrypts the content of the file'{
                {Get-Content -Path $Script:SavedCredsDir | ConvertTo-SecureString} | Should -Not -Throw
            } 
        }
    }
}

Describe 'Update-CDBSubclassUris'{
    BeforeAll {
        New-CDBConnection -Credential $Credential
    }

    InModuleScope 'UofICDB' {      
        It 'Does not throw'{
            {Update-CDBSubclassUris} | Should -Not -Throw
        }

        It 'Populates the subclass URI cache'{
            ($Script:SubClassURIs.keys | Measure-Object).Count -gt 0 | Should -Be $True
        }

        It 'Makes a hashtable of the results'{
            $Script:SubClassURIs -is [Hashtable] | Should -Be $True
        }
    }
}

Describe 'Get-CDBSubclassSchema'{
    BeforeAll {
        New-CDBConnection -Credential $Credential
    }

    It 'Does not throw'{
        {Get-CDBSubclassSchema -SubClass 'network'} | Should -Not -Throw
    }

    It 'Returns a single schema'{
        (Get-CDBSubclassSchema -SubClass 'network' | Measure-Object).Count -eq 1 | Should -Be $True
    }

    It 'Returns a schema with properties'{
        (Get-CDBSubclassSchema -SubClass 'network' | Get-Member | Where-Object -FilterScript {$_.membertype -eq 'NoteProperty'} | Measure-Object).Count -gt 1 | Should -Be $True
    }
}

Describe 'Assert-IPAddress'{
    InModuleScope 'UofICDB' {
        It 'Throws on an invalid IP'{
            {Assert-IPAddress -IPAddress 'Not an IP'} | Should -Throw
        }

        It 'Ignores white space'{
            {Assert-IPAddress -IPAddress '   192.168.1.1    '} | Should -Not -Throw
        }

        It 'Validates IPv4'{
            $IPv4 = (Assert-IPAddress -IPAddress '192.168.1.1')
            $IPv4.IsValid | Should -Be $True
            $IPv4.IPAddress | Should -Be '192.168.1.1'
            $IPv4.AddressFamily | Should -Be 'v4'
        }

        It 'Validates IPv6'{
            $IPv4 = (Assert-IPAddress -IPAddress '2001:db8::1:0:0:1')
            $IPv4.IsValid | Should -Be $True
            $IPv4.IPAddress | Should -Be '2001:db8::1:0:0:1'
            $IPv4.AddressFamily | Should -Be 'v6'
        }
    }
}

Describe 'Get-CDBItem'{
    BeforeAll {
        New-CDBConnection -Credential $Credential
    }
    
    It 'Handles the redirect off an Id'{
        $null -eq (Get-CDBItem -id $TestId).subclass | Should -Be $True
        $null -ne (Get-CDBItem -id $TestId).name | Should -Be $True
    }

    It 'Accepts pipeline input for Id'{
        ($TestId | Get-CDBItem | Measure-Object).count | Should -Be 1
    }

    It 'Correctly filters'{
        (Get-CDBItem -SubClass system -Filter 'ipv4_address=64.22.187.105').ipv4_address -eq '64.22.187.105' | Should -Be $True
    }

    It 'Respects the limit specified'{
        (Get-CDBItem -SubClass network -Limit 20 | Measure-Object).Count -eq 20 | Should -Be $True
        (Get-CDBItem -SubClass network -Limit 40 | Measure-Object).Count -eq 40 | Should -Be $True
    }

    It 'Resolves relative URIs as properties with recursive specified'{
        (Get-CDBItem -id $TestId -Recursive).support_hours -is [PSCustomObject] | Should -Be $True
        (Get-CDBItem -id $TestId -Recursive).contacts[0].name | Should -Not -Be $Null
    }

    It 'Returns all possible items when -ReturnAll is specified'{
        (Get-CDBItem -SubClass 'building' -ReturnAll | Measure-Object).Count -gt 1000 | Should -Be $True
    }

    context 'IPv4'{
        It 'Returns network information for a provided IP'{
            (Get-CDBItem -NetworkByHostIP '128.174.118.224' | Measure-Object).count -gt 0 | Should -Be $True
        }

        It 'Throws if no network on CDB contains the IP'{
            {Get-CDBItem -NetworkByHostIP '192.168.1.1'} | Should -Throw
        }
    }

    context 'IPv6'{
        It 'Returns a single network for a provided IP'{
            (Get-CDBItem -NetworkByHostIP '2620:0:e00:4000::000a' | Measure-Object).count -gt 0 | Should -Be $True
        }

        It 'Throws if no network on CDB contains the IP'{
            {Get-CDBItem -NetworkByHostIP '2001:db8::1:0:0:1'} | Should -Throw
        }
    }
}