-- tests/assert_lead_matching.sql
/*
  This test validates the core business logic in our model:
  1. No lead can be both a duplicate and net-new
  2. External source leads must be net-new
  3. Salesforce leads cannot be net-new
*/

with fact_lead_match as (
    select * from {{ ref('fact_lead_match') }}
)

-- Test case 1: Check for logical contradictions
select
    lead_key,
    source_key,
    is_duplicate_in_salesforce,
    is_net_new,
    'Invalid: Lead is both duplicate and net-new' as failure_reason
from fact_lead_match
where is_duplicate_in_salesforce = true and is_net_new = true

union all

-- Test case 2: Check that external source categorization is correct
select
    lead_key,
    source_key,
    is_duplicate_in_salesforce,
    is_net_new,
    'Invalid: External source lead not marked as net-new' as failure_reason
from fact_lead_match
where source_key != 'salesforce' and is_net_new = false

union all

-- Test case 3: Check that Salesforce leads are categorized correctly
select
    lead_key,
    source_key,
    is_duplicate_in_salesforce,
    is_net_new,
    'Invalid: Salesforce lead marked as net-new' as failure_reason
from fact_lead_match
where source_key = 'salesforce' and is_net_new = true