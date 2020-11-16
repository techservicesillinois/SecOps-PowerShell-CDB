---
external help file: UofICDB-help.xml
Module Name: UofICDB
online version:
schema: 2.0.0
---

# Get-CDBItemPermission

## SYNOPSIS
Returns a given items CDB permissions.

## SYNTAX

```
Get-CDBItemPermission [[-Id] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Returns a given items CDB permissions.

## EXAMPLES

### EXAMPLE 1
```
Get-CDBItemPermission -id 1770
```

### EXAMPLE 2
```
Get-CDBItem -Id 1778 | Get-CDBItemPermission
```

## PARAMETERS

### -Id
The specific Id of the item you are looking for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
