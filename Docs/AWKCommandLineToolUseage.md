# Using the `awk` Command Line Tool

## Table of Contents
1. [Basic Syntax](#basic-syntax)
2. [Common Operations](#common-operations)
   - [Print Specific Columns](#print-specific-columns)
   - [Using Conditions](#using-conditions)
   - [Field Separator](#field-separator)
   - [Built-in Variables](#built-in-variables)
   - [Pattern Matching](#pattern-matching)
   - [Calculations](#calculations)
   - [Output Formatting](#output-formatting)
3. [Combining with Other Commands](#combining-with-other-commands)
4. [Example Use Cases](#example-use-cases)

## Basic Syntax

The general syntax of the `awk` command is:

```bash
awk 'pattern { action }' input-file
```

- **`pattern`**: Specifies the condition that must be met for the action to be executed. If omitted, the action applies to all lines.
- **`action`**: Defines what to do with the lines that match the pattern. If omitted, `awk` prints the matching lines by default.
- **`input-file`**: The file to be processed. If no file is specified, `awk` reads from standard input.

## Common Operations

### Print Specific Columns

To print specific columns from a file:

```bash
awk '{ print $1, $3 }' file.txt
```

**Example Input (`file.txt`):**
```
Alice 21 Engineer
Bob 25 Designer
Charlie 30 Manager
```

**Example Output:**
```
Alice Engineer
Bob Designer
Charlie Manager
```

### Using Conditions

You can use conditions to filter the output:

```bash
awk '$2 > 25 { print $1 }' file.txt
```

**Example Input (`file.txt`):**
```
Alice 21 Engineer
Bob 25 Designer
Charlie 30 Manager
```

**Example Output:**
```
Charlie
```

### Field Separator

If your fields are separated by something other than whitespace (e.g., commas):

```bash
awk -F, '{ print $1 }' file.csv
```

**Example Input (`file.csv`):**
```
Alice,21,Engineer
Bob,25,Designer
Charlie,30,Manager
```

**Example Output:**
```
Alice
Bob
Charlie
```

### Built-in Variables

`awk` has built-in variables that can be useful:

- **`NR`**: Number of records (lines) processed.
- **`NF`**: Number of fields in the current record.

```bash
awk '{ print NR, $0 }' file.txt
```

**Example Input (`file.txt`):**
```
Alice 21 Engineer
Bob 25 Designer
```

**Example Output:**
```
1 Alice 21 Engineer
2 Bob 25 Designer
```

### Pattern Matching

You can match patterns using regular expressions:

```bash
awk '/Engineer/ { print $0 }' file.txt
```

**Example Input (`file.txt`):**
```
Alice 21 Engineer
Bob 25 Designer
Charlie 30 Manager
```

**Example Output:**
```
Alice 21 Engineer
```

### Calculations

`awk` can perform arithmetic operations:

```bash
awk '{ sum += $1 } END { print sum }' numbers.txt
```

**Example Input (`numbers.txt`):**
```
10
20
30
```

**Example Output:**
```
60
```

### Output Formatting

You can format output using `printf`:

```bash
awk '{ printf "%-10s %-10s\n", $1, $2 }' file.txt
```

**Example Input (`file.txt`):**
```
Alice 21
Bob 25
Charlie 30
```

**Example Output:**
```
Alice      21        
Bob        25        
Charlie    30        
```

## Combining with Other Commands

You can combine `awk` with other command-line tools using pipes:

```bash
cat file.txt | awk '{ print $1 }'
```

**Example Input (`file.txt`):**
```
Alice 21 Engineer
Bob 25 Designer
```

**Example Output:**
```
Alice
Bob
```

## Example Use Cases

### Extracting Usernames from `/etc/passwd`

To extract usernames from the system's password file:

```bash
awk -F: '{ print $1 }' /etc/passwd
```

**Example Output:**
```
root
daemon
bin
...
```

### Finding Lines with a Specific Word

To find lines containing a specific word, such as "error":

```bash
awk '/error/ { print }' log.txt
```

**Example Input (`log.txt`):**
```
Info: System started
Error: Disk not found
Warning: Low memory
```

**Example Output:**
```
Error: Disk not found
```

### Calculating Average

To calculate the average from a list of numbers in a file:

```bash
awk '{ total += $1; count++ } END { print total/count }' numbers.txt
```

**Example Input (`numbers.txt`):**
```
10
20
30
40
```

**Example Output:**
```
25
```
