# What is This?
This is a PowerShell integration for Contacts Database (CDB). This is the system of record for system/asset ownership.

# How do I install it?
1) Install Powershell 7, you have options for this. [Chocolatey](https://chocolatey.org/packages/powershell-core) or [GitHub](https://github.com/PowerShell/PowerShell/releases).
2) Use the provided Makefile or manually copy the .\UofICDB folder to a valid PSModulePath directory. The Makefile will also install the UofIDMI module from the PSGallery.
3) The below will prompt you for credentials and then securely cache them on your machine.
   ```
   Import-Module UofICDB
   New-CDBConnection -Save
   ```

# How does it work?
1) You will initiate a connection to CDB with New-CDBConnection. Optionally storing your credentials. These will be API specific credentials and not your NetID.
2) Get-CDBItem will be the primary cmdlet at this point. This will be used to make queries and get information back.
3) Invoke-CDBRestCall is a generic way to make rest calls if you need to do something not supported by Get-CDBItem.
4) If you need a reference of SubClasses properties to craft a filter you can use Get-CDBSubClassSchema to get a listing back.

# How do I help?
1) Ensure naming schemes are kept consistent with the Verb-CDBNoun convention.
2) Ensure the docs folder is kept up to date as well as the comment based help. The docs are generated via the PlatyPS.
3) Any new functionality should have associated pester tests added to the UofIDMI.Tests.ps1 file and by extension no PR should be accepted without passing pester tests.
4) Ensure that cross platform support is kept in mind. The actions are configured to test on Ubuntu as well as Windows.

# Use cases
1) Finding the network owner for a given IP address via pairing with the [UofIDMI module](https://www.powershellgallery.com/packages/UofIDMI).
   ```
   Get-CDBItem -NetworkByHostIP '192.168.1.1' | Get-DMIDepartment
   ```