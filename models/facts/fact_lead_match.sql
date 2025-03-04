-- models/facts/fact_lead_match.sql
-- Fact table for lead matching, identifying duplicates and net-new leads

with dim_lead as (
    -- Reference the lead dimension
    select * from {{ ref('dim_lead') }}
),

-- Identify potential duplicates within Salesforce based on phone or email
duplicate_check as (
    select 
        dl1.lead_key,
        max(case when dl1.source_system = 'salesforce' 
                  and dl2.source_system = 'salesforce'
                  and dl1.lead_key != dl2.lead_key
                  and ((dl1.phone = dl2.phone and dl1.phone is not null)
                       or (dl1.email = dl2.email and dl1.email is not null))
                then true else false end) as is_duplicate
    from dim_lead dl1
    left join dim_lead dl2 
        on (dl1.phone = dl2.phone and dl1.phone is not null)
        or (dl1.email = dl2.email and dl1.email is not null)
    group by dl1.lead_key
),

-- Create fact records for lead matches and their attributes
matches as (
    select
        dl.lead_key,                              -- Foreign key to dim_lead
        dl.business_name,                         -- Business name for easier analysis
        dl.phone,                                 -- Phone for easier analysis
        dl.email,                                 -- Email for easier analysis
        dl.source_system as source_key,           -- Foreign key to dim_source
        dl.status as status_key,                  -- Foreign key to dim_status
        
        -- Flag for duplicate detection in Salesforce
        coalesce(dc.is_duplicate, false) as is_duplicate_in_salesforce,
        
        -- Flag for net-new leads from external sources
        case when dl.source_system != 'salesforce' then true else false end as is_net_new,
        
        -- Confidence score for match quality
        case
            when dl.source_system = 'salesforce' then 1.0  -- Direct source = highest confidence
            else 0.9                                       -- External source = high confidence
        end as match_confidence,
        
        dl.created_date as source_created_date    -- When lead was created in source system
    from dim_lead dl
    left join duplicate_check dc on dl.lead_key = dc.lead_key
)

select * from matches