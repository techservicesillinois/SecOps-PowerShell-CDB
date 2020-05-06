build:
	pwsh -NoProfile -WorkingDirectory ${CURDIR} -Command 'Copy-Item -Path ".\UofICDB" -Destination "$$pshome\Modules" -Recurse -Force'
	pwsh -NoProfile -WorkingDirectory ${CURDIR} -Command 'Install-Module -Name UofIDMI -Force'