# Reference Document for `.bash_functions`

This document provides a reference for the functions defined in your `.bash_functions` file. Each function is described with its purpose and usage.

## Table of Contents

- [Introduction](#introduction)
- [Function: cl](#function-cl)
- [Function: mkcd](#function-mkcd)
- [Function: backup](#function-backup)
- [Function: dusage](#function-dusage)
- [Function: last_status](#function-last_status)
- [Function: note](#function-note)
- [Function: extract](#function-extract)
- [Function: find_ext](#function-find_ext)
- [Function: MarkdownViewer](#function-MarkdownViewer)

## Introduction

The `.bash_functions` file contains custom Bash functions to enhance your command line experience. These functions simplify common tasks and streamline workflows.

## Function: cl

```bash
function cl() { ... }
```

- **Purpose**: Change the directory and list its contents.
- **Usage**: 
  - `cl <directory>`: Changes to the specified directory and lists its contents.
  - `cl`: If no directory is specified, changes to the home directory.

## Function: mkcd

```bash
function mkcd() { ... }
```

- **Purpose**: Create a directory and navigate into it.
- **Usage**: 
  - `mkcd <directory_name>`: Creates a directory with the given name and changes into it.

## Function: backup

```bash
function backup() { ... }
```

- **Purpose**: Create a backup of a specified file with a timestamp.
- **Usage**: 
  - `backup <file_name>`: Copies the specified file and appends the current date and time to the backup file name.

## Function: dusage

```bash
function dusage() { ... }
```

- **Purpose**: Show disk usage for a specified directory.
- **Usage**: 
  - `dusage <directory>`: Displays the disk usage of the specified directory in a human-readable format.

## Function: last_status

```bash
function last_status { ... }
```

- **Purpose**: Check the exit status of the most recent command.
- **Usage**: 
  - `last_status`: Prints the exit status of the last executed command.

## Function: note

```bash
function note() { ... }
```

- **Purpose**: Create a quick note and append it to a notes file.
- **Usage**: 
  - `note <note_text>`: Adds the specified text to `~/notes.txt`.

## Function: extract

```bash
function extract() { ... }
```

- **Purpose**: Extract files based on their extension.
- **Usage**: 
  - `extract <file>`: Automatically detects the file type and extracts it using the appropriate command (e.g., `tar`, `unzip`).

## Function: find_ext

```bash
function find_ext() { ... }
```

- **Purpose**: Find and list files with a specified extension in a given directory.
- **Usage**: 
  - `find_ext <extension>`: Searches for files with the specified extension in the current directory.
  - `find_ext <source_directory> <extension>`: Searches for files with the specified extension in the given directory.

### Examples

- `find_ext /path/to/source txt`: Searches for `.txt` files in the specified directory.
- `find_ext ./relative/path txt`: Searches for `.txt` files in a specified relative directory.
- `find_ext txt`: Searches for `.txt` files in the current directory.

## Function: MarkdownViewer

```bash
function MarkdownViewer() { ... }
```

- **Purpose**: Convert a Markdown file to HTML and display it using `lynx`.
- **Usage**: 
  - `MarkdownViewer <markdown_file>`: Converts the specified Markdown file to HTML and displays it in the terminal using `lynx`.
- **Example**:
  - `MarkdownViewer BashFunctions.md`: Converts and views the `BashFunctions.md` file.
