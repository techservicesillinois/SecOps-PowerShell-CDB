try{
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Publish-Module -Path '.\src\UofICDB' -Repository PSGallery -NuGetApiKey $ENV:NuGetApiKey -Force
}
catch{
    throw $_
}