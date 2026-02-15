# Migration Tools

This directory contains tools to help migrate data and configuration from the Ethereum-based DCN to the Canton-based DCN.

## Planned Tools

### 1. Data Export Tool
- Exports user accounts from Ethereum DCN
- Exports exchange registrations
- Exports asset registrations
- Exports historical settlement data

### 2. Data Import Tool
- Imports user accounts to Canton DCN
- Imports exchange registrations
- Imports asset registrations
- Validates data integrity

### 3. Balance Migration Tool
- Exports user balances from Ethereum
- Calculates correct balances considering pending settlements
- Imports balances to Canton

### 4. Configuration Mapper
- Maps Ethereum configuration to Canton configuration
- Translates gas limits to Canton equivalents
- Maps addresses to Canton parties

## Usage

Tools will be implemented as the migration progresses. Each tool will have its own documentation and usage instructions.

## Status

🚧 Under Development

These tools will be developed during Phase 3 (Data Migration Strategy) of the Canton migration plan.

See [CANTON_MIGRATION_PLAN.md](../CANTON_MIGRATION_PLAN.md) for the full migration timeline.
