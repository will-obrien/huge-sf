global class GroupBy
{
    global static Map<Date, List<sObject>> dates( String field, List<sObject> records )
    {
        return dates(FieldReference.build(field), records);
    }

    global static Map<Date, List<sObject>> dates( SobjectField field, List<sObject> records )
    {
        return dates(FieldReference.build(field), records);
    }

    global static Map<Date, List<sObject>> dates( FieldReference field, List<sObject> records )
    {
        Map<Date, List<sObject>> returnMap = new Map<Date, List<sObject>>();

        for ( sObject record : records )
        {
            Date key = (Date)field.getFrom( record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<DateTime, List<sObject>> datetimes( String field, List<sObject> records )
    {
        return datetimes(FieldReference.build(field), records);
    }

    global static Map<DateTime, List<sObject>> datetimes( SobjectField field, List<sObject> records )
    {
        return datetimes(FieldReference.build(field), records);
    }

    global static Map<DateTime, List<sObject>> datetimes( FieldReference field, List<sObject> records )
    {
        Map<DateTime, List<sObject>> returnMap = new Map<DateTime, List<sObject>>();

        for ( sObject record : records )
        {
            DateTime key = (DateTime)field.getFrom( record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<Integer, List<sObject>> year( String date_field, List<sObject> records )
    {
        return year(FieldReference.build(date_field), records);
    }

    global static Map<Integer, List<sObject>> year( SobjectField date_field, List<sObject> records )
    {
        return year(FieldReference.build(date_field), records);
    }

    global static Map<Integer, List<sObject>> year( FieldReference date_field, List<sObject> records )
    {
        Map<Integer, List<sObject>> returnMap = new Map<Integer, List<sObject>>();
        for( sObject record : records )
        {
            Object fieldVal = date_field.getFrom( record );
            Integer yr;
            if( fieldVal != null )
            {
                yr = Date.valueOf( fieldVal ).year();
            }

            if( !returnMap.containsKey( yr ) )
            {
                returnMap.put( yr, new List<sObject>() );
            }
            returnMap.get( yr ).add( record );
        }
        return returnMap;
    }

    global static Map<Decimal, List<sObject>> decimals( String field, List<sObject> records )
    {
        return decimals(FieldReference.build(field), records);
    }

    global static Map<Decimal, List<sObject>> decimals( SobjectField field, List<sObject> records )
    {
        return decimals(FieldReference.build(field), records);
    }

    global static Map<Decimal, List<sObject>> decimals( FieldReference field, List<sObject> records )
    {
        Map<Decimal, List<sObject>> returnMap = new Map<Decimal, List<sObject>>();

        for ( sObject record : records )
        {
            Decimal key = (Decimal)field.getFrom( record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<Integer, List<sObject>> integers( String field, List<sObject> records )
    {
        return integers(FieldReference.build(field), records);
    }

    global static Map<Integer, List<sObject>> integers( SobjectField field, List<sObject> records )
    {
        return integers(FieldReference.build(field), records);
    }

    global static Map<Integer, List<sObject>> integers( FieldReference field, List<sObject> records )
    {
        Map<Integer, List<sObject>> returnMap = new Map<Integer, List<sObject>>();

        for ( sObject record : records )
        {
            Integer key = (Integer)field.getFrom( record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<Id, List<sObject>> ids( String field, List<sObject> records )
    {
        return ids(FieldReference.build(field), records);
    }

    global static Map<Id, List<sObject>> ids( SobjectField field, List<sObject> records )
    {
        return ids(FieldReference.build(field), records);
    }

    global static Map<Id, List<sObject>> ids( FieldReference field, List<sObject> records )
    {
        Map<Id, List<sObject>> returnMap = new Map<Id, List<sObject>>();

        for ( sObject record : records )
        {
            Id key = (Id)field.getFrom( record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<String, List<sObject>> strings( String field, List<sObject> records )
    {
        return strings(FieldReference.build(field), records);
    }

    global static Map<String, List<sObject>> strings( SobjectField field, List<sObject> records )
    {
        return strings(FieldReference.build(field), records);
    }

    global static Map<String, List<sObject>> strings( FieldReference field, List<sObject> records )
    {
        Map<String, List<sObject>> returnMap = new Map<String, List<sObject>>();

        for ( sObject record : records )
        {
            String key = (String)field.getFrom( record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<Boolean, List<sObject>> booleans(String field, List<sObject> records) {
        return booleans(FieldReference.build(field), records);
    }

    global static Map<Boolean, List<sObject>> booleans(SobjectField field, List<sObject> records) {
        return booleans(FieldReference.build(field), records);
    }

    global static Map<Boolean, List<sObject>> booleans(FieldReference field, List<sObject> records) {
        Map<Boolean, List<sObject>> returnMap = new Map<Boolean, List<sObject>>();
        for(sObject record : records) {
            Boolean key = (Boolean)field.getFrom(record);
            if(!returnMap.containsKey(key)) {
                returnMap.put(key, new List<sObject>());
            }
            returnMap.get(key).add(record);
        }
        return returnMap;
    }
}