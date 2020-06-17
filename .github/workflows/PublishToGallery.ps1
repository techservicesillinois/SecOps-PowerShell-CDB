try{
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Publish-Module -Path ".\UofICDB" -Repository PSGallery -NuGetApiKey $ENV:NuGetApiKey -Force
}
catch{
    throw $_
}