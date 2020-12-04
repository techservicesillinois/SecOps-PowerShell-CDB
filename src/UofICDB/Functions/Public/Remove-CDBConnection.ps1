<#
.Synopsis
   This cmdlet will clear cached CDB credentials.
.DESCRIPTION
   This cmdlet will clear cached CDB credentials.
.PARAMETER ClearSaved
    This will remove the saved credentials as well as the session credentials.
.EXAMPLE
    Remove-CDBConnection
.EXAMPLE
    Remove-CDBConnection -ClearSaved
#>
function Remove-CDBConnection {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Switch]$ClearSaved
    )

    begin {
    }

    process {
        if($PSCmdlet.ShouldProcess("Clearing CDB connection")){
            $Script:Authorization = $Null
        }

        if($ClearSaved){
            if($PSCmdlet.ShouldProcess("Removing cached credentials at $($Script:SavedCredsDir)")){
                Remove-Item -Path $Script:SavedCredsDir -Force
            }
        }
    }

    end {
    }
}
