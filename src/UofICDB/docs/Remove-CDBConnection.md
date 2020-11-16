---
external help file: UofICDB-help.xml
Module Name: UofICDB
online version:
schema: 2.0.0
---

# Remove-CDBConnection

## SYNOPSIS
This cmdlet will clear cached CDB credentials.

## SYNTAX

```
Remove-CDBConnection [-ClearSaved] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will clear cached CDB credentials.

## EXAMPLES

### EXAMPLE 1
```
Remove-CDBConnection
```

### EXAMPLE 2
```
Remove-CDBConnection -ClearSaved
```

## PARAMETERS

### -ClearSaved
This will remove the saved credentials as well as the session credentials.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
