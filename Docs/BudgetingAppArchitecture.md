# Budgeting Application Project Architecture

## 1. Modules

### 1.1 Data Ingestion Module
- **CSV Parser**: A class to handle CSV file parsing.
- **XML Parser**: A class to handle XML file parsing.
- **JSON Parser**: A class to handle JSON file parsing.
- **Bank Statement Interface**: An abstract class for different bank formats.
- **Factory for Parsers**: A factory class to instantiate the appropriate parser based on file type.

### 1.2 Data Processing Module
- **Transaction Class**: Represents a single transaction (date, amount, category, description).
- **Account Class**: Represents bank accounts with methods to aggregate transactions and calculate balances.
- **Budgeting Class**: Contains budget categories and methods for calculating total expenditures and remaining budgets.
- **Loan Class**: Represents a loan with attributes like principal, APR, monthly payment, and methods for calculating payments, total principal paid, and total interest paid.

### 1.3 Debt Management Module
- **Debt Management Class**: Manages multiple loans, allows for additional payments, and updates principal and interest calculations.
- **Adjustable Loan Parameters**: Logic to handle APR changes and recalculate future payments while preserving historical data.

### 1.4 User Interface Module
- **Main Window**: Displays accounts, transactions, budget categories, and debts using Qt Widgets.
- **Input Forms**: For manual entry of transactions, budget categories, and loan details.
- **Visualization**: Charts/graphs for budget tracking and debt management (using Qt Charts).
- **Observer Pattern Implementation**: For automatic UI updates when data changes (e.g., transactions, budget, debts).

### 1.5 Persistence Layer
- **Database Layer**: Use SQLite or a similar lightweight database to store transactions, budgets, and loans.
- **File I/O**: To save/load application settings and user preferences.

## 2. Design Patterns

### 2.1 Model-View-Controller (MVC)
- Implement MVC architecture to separate business logic, data, and UI components.

### 2.2 Observer Pattern
- Use this pattern to notify the UI of changes in data (e.g., when transactions or budgets are updated).

### 2.3 Singleton Pattern
- Implement a singleton for managing application-wide settings or logging.

### 2.4 Factory Pattern
- Use the factory pattern to create instances of parsers and potentially other components (e.g., budget categories).

### 2.5 Strategy Pattern
- Allow dynamic switching between different budgeting strategies or debt repayment strategies.

### 2.6 Command Pattern
- Encapsulate actions like adding transactions or loans, which could support features like undo/redo.

### 2.7 Decorator Pattern
- Use this pattern to add functionalities dynamically, such as notifications for budget overspending.

## 3. Example Workflow

1. **Ingesting Statements**
   - User selects a file (CSV/XML/JSON).
   - The factory creates the appropriate parser instance based on the file type.
   - Parsed transactions are stored in the `Transaction` class instances.

2. **Categorizing Transactions**
   - Users can define budget categories.
   - The application maps transactions to these categories based on keywords or user-defined rules.

3. **Budget Calculation**
   - Users set budget limits for each category.
   - The application calculates total expenditures and alerts users when they exceed their budgets.

4. **Debt Management**
   - Users enter multiple loans, providing details like principal, APR, and monthly payment.
   - The application tracks total principal and interest paid, allowing for additional payments and adjustments to APR.

5. **Visualization and Reporting**
   - Users can view charts/graphs for both budgets and debts.
   - Reports are generated based on cumulative data across multiple months.

## 4. Conclusion

This updated architecture reflects the current state of your budgeting application project, incorporating all required functionalities, design patterns, and a structured approach to ensure maintainability and scalability.
