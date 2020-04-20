---
external help file: UofICDB-help.xml
Module Name: UofICDB
online version:
schema: 2.0.0
---

# Get-CDBSubclassSchema

## SYNOPSIS
Returns the schema for the given CDB subclass.
This is a listing of the properties and their data types.
Useful for crafting filters for Get-CDBItem.

## SYNTAX

```
Get-CDBSubclassSchema [-SubClass] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the schema for the given CDB subclass.
This is a listing of the properties and their data types.
Useful for crafting filters for Get-CDBItem.

## EXAMPLES

### EXAMPLE 1
```
Get-CDBSubclassSchema -SubClass system
```

## PARAMETERS

### -SubClass
The specific type of item.
Ex: building, network, service, etc.
Tab completion is supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
