---
external help file: UofICDB-help.xml
Module Name: UofICDB
online version:
schema: 2.0.0
---

# Get-CDBItem

## SYNOPSIS
Returns item(s) from CDB given criteria.

## SYNTAX

### Id (Default)
```
Get-CDBItem [-Id <Int32>] [-Recursive] [<CommonParameters>]
```

### Filter
```
Get-CDBItem -SubClass <String> [-Filter <String[]>] [-Limit <Int32>] [-ReturnAll] [-Recursive]
 [<CommonParameters>]
```

### NetworkByHostIP
```
Get-CDBItem [-NetworkByHostIP <String>] [-Recursive] [<CommonParameters>]
```

## DESCRIPTION
Returns item(s) from CDB given criteria.

## EXAMPLES

### EXAMPLE 1
```
Get-CDBItem -id 1770
```

This will return the specific item with Id 1770

### EXAMPLE 2
```
Get-CDBItem -SubClass system -Filter 'ipv4_address=64.22.187.105'
```

This will return a system with the IP of 64.22.187.105.
Keep in mind CDB does not allow filtering on all properties.

## PARAMETERS

### -SubClass
The specific type of item.
Ex: building, network, service, etc.
Tab completion is supported.

```yaml
Type: String
Parameter Sets: Filter
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
An optional set of filters for results.
Properties for a given SubClass can be found with Get-CDBSubclassSchema.

```yaml
Type: String[]
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Limit on results returned.
The stock default is 20 and this is controled via the settings.json of the module.

```yaml
Type: Int32
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: $Script:Settings.DefaultReturnLimit
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnAll
Returns all items of the given SubClass from CDB.

```yaml
Type: SwitchParameter
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The specific Id of the item you are looking for.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkByHostIP
Returns the network item that the given IP address belongs to. Supports both IPv4 and IPv6.

```yaml
Type: String
Parameter Sets: NetworkByHostIP
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recursive
Attempt to resolve properties of objects that are links to other CDB items.

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
