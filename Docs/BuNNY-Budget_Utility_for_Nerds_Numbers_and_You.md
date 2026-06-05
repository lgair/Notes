# Personal Finance Tracking & C++ Application Project Plan

## Project Goals

### Short-Term Goal

Build an Excel workbook that allows:

* Tracking income and expenses
* Monthly spending analysis
* Annual spending analysis
* Budget vs actual comparisons
* Spending categorization
* Dashboard visualization

### Long-Term Goal

Develop a desktop C++ application that:

* Imports banking transactions
* Stores data in a database
* Automatically categorizes spending
* Generates financial reports
* Tracks budgets
* Supports future multi-user expansion

---

# Phase 1: Excel Prototype

## Workbook Structure

### Sheet 1: Dashboard

Purpose:

* High-level financial overview

Contents:

* Current month income
* Current month expenses
* Current month savings
* Current month debt payments
* Year-to-date spending
* Cash flow

Charts:

* Spending by category
* Monthly income vs expenses
* Needs vs wants

---

### Sheet 2: Transactions

Purpose:

Single source of truth for all financial data.

Columns:

| Date | Description | Category | Subcategory | Type | Amount | Account |
| ---- | ----------- | -------- | ----------- | ---- | ------ | ------- |

Example:

| 2026-06-01 | Paycheck | Income | Salary | Income | 3200 | CIBC Chequing |
| 2026-06-02 | Rent | Housing | Rent | Expense | -1200 | CIBC Chequing |

Additional helper columns:

| Month    | Year |
| -------- | ---- |
| Jun-2026 | 2026 |

---

### Sheet 3: Budget

Purpose:

Compare planned spending against actual spending.

Example:

| Category      | Monthly Budget |
| ------------- | -------------- |
| Rent          | 1200           |
| Groceries     | 500            |
| Fuel          | 200            |
| Entertainment | 100            |

---

### Sheet 4: Pivots

Purpose:

Store all pivot tables.

Examples:

* Monthly spending
* Annual spending
* Spending by category
* Income by month
* Needs vs wants

---

### Sheet 5: Categories

Purpose:

Master category list.

Example:

| Category      | Subcategory | Type |
| ------------- | ----------- | ---- |
| Housing       | Rent        | Need |
| Food          | Groceries   | Need |
| Food          | Restaurants | Want |
| Entertainment | Gaming      | Want |

---

### Sheet 6: Accounts

Purpose:

Track accounts.

Example:

| Account       | Type        |
| ------------- | ----------- |
| CIBC Chequing | Bank        |
| Scotia Visa   | Credit Card |
| TFSA          | Investment  |

---

## Recommended Categories

### Income

* Salary
* Overtime
* Bonus
* Side Income
* Tax Refunds
* Investment Income

### Housing

* Rent
* Mortgage
* Insurance
* Repairs

### Utilities

* Electricity
* Gas
* Water
* Internet
* Cell Phone

### Food

* Groceries
* Restaurants
* Coffee

### Transportation

* Fuel
* Insurance
* Maintenance
* Registration
* Parking
* Transit

### Health

* Medical
* Dental
* Vision
* Prescriptions
* Fitness

### Personal

* Clothing
* Haircuts
* Toiletries

### Entertainment

* Games
* Streaming
* Hobbies
* Movies

### Travel

* Hotels
* Flights
* Camping

### Debt

* Credit Card
* Student Loan
* Car Loan
* Interest

### Savings & Investing

* TFSA
* RRSP
* Emergency Fund
* Brokerage

### Gifts & Charity

* Gifts
* Donations

### Miscellaneous

Catch-all category for rare expenses.

---

## Needs vs Wants Classification

Recommended values:

### Need

* Rent
* Groceries
* Utilities
* Fuel
* Insurance

### Want

* Restaurants
* Games
* Hobbies
* Entertainment

### Savings

* TFSA
* RRSP
* Emergency Fund

### Debt

* Loan payments
* Credit card payments

This enables powerful annual reporting.

---

# Transaction Import Strategy

## Recommended Approach

Use CSV exports from banks.

Supported accounts:

* CIBC Chequing
* Scotia Visa
* Future accounts

Workflow:

1. Download CSV from bank.
2. Save into Import folder.
3. Import into spreadsheet/application.
4. Categorize automatically.
5. Refresh reports.

---

## Why Not Use Bank APIs?

Advantages of CSV:

* Free
* Stable
* No authentication maintenance
* No third-party dependencies
* No security concerns

Canadian bank APIs are generally not available directly to consumers.

Most financial applications use aggregators.

Examples:

* Plaid
* Flinks
* MX

These add:

* Cost
* Complexity
* Security requirements

CSV import is recommended for Version 1.

---

# Future C++ Application Architecture

## Design Philosophy

The application should be designed around financial transactions.

Not:

* UI-first
* Database-first

But:

* Domain-first

---

# Core Domain Model

## User

Represents a person using the application.

Responsibilities:

* Owns accounts
* Owns budgets
* Owns transactions

---

## Account

Examples:

* CIBC Chequing
* Scotia Visa
* TFSA

Fields:

* Id
* Name
* Type

---

## Category

Examples:

* Food
* Housing
* Transportation

Supports hierarchy:

Food
├── Groceries
└── Restaurants

---

## Transaction

Most important object in the system.

Fields:

* Id
* Account
* Category
* Date
* Description
* Amount

Almost every report derives from transactions.

---

## Budget

Fields:

* Category
* Monthly limit

Used for budget tracking.

---

## Money Value Object

Avoid floating point.

Store money as:

* Integer cents

Example:

350000 cents = $3500.00

Benefits:

* Accuracy
* No rounding issues

---

# Layered Architecture

## Presentation Layer

Examples:

* Qt GUI
* CLI

Responsibilities:

* User interaction

---

## Service Layer

Examples:

* Reporting Service
* Import Service
* Budget Service

Responsibilities:

* Business operations

---

## Domain Layer

Contains:

* Transaction
* Account
* Category
* Budget
* Money

Should contain no:

* SQL
* Qt
* CSV logic

---

## Persistence Layer

Responsible for:

* Saving data
* Loading data

Implementation:

* SQLite

---

# Recommended Database

## SQLite

Reasons:

* Single file database
* No server required
* Fast
* Reliable
* Cross-platform
* Excellent C++ support

Database file:

finance.db

---

# Suggested Database Tables

## Users

Stores user accounts.

---

## Accounts

Stores:

* Bank accounts
* Credit cards
* Investments

---

## Categories

Stores category hierarchy.

---

## Transactions

Stores financial activity.

---

## Budgets

Stores budget limits.

---

# Multi-User Design

Even if only one user exists initially:

Add:

user_id

to major tables.

Benefits:

* Future expansion
* Multiple users
* Shared application support

Example:

Transaction
├── user_id
├── account_id
├── category_id
└── amount

---

# Import System

## Interface

Importer abstraction:

* Import file
* Return transactions

Implementations:

* CIBC Importer
* Scotia Importer
* Generic CSV Importer

Pattern:

Strategy Pattern

---

# Auto-Categorization System

Rules-based approach.

Examples:

SAVE ON FOODS
→ Groceries

SHELL
→ Fuel

AMAZON
→ Shopping

Rules:

* Merchant pattern
* Assigned category

Target:

80%+ automatic categorization.

---

# Reporting Engine

Reports should be generated by services.

Examples:

## Monthly Report

Shows:

* Income
* Expenses
* Savings
* Debt

---

## Annual Report

Shows:

* Spending by category
* Spending trends

---

## Cash Flow Report

Shows:

Income - Expenses - Debt - Savings

---

## Budget Report

Shows:

Budget vs Actual

---

# Recommended Design Patterns

## Repository Pattern

Used for persistence.

Examples:

* TransactionRepository
* AccountRepository
* CategoryRepository

---

## Strategy Pattern

Used for:

* CSV importers
* Categorization engines
* Report generators

---

## Factory Pattern

Used to create importers.

Example:

ImporterFactory

---

## Observer Pattern

Useful in GUI.

Examples:

Transaction Added
→ Dashboard Updates
→ Charts Update
→ Budget Updates

Qt signals/slots naturally support this.

---

# Patterns to Avoid Initially

Avoid overengineering.

Do not start with:

* Service Locator
* Event Bus
* CQRS
* Microservices
* Dependency Injection Frameworks
* Singleton-heavy designs

Keep Version 1 simple.

---

# Development Roadmap

## Phase 0

Excel Prototype

Duration:

2-4 weeks

Deliverable:

Working financial workbook.

---

## Phase 1

Domain Model

Duration:

1-2 weeks

Deliverable:

Core classes and tests.

---

## Phase 2

SQLite Integration

Duration:

2-3 weeks

Deliverable:

Persistent storage.

---

## Phase 3

CSV Import

Duration:

2-4 weeks

Deliverable:

Import transactions from banks.

---

## Phase 4

Reporting Engine

Duration:

2-3 weeks

Deliverable:

Monthly and annual reports.

---

## Phase 5

Auto Categorization

Duration:

2-3 weeks

Deliverable:

Automatic transaction categorization.

---

## Phase 6

Qt GUI

Duration:

4-8 weeks

Deliverable:

Usable desktop application.

---

## Phase 7

Dashboard & Charts

Duration:

2-4 weeks

Deliverable:

Visual reporting.

---

## Phase 8

Budget System

Duration:

2-3 weeks

Deliverable:

Budget tracking.

---

## Phase 9

Multi-Account Support

Duration:

1-2 weeks

Deliverable:

Support multiple financial accounts.

---

## Phase 10

Polish

Duration:

4-8 weeks

Deliverable:

Production-quality usability.

---

# Estimated Timeline

## 5 Hours per Week

Approximately:

10-12 months

---

## 10 Hours per Week

Approximately:

5-6 months

---

## 15+ Hours per Week

Approximately:

3-4 months

---

# Version 1 Scope

Include:

* SQLite
* CSV Import
* Categories
* Monthly Reports
* Annual Reports
* Budget Tracking
* Qt GUI

Do NOT include:

* Direct Bank APIs
* Cloud Sync
* Mobile Apps
* Investment Tracking
* Receipt Scanning
* AI Categorization
* Real-Time Synchronization

Focus on delivering a useful desktop application first.

---

# Success Criteria

A successful Version 1 should answer:

* How much did I spend this month?
* How much did I spend this year?
* What categories consume most of my money?
* Am I staying within budget?
* How much debt have I paid?
* How much have I saved?
