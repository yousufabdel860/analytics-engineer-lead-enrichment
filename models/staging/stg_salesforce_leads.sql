-- models/staging/stg_salesforce_leads.sql
-- Standardizes and cleans Salesforce lead data for dimensional modeling

with source as (
    -- Extract data from source table
    select * from {{source('raw_data', 'SALESFORCE_LEADS')}}
),

standardized as (
    select 
        -- Core lead identification
        id as lead_id,                          -- Unique identifier from Salesforce
        company as business_name,               -- Company/facility name
        first_name,                             -- Contact first name
        last_name,                              -- Contact last name

        -- Clean and standardize contact information
        regexp_replace(phone, '[^0-9]', '') as phone_clean,     -- Remove non-numeric characters from phone
        lower(trim(email)) as email_clean,                      -- Standardize email format

        -- Lead status information
        status,                                 -- Current status in Salesforce
        created_date,                           -- When the lead was created

        -- Source tracking for lineage
        'salesforce' as source_system           -- Identifies origin system
    from source
    where is_deleted = 'FALSE'                  -- Exclude deleted records
)

select * from standardized