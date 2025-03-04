-- models/dimensions/dim_lead.sql
-- Dimension table containing all unique leads across sources with Salesforce as primary source

with salesforce_leads as (
    -- Reference standardized Salesforce leads
    select * from {{ ref('stg_salesforce_leads') }}
),

external_sources as (
    -- Reference standardized external source data
    select * from {{ ref('stg_external_sources') }}
),

-- Create lead dimension records from Salesforce
sf_leads as (
    select
        -- Create surrogate key with source prefix for traceability
        'SF-' || lead_id as lead_key,           -- Surrogate key with source context
        business_name,                          -- Company/facility name
        first_name,                             -- Contact first name
        last_name,                              -- Contact last name
        phone_clean as phone,                   -- Standardized phone number
        email_clean as email,                   -- Standardized email address
        status,                                 -- Current lead status in Salesforce
        created_date,                           -- Lead creation timestamp
        source_system                           -- Source system identifier
    from salesforce_leads
),

-- Identify which external records match Salesforce leads
matching_records as (
    select distinct
        ext.source_system,                      -- External source identifier
        ext.business_name,                      -- Business name from external source
        ext.phone_clean,                        -- Phone number from external source
        ext.email_clean                         -- Email from external source
    from external_sources ext
    join sf_leads sf
        on (sf.phone = ext.phone_clean and sf.phone is not null and ext.phone_clean is not null)
        or (sf.email = ext.email_clean and sf.email is not null and ext.email_clean is not null)
),

-- Add net-new leads from external sources (those without Salesforce match)
external_leads as (
    select
        -- Create surrogate key for external leads using hash for uniqueness
        ext.source_system || '-' || md5(ext.business_name || coalesce(ext.phone_clean, '')) as lead_key,
        ext.business_name,                      -- Business name from external source
        null as first_name,                     -- Contact first name (not available)
        null as last_name,                      -- Contact last name (not available)
        ext.phone_clean as phone,               -- Standardized phone number
        ext.email_clean as email,               -- Standardized email address
        'Not In Salesforce' as status,          -- Special status for net-new leads
        current_timestamp() as created_date,    -- When this dimension record was created
        ext.source_system                       -- Source system identifier
    from external_sources ext
    left join matching_records mr
        on ext.source_system = mr.source_system
        and ext.business_name = mr.business_name
        and (ext.phone_clean = mr.phone_clean or (ext.phone_clean is null and mr.phone_clean is null))
        and (ext.email_clean = mr.email_clean or (ext.email_clean is null and mr.email_clean is null))
    where mr.source_system is null              -- Only include records that don't match Salesforce
)

-- Combine Salesforce and net-new external leads into unified dimension
select * from sf_leads
union all
select * from external_leads