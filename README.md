# Lead Enrichment DBT Project

A dimensional modeling approach to standardize and enrich lead data from multiple sources for improved analytics.

## Project Overview    

This project implements a dimensional model that consolidates lead information from Salesforce and three external sources (Nevada, Oklahoma, and Texas facilities) to identify duplicates and discover net-new business opportunities.

## Trade-offs and Limitations

Given the 2-hour constraint, I made these strategic trade-offs:

### What I Prioritized

- Core dimensional structure with fact and dimension tables following star schema design
- Lead matching logic for duplicate and net-new lead identification
- Basic data quality tests for critical business rules
- Clean documentation of approach and design decisions

### What I Would Add With More Time

- Additional dimensions for geography, time, and status with proper hierarchies
- More sophisticated matching with fuzzy logic for business names and address standardization
- Enhanced testing framework with source-to-target reconciliation
- Performance optimization for larger data volumes

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

