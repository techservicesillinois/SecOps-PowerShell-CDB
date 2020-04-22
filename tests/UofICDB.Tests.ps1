[String]$ModuleRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'UofICDB'
Import-Module -Name $ModuleRoot -ArgumentList $True

$secStringPassword = ConvertTo-SecureString -String $ENV:TestAPIPw -AsPlainText
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($ENV:TestAPIUser, $secStringPassword)

[int]$TestId = 1770 #This will likely break at some point and need updating. We have tests based around this object existing in CDB.

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
        New-CDBConnection -Credential $Credential -Save

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
    New-CDBConnection -Credential $Credential

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
    New-CDBConnection -Credential $Credential

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

Describe 'Get-CDBItem'{
    New-CDBConnection -Credential $Credential
    
    It 'Handles the redirect off an Id'{
        $null -eq (Get-CDBItem -id $TestId).subclass | Should -Be $True
        $null -ne (Get-CDBItem -id $TestId).name | Should -Be $True
    }

    It 'Correctly filters'{
        (Get-CDBItem -SubClass system -Filter 'ipv4_address=64.22.187.105').ipv4_address -eq '64.22.187.105' | Should -Be $True
    }

    It 'Respects the limit specified'{
        (Get-CDBItem -SubClass network -Limit 20 | Measure-Object).Count -eq 20 | Should -Be $True
        (Get-CDBItem -SubClass network -Limit 40 | Measure-Object).Count -eq 40 | Should -Be $True
    }

    It 'Resolves relative URIs as properties with recursive specified'{
        (Get-CDBItem -id $TestId -Recursive).support_hours -is [string]
    }

    It 'Returns all possible items when -ReturnAll is specified'{
        (Get-CDBItem -SubClass 'building' -ReturnAll | Measure-Object).Count -gt 1000 | Should -Be $True
    }
}