---
external help file: UofICDB-help.xml
Module Name: UofICDB
online version:
schema: 2.0.0
---

# Invoke-CDBRestCall

## SYNOPSIS
Makes a REST method call on the given relative URI for CDB.
Utilizes credentials created with New-CDBConnection.
It is reccomended to use Get-CDBItem unless you specifically have a use case not supported by that cmdlet.

## SYNTAX

```
Invoke-CDBRestCall [-RelativeURI] <String> [[-Filter] <String[]>] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Makes a REST method call on the given relative URI for CDB.
Utilizes credentials created with New-CDBConnection.
It is reccomended to use Get-CDBItem unless you specifically have a use case not supported by that cmdlet.

## EXAMPLES

### EXAMPLE 1
```
Invoke-CDBRestCall -RelativeURI /api/v2/supporthours/4/
```

This will return the object located at /api/v2/supporthours/4/

## PARAMETERS

### -RelativeURI
The relativeURI you wish to make a call to.
Ex: /api/v2/supporthours/4/

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

### -Filter
An optional set of filters for results.
Properties for a given SubClass can be found with Get-CDBSubclassSchema.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Limit on results returned.
The stock default is 20 and this is controled via the settings.json of the module.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:Settings.DefaultReturnLimit
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
{{ Fill Offset Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
