# Lead Enrichment DBT Project

A dimensional modeling approach to standardize and enrich lead data from multiple sources for improved analytics and decision making.

## Project Overview    

This project implements a dimensional model that consolidates lead information from Salesforce and three external sources (Nevada, Oklahoma, and Texas facilities) to 
improve the accuracy of customer data, drive more efficient lead management, and maximize sales team effectiveness.

## Trade-Offs and Limitations

Given the 2-hour constraint, I made these strategic trade-offs:

### What I Prioritized

- **Core dimensional structure with immediate extensibility:** I implemented a proper
star schema design with dimension and fact tables, but deliberately organized the code in a way that allows for easy addition of new sources and attributes. This approach allows for both immediate business value and a scalable foundation. The dimension tables are structured with surrogate keys and clear entity defintions that make relationship maintenance straightforward as the model evolves.
- **Modular transformation lgoic with clear responsibility boundaries:** I seperated 
standardization (staging models) from business logic (dimensional models) to create clean layers of abstration. Each layer has a distinct responsibility: staging handles 
standardization and cleaning, while dimensional models focus on business rules and relationships. This seperation makes the solution more maintainable and ensure changes to source formats won't break downstream analytics.
- **Critical business logic for lead matching with clear lineage:** I focused on implementing robust duplicate and net-new lead identification using phone and email matching, as these deliver the highest immediate business value. The matching logic is designed to be both accurate and explainable to business users. I deliberately structured the matching in a way that allows for clear auditing of results and iterative refinement over time.
- **Reusuable patterns rather than one-off solutions:** I created consistent transformation patterns that can be applied across all sources, rather than source-specefic logic. This makes adding new sources more straightforward and reduces technical debt. The standardization of phone numbers, emails, and other attributes follows a consistent approach that can be extended to any new source with minimal adaptation.
- **Selective testing focused on business-critical logic:** I implemented targeted tests for the most important business rules (duplicate detection logic, net-new classification) rather than attempting comprehensive testing. This ensures the core functionality is reliable while staying within time constraints. These tests verify that the business logic works as expected, providing confidence in the results without excessive test coverage.


### What I Would Add With More Time
With additional time, I would enhance the solution in these key areas:

- **Extended dimensional framework with full hierarchies**: I would add properly designed dimension tables for geography (with address standardization and hierarchy), time (for temporal analysis), and lead status (with category groupings and state transitions). These would enable more sophisticated analytical insights such as regional performance analysis, time-series trending, and lead status flow analysis. Each dimension would include both technical keys and business-friendly attributes to support various analytical needs.
- **Advanced matching algorithms with confidence scoring**: I would implement fuzzy matching for business names using more techniques, proper address standardization and matching, and a weighted scoring system across multiple attributes to better evaluate match quality. This would provide more reliable duplicate detection and net-new lead identification, especially for records with partial or inconsistent information.
- **Comprehensive data quality framework with proactive monitoring**: I would create a more robust testing framework including source-to-target reconciliation, data profiling with distribution analysis, and quality score calculations for each lead record to ensure consistent, high-quality data. This would include automated alerting for anomaly detection and data quality dashboards showing trends over time.
- **Incremental processing with full change history:** While the current solution handles full refreshes, I would add change data capture patterns to efficiently process incremental updates and track historical changes using SCD Type 2 techniques when appropriate. This would create a full audit trail of lead changes over time, enabling historical analysis while optimizing processing efficiency.
- **Business-facing analytical views with domain-specific terminology:** I would create denormalized, business-friendly views designed specifically for sales team consumption patterns, with appropriate business terminology and calculated fields to drive adoption. These views would be optimized for specific use cases like territory management, lead prioritization, and campaign analysis.
- **Performance optimization for enterprise scale:** For larger data volumes, I would implement proper indexing strategies, clustering keys, and query optimization techniques to ensure the solution scales efficiently as data grows. This would include benchmarking common query patterns and optimizing materialization strategies (table vs view) based on actual usage patterns.
- **Integration touchpoints for operational systems:** I would design integration points to feed enriched data back to operational systems, closing the loop between analytical and operational data. This might include APIs, webhooks, or scheduled data feeds to ensure sales teams have access to the enriched data in their day-to-day tools.

## Long-Term ETL Strategy

For a production implementation, I recommend:

- **Monthly 3rd Party File Processing:**

- Implement robust change data capture patterns with checkpointing to efficiently process monthly file loads
- Create a reconciliation framework to validate file completeness against expected record counts
- Develop a file archiving strategy with retention policies for historical reference and debugging
- Establish clear audit trails documenting each file's processing status and outcomes

- **Schema Evolution Management:**

- Create a schema registry system to track and version control source file structures over time
- Implement dynamic schema detection and adaptation to handle changing file formats without code changes
- Develop impact analysis capabilities to assess how source changes affect downstream models
- Create automated testing of schema compatibility before production deployment

- **Comprehensive Data Quality Framework:**

- Deploy multi-level data quality validation (source, staging, final models) with configurable rules
- Implement trend-based anomaly detection to identify statistical outliers in incoming data
- Create quality scorecards with historical tracking to monitor improvement over time
- Set up alerting with appropriate severity levels and escalation paths for different quality issues

- **Metadata-Driven Architecture:**

- Develop a metadata repository documenting all sources, transformations, and business rules
- Create configuration-driven pipelines that can adapt to new sources without code changes
- Implement field-level lineage tracking to understand the origin of each attribute
- Design a self-documenting framework that generates technical and business documentation

- **Business Accessibility Layer:**

- Create role-specific views tailored to different business functions (sales, marketing, operations)
- Develop comprehensive data dictionaries with business definitions and example usage
- Implement training materials and knowledge base for self-service analytics
- Establish feedback mechanisms to continuously improve business value delivery

- **Performance and Scalability:**

- Design the architecture to handle growing data volumes with appropriate partitioning strategies
- Implement query optimization techniques specifically for common business access patterns
- Create appropriate materialization strategies balancing freshness and query performance
- Develop resource monitoring to proactively address performance bottlenecks

## Data Exploration Process

My exploration followed these steps:

1. Analyzed source structures to understand available fields and relationships
2. Identified joining fields across sources (phone, email, business name)
3. Evaluated data quality and format consistency
4. Tested matching approaches to determine best primary and secondary identifiers

## Testing and Data Validation

The model includes these quality measures:

- Schema tests for primary key uniqueness and referential integrity
- Custom business rule tests to validate match logic
- Field standardization for consistent comparison
- Logical validation to prevent contradictory flags


