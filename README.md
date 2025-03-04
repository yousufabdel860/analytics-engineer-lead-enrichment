# Lead Enrichment DBT Project

A dimensional modeling approach to standardize and enrich lead data from multiple sources for improved analytics and decision making.

## Project Overview    

This project implements a dimensional model that consolidates lead information from Salesforce and three external sources (Nevada, Oklahoma, and Texas facilities) to 
improve the accuracy of customer data, drive more efficient lead management, and maximize sales team effectiveness.

## Trade-Offs and Limitations

Given the 2-hour constraint, I made these strategic trade-offs:

### What I Prioritized

- **Core dimensional structure with immediate extensibility:** I implemented a proper
star schema design with dimension and fact tables, but deliberately organized the code in a way that allows for easy addition of new sources and attributes. This approach allows for both immediate business value and a scalable foundation. By creating clear seperation between staging and dimensional layers, I ensured that the model can grow without requiring significant refactoring.
- **Modular transformation lgoic with clear responsibility boundaries:** I seperated 
standardization (staging models) from business logic (dimensional models) to create clean layers of abstration. Each layer has a distinct responsibility: staging handles 
standardization and cleaning, while dimensional models focus on business rules and relationships. This seperation makes the solution more maintainable and ensure changes to source formats won't break downstream analytics.
- **Critical business logic for lead matching with clear lineage:** I focused on implementing robust duplicate and net-new lead identification using phone and email matching, as these deliver the highest immediate business value. The matching logic is designed to be both accurate and explainable to business users. Every match decision can be traced back to specific attributes, making the system transparent rather than a "black box.
- **Reusuable patters that scale horizontally:** I created consistent transformation
patters that can be applied across all sources, rather than source-specefic logic. This makes adding new sources more straightforward and reduces technical debt. The pattern established with the current sources can be directly applied to new ones with minimal adaptation, allowing the system to grow organically.
- **Selective testing focused on business-critical logic:** I implemented targeted tests for the most important business rules (duplicate detection logic, net-new classification) rather than attempting comprehensive testing. This ensures the core functionality is reliable while staying within time constraints. These tests verify that the business logic works as expected, providing confidence in the results without excessive test coverage.
- **Strategic denormalization where appropriate:** While following dimensional modeling principles, I made conscious decisions about when to denormalize for query performance. This balanced approach ensures analytical queries remain performant while maintaining proper data modeling practices.


### What I Would Add With More Time
With additional time, I would enhance the solution in these key areas:

- **Extended dimensional framework with full hierarchies**: I would add properly designed dimension tables for geography (with address standardization and hierarchy), time (for temporal analysis), and lead status (with category groupings and state transitions). These would enable more sophisticated analytical capabilities such as regional performance analysis, time-series trending, and lead status flow analysis. Each dimension would include both technical keys and business-friendly attributes to support various analytical needs.
- **Advanced matching algorithms with confidence scoring**: I would implement fuzzy matching for business names using techniques like Levenshtein distance or phonetic algorithms, proper address standardization and matching, and a weighted scoring system across multiple attributes to improve match rates and confidence. Each match would receive a detailed confidence score based on multiple attributes, potentially using machine learning for entity resolution in complex cases.
- **Comprehensive data quality framework with proactive monitoring**: I would create a more robust testing framework including source-to-target reconciliation, data profiling with distribution analysis, and quality score calculations for each lead record to ensure consistent, high-quality data. This would include automated alerting for anomaly detection and data quality dashboards showing trends over time.
- **Incremental processing with full change history:** While the current solution handles full refreshes, I would add change data capture patterns to efficiently process incremental updates and track historical changes using SCD Type 2 techniques when appropriate. This would create a full audit trail of lead changes over time, enabling historical analysis while optimizing processing efficiency.
- **Business-facing analytical views with domain-specific terminology:** I would create denormalized, business-friendly views designed specifically for sales team consumption patterns, with appropriate business terminology and calculated fields to drive adoption. These views would be optimized for specific use cases like territory management, lead prioritization, and campaign analysis.
- **Performance optimization for enterprise scale:** For larger data volumes, I would implement proper indexing strategies, clustering keys, and query optimization techniques to ensure the solution scales efficiently as data grows. This would include benchmarking common query patterns and optimizing materialization strategies (table vs view) based on actual usage patterns.
- **Metadata repository and documentation:** I would create a comprehensive metadata repository documenting the lineage, business definitions, and technical details of each field. This would include data dictionaries, business glossaries, and field-level lineage to support both technical and business users in understanding and trusting the data.
- **Integration touchpoints for operational systems:** I would design integration points to feed enriched data back to operational systems, closing the loop between analytical and operational data. This might include APIs, webhooks, or scheduled data feeds to ensure sales teams have access to the enriched data in their day-to-day tools.

## Long-term ETL Strategy

For a production implementation, I recommend:

- Change data capture patterns to handle monthly file loads efficiently
- Schema evolution handling to adapt to changing file formats
- Data quality monitoring with alerting for anomalies
- Metadata-driven transformations to simplify adding new sources
- Documentation and lineage for business user understanding

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


