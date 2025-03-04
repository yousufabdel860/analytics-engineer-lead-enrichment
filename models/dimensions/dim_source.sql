-- Simple source dimension
select
    source_system as source_key,
    case
        when source_system = 'salesforce' then 'Salesforce CRM'
        when source_system = 'nevada' then 'Nevada Facilities'
        when source_system = 'oklahoma' then 'Oklahoma Facilities'
        when source_system = 'texas' then 'Texas Operations'
    end as source_name,
    case
        when source_system = 'salesforce' then 'CRM'
        else 'External'
    end as source_category
from (
    select 'salesforce' as source_system
    union
    select 'nevada' as source_system
    union
    select 'oklahoma' as source_system
    union
    select 'texas' as source_system
)