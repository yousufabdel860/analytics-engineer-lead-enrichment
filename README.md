# Lead Enrichment DBT Project

A dimensional modeling approach to standardize and enrich lead data from multiple sources for improved analytics and decision-making.

## Project Overview    

This project implements a dimensional model that consolidates lead information from Salesforce and three external sources (Nevada, Oklahoma, and Texas facilities) to 
improve the accuracy of customer data, drive more efficient lead management, and maximize sales team effectiveness.

## Data Model ERD
![Screen Shot 2025-03-04 at 1 31 37 PM](https://github.com/user-attachments/assets/1595bff7-023e-428d-bd81-5203ec9ee851)


## Trade-Offs and Limitations

Given the 2-hour constraint, I made these strategic trade-offs:

### What I Prioritized

- **Core dimensional structure with immediate extensibility:** I implemented a proper
star schema design with dimension and fact tables but deliberately organized the code in a way that allows for easy addition of new sources and attributes. This approach allows for both immediate business value and a scalable foundation. The dimension tables are structured with surrogate keys and clear entity definitions that make relationship maintenance straightforward as the model evolves.
- **Modular transformation logic with clear responsibility boundaries:** I separated 
standardization (staging models) from business logic (dimensional models) to create clean layers of abstraction. Each layer has a distinct responsibility: staging handles 
standardization and cleaning, while dimensional models focus on business rules and relationships. This separation makes the solution more maintainable and ensures changes to source formats won't break downstream analytics.
- **Critical business logic for lead matching with clear lineage:** I focused on implementing robust duplicate and net-new lead identification using phone and email matching, as these deliver the highest immediate business value. The matching logic is designed to be both accurate and explainable to business users. I deliberately structured the matching to allow for clear auditing of results and iterative refinement over time.
- **Reusable patterns rather than one-off solutions:** I created consistent transformation patterns that can be applied across all sources, rather than source-specific  logic. This makes adding new sources more straightforward and reduces technical debt. The standardization of phone numbers, emails, and other attributes follows a consistent approach that can be extended to any new source with minimal adaptation.
- **Selective testing focused on business-critical logic:** I implemented targeted tests for the most important business rules (duplicate detection logic, net-new classification) rather than attempting comprehensive testing. This ensures the core functionality is reliable while staying within time constraints. These tests verify that the business logic works as expected, providing confidence in the results without excessive test coverage.


### What I Would Add With More Time
With additional time, I would enhance the solution in these key areas:

- **Extended dimensional framework with full hierarchies**: I would enhance the dimension model with several additions to support more sophisticated analytics:
    - **Geography Dimension:** A properly structured geographic hierarchy with standardized address components (street, city, region, state, postal code, country) to enable territory-based analysis, regional performance comparison, and spatial clustering of leads.
    - **Time Dimension:** A comprehensive time dimension with various date attributes and hierarchies (day, week, month, quarter, year) to support temporal analysis, seasonality detection, and trend identification across lead activities and conversions.
    - **Lead Status Dimension:** A robust status dimension with category groupings, valid state transitions, and status history tracking to analyze lead progression, identify bottlenecks, and optimize the conversion funnel.
    - **Lead Source Dimension:** A detailed hierarchy capturing acquisition channels, campaigns, and referral sources to enable attribution analysis and marketing effectiveness measurement.
    - **Industry/Segment Dimension:** Classification by business vertical, company size, and target market to support segment-specific analysis and strategic prioritization.
- **Advanced matching algorithms with confidence scoring**: I would implement fuzzy matching for business names using more techniques, proper address standardization and matching, and a weighted scoring system across multiple attributes to better evaluate match quality. This would provide more reliable duplicate detection and net-new lead identification, especially for records with partial or inconsistent information.
- **Comprehensive data quality framework with proactive monitoring**: I would create a more robust testing framework including source-to-target reconciliation, data profiling with distribution analysis, and quality score calculations for each lead record to ensure consistent, high-quality data. This would include automated alerting for anomaly detection and data quality dashboards showing trends over time.
- **Incremental processing with full change history:** While the current solution handles full refreshes, I would add change data capture patterns to efficiently process incremental updates and track historical changes using SCD Type 2 techniques when appropriate. This would create a full audit trail of lead changes over time, enabling historical analysis while optimizing processing efficiency.
- **Business-facing analytical views with domain-specific terminology:** I would create denormalized, business-friendly views designed specifically for sales team consumption patterns, with appropriate business terminology and calculated fields to drive adoption. These views would be optimized for specific use cases like territory management, lead prioritization, and campaign analysis.
- **Performance optimization for enterprise-scale:** For larger data volumes, I would implement proper indexing strategies, clustering keys, and query optimization techniques to ensure the solution scales efficiently as data grows. This would include benchmarking common query patterns and optimizing materialization strategies (table vs view) based on actual usage patterns.

## Long-Term ETL Strategy

For a production implementation, I recommend:

**Monthly 3rd Party File Processing:**

- Implement robust change data capture patterns with checkpointing to efficiently process monthly file loads
- Create a reconciliation framework to validate file completeness against expected record counts
- Develop a file archiving strategy with retention policies for historical reference and debugging
- Establish clear audit trails documenting each file's processing status and outcomes

**Schema Evolution Management:**

- Create a schema registry system to track and version control source file structures over time
- Implement dynamic schema detection and adaptation to handle changing file formats without code changes
- Develop impact analysis capabilities to assess how source changes affect downstream models
- Create automated testing of schema compatibility before production deployment

**Comprehensive Data Quality Framework:**

- Deploy multi-level data quality validation (source, staging, final models) with configurable rules
- Implement trend-based anomaly detection to identify statistical outliers in incoming data
- Create quality scorecards with historical tracking to monitor improvement over time
- Set up alerting with appropriate severity levels and escalation paths for different quality issues

**Business Accessibility Layer:**

- Create role-specific views tailored to different business functions (sales, marketing, operations)
- Develop comprehensive data dictionaries with business definitions and example usage
- Implement training materials and knowledge base for self-service analytics
- Establish feedback mechanisms to improve business value delivery continuously

**Performance and Scalability:**

- Design the architecture to handle growing data volumes with appropriate partitioning strategies
- Implement query optimization techniques specifically for common business access patterns
- Create appropriate materialization strategies balancing freshness and query performance
- Develop resource monitoring to proactively address performance bottlenecks

## Data Exploration Process

My systematic exploration of the source data informed the dimensional modeling approach:

1. **Source Structure Analysis:**
    - Conducted detailed field analysis across all sources to understand data types, patterns, and semantics
    - Documented primary and foreign key relationships within each source system
    - Identified critical business fields vs. operational metadata
    - Mapped conceptual entities across different source representations

2. **Cross-Source Relationship Identification:**
    - Evaluated potential joining fields (phone, email, business name) for match effectiveness
    - Analyzed the uniqueness and completeness of each identifier across sources
    - Determined phone numbers provided the highest match reliability as primary identifiers
    - Created a hierarchy of fallback identifiers to maximize match coverage

3. **Data Quality and Standardization Assessment:**
    - Profiled key fields to identify format inconsistencies (especially in phone, and email)
    - Analyzed null values and their distribution to understand data completeness
    - Identified duplicate patterns within each source to inform matching strategies
    - Developed standardization approaches for consistent cross-source comparison

4. **Matching Algorithm Development and Testing:**
    - Experimented with different matching criteria to balance precision and recall
    - Tested exact vs. partial matching strategies for different field types
    - Developed a multi-pass approach starting with the highest confidence matches
    - Created validation test cases to verify matching effectiveness

5. **Business Rule Extraction:**
    - Identified implied business rules in each source system
    - Documented status value mappings and their business significance
    - Analyzed lead lifecycle patterns to understand status transitions
    - Determined which source should be considered authoritative for each attribute

6. **Dimensional Model Prototyping:**
    - Sketched dimensional model alternatives to evaluate different approaches
    - Tested query patterns to ensure the model would support business requirements
    - Validated that the design could accommodate future sources and attributes
    - Refined the model based on exploration insights

## Testing and Data Validation

**Implemented Testing Approach**

The current implementation includes foundational quality measures focused on the most critical aspects of the model:

- **Schema Tests:** Basic tests ensuring primary key uniqueness in dimension tables and referential integrity between facts and dimensions
- **Custom Business Logic Test:** A targeted test validating our core lead matching logic, specifically checking that:
    - No lead is flagged as both duplicate and net-new (logical contradiction)
    - External source leads are properly identified as net-new
    - Salesforce leads are never incorrectly marked as net-new
- **Data Standardization:** Consistent transformation patterns for phone numbers and emails to ensure reliable comparison
- **Logical Flag Validation:** Verification that flag values in the fact table maintain logical consistency

These tests focus on validating the core functionality that directly supports the primary business questions identified. 

## Business Questions Addressed

This dimensional model makes it easy to answer key business questions with straightforward SQL queries:

1. **Are there duplicate leads based on the phone (primary identifier) in Salesforce ?**
```sql
-- Identify duplicate leads in Salesforce
SELECT
    l.lead_key,
    l.business_name, 
    l.phone, 
    l.email
FROM 
    fact_lead_match f
JOIN 
    dim_lead l ON f.lead_key = l.lead_key
WHERE 
    f.is_duplicate_in_salesforce = true
ORDER BY
    l.email, l.phone;
```

2. **Find net-new leads from external sources?**
```sql
-- Find net-new leads from external sources
SELECT 
    l.lead_key,
    l.business_name, 
    l.phone, 
    l.email,
    f.source_key
FROM 
    fact_lead_match f
JOIN 
    dim_lead l ON f.lead_key = l.lead_key
WHERE 
    f.is_net_new = true
ORDER BY 
    f.source_key;
```

3. **When was each lead loaded into Salesforce?**
```sql
-- Find when leads were loaded into SalesForce
SELECT 
    l.lead_key,
    l.business_name, 
    l.phone, 
    l.email,
    f.source_created_date as loaded_date
FROM 
    fact_lead_match f
JOIN 
    dim_lead l ON f.lead_key = l.lead_key
WHERE 
    f.source_key = 'salesforce'
ORDER BY 
    f.source_created_date;
```

4. **How many net-new leads are generated by each file ingested?**
```sql
-- Find every net-new lead generated by file ingest
SELECT 
    f.source_key,
    COUNT(*) as net_new_lead_count
FROM 
    fact_lead_match f
WHERE 
    f.is_net_new = true
GROUP BY 
    f.source_key;
```

5. **What percentage of existing leads are being worked?**
```sql
-- Find the percentage of existing leads being worked
SELECT 
    COUNT(CASE WHEN l.status IN ('Working', 'Assigned', 'Connected') THEN 1 END) * 100.0 / COUNT(*) as percentage_being_worked
FROM 
    dim_lead l
WHERE 
    l.source_system = 'salesforce';
```

6. **Which source gives the best-performing leads?**
```sql
-- Where do the best leads come from
SELECT 
    f.source_key,
    COUNT(*) as total_leads,
    SUM(CASE WHEN l.status = 'Working' THEN 1 ELSE 0 END) as working_leads,
    SUM(CASE WHEN l.status = 'Connected' THEN 1 ELSE 0 END) as connected_leads,
    AVG(f.match_confidence) as avg_match_quality
FROM 
    fact_lead_match f
JOIN 
    dim_lead l ON f.lead_key = l.lead_key
GROUP BY 
    f.source_key
ORDER BY 
    connected_leads DESC;
```
