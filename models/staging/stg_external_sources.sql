-- models/staging/stg_external_sources.sql
-- Standardizes and combines external source data for lead enrichment

-- Nevada facilities
with nevada as (
    select
        "NAME" as business_name,                             -- Facility name
        regexp_replace("PHONE", '[^0-9]', '') as phone_clean, -- Standardized phone format
        null as email_clean,                                 -- Email not available in this source
        'nevada' as source_system                            -- Source tracking
    from {{ source('raw_data', 'NEVADA_FACILITIES') }}
),

-- Oklahoma facilities
oklahoma as (
    select
        "COMPANY" as business_name,                           -- Facility name
        regexp_replace("PHONE", '[^0-9]', '') as phone_clean, -- Standardized phone format
        lower(trim("EMAIL")) as email_clean,                  -- Normalized email format
        'oklahoma' as source_system                           -- Source tracking
    from {{ source('raw_data', 'OKLAHOMA_FACILITIES') }}
),

-- Texas operations
texas as (
    select
        "OPERATION_NAME" as business_name,                    -- Facility name
        regexp_replace("PHONE", '[^0-9]', '') as phone_clean, -- Standardized phone format
        lower(trim("EMAIL_ADDRESS")) as email_clean,          -- Normalized email format
        'texas' as source_system                              -- Source tracking
    from {{ source('raw_data', 'TEXAS_OPERATIONS') }}
),

-- Combine all external sources into a unified format
combined as (
    select * from nevada
    union all
    select * from oklahoma
    union all
    select * from texas
)

select * from combined