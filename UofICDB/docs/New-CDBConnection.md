---
external help file: UofICDB-help.xml
Module Name: UofICDB
online version:
schema: 2.0.0
---

# New-CDBConnection

## SYNOPSIS
This cmdlet will cache your CDB credentials for the session to be used with the other cmdlets in the UofICDB module.

## SYNTAX

```
New-CDBConnection [-Credential] <PSCredential> [-Save] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will cache your CDB credentials for the session to be used with the other cmdlets in the UofICDB module.

## EXAMPLES

### EXAMPLE 1
```
$Credential = Get-Credential
New-CDBConnection -Credential $Credential
```

## PARAMETERS

### -Credential
Your CDB API credentials.
This will likely not bet your NetID

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Save
{{ Fill Save Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
