# Vim Commands Guide

## Table of Contents
1. [Getting Started](#getting-started)
2. [Navigation Commands](#navigation-commands)
3. [Searching](#searching)
   - [Common Search Commands](#common-search-commands)
   - [Using Regular Expressions (REGEX)](#using-regular-expressions-regex)
4. [Editing Commands](#editing-commands)
5. [Vim Registers](#vim-registers)
6. [Tabs and Windows](#tabs-and-windows)
7. [Buffers](#buffers)
8. [Managing Folded Text](#managing-folded-text)
9. [Opening a Terminal](#opening-a-terminal)
10. [Visual Mode](#visual-mode)
11. [Additional Useful Commands](#additional-useful-commands)

## Getting Started
- **Open a File**:
  ```bash
  vim filename
  ```

- **Exit Vim**:
  ```bash
  :q            # Quit
  :q!           # Quit without saving
  :wq           # Save and quit
  ```

## Navigation Commands

### Basic Navigation
- **h**: Move left
- **j**: Move down
- **k**: Move up
- **l**: Move right

### Word Navigation
- **w**: Move to the start of the next word
- **b**: Move to the start of the previous word
- **e**: Move to the end of the current word

### Line Navigation
- **0**: Move to the beginning of the line
- **^**: Move to the first non-blank character of the line
- **$**: Move to the end of the line

### Page Navigation
- **Ctrl + f**: Move forward one page
- **Ctrl + b**: Move backward one page
- **Ctrl + d**: Move down half a page
- **Ctrl + u**: Move up half a page

### File Navigation
- **gg**: Go to the top of the file
- **G**: Go to the bottom of the file
- **:n**: Go to line number `n` (e.g., `:10` to go to line 10)

### Search Navigation
- **/**: Search forward for a pattern
- **?**: Search backward for a pattern
- **n**: Repeat the last search in the same direction
- **N**: Repeat the last search in the opposite direction

### Jumping to Marks
- **'a**: Jump to the beginning of line marked with `a`
- **``a**: Jump to the exact position marked with `a`

## Searching

### Common Search Commands
1. **Forward Search**:
   - **Command**: `/pattern`
   - **Description**: Searches forward for `pattern`.

2. **Backward Search**:
   - **Command**: `?pattern`
   - **Description**: Searches backward for `pattern`.

3. **Repeat Search**:
   - **Command**: `n`
   - **Description**: Repeats the last search in the same direction.

4. **Repeat Search in Opposite Direction**:
   - **Command**: `N`
   - **Description**: Repeats the last search in the opposite direction.

5. **Search for the Word Under Cursor**:
   - **Command**: `*`
   - **Description**: Searches forward for the word under the cursor.

6. **Search for the Previous Occurrence of the Word Under Cursor**:
   - **Command**: `#`
   - **Description**: Searches backward for the word under the cursor.

7. **Highlight All Matches**:
   - **Command**: `:set hlsearch`
   - **Description**: Enables highlighting of all matches for the last search.

8. **Clear Highlights**:
   - **Command**: `:nohlsearch`
   - **Description**: Clears the highlighting of the last search.

### Using Regular Expressions (REGEX)
- **Basic Usage**:
  - Vim supports regular expressions for advanced search patterns.
  - For example, to search for lines containing "foo" or "bar":
    ```vim
    /foo\|bar
    ```

- **Common Regex Patterns**:
  - `.` : Matches any single character.
  - `*` : Matches zero or more of the preceding character.
  - `^` : Matches the beginning of a line.
  - `$` : Matches the end of a line.
  - `[]` : Matches any one of the enclosed characters (e.g., `[abc]` matches `a`, `b`, or `c`).
  - `\d` : Matches any digit (equivalent to `[0-9]`).
  - `\w` : Matches any word character (letters, digits, or underscores).

- **Example Searches**:
  - To find lines starting with "Error":
    ```vim
    /^Error
    ```

  - To find lines containing a three-digit number:
    ```vim
    /\d\d\d
    ```

## Editing Commands
### Additional Useful Commands
- **i**: Enter insert mode before the cursor.
- **I**: Enter insert mode at the beginning of the line.
- **a**: Enter insert mode after the cursor.
- **A**: Enter insert mode at the end of the line.
- **o**: Open a new line below the current line.
- **O**: Open a new line above the current line.
- **Esc**: Exit insert mode.

### Saving and Exiting
- **:w**: Save the file.
- **:q**: Quit Vim.
- **:wq**: Save and quit.
- **:q!**: Quit without saving changes.

### Content Management
- **:%d**: Target & delete all lines in file.
- **:d^**: Delete from cursor to start of line.
- **:d$**: Delete from cursor to end of line.
- **:dG**: Delete from cursor to end of file.
- **:e!**: Clear the buffer and reload the file from disk.

### Undo and Redo
- **u**: Undo the last change.
- **Ctrl + r**: Redo the last undone change.

## Vim Registers
- **What are Registers?**: Vim registers are used to store text that you can copy, cut, and paste. Each register can hold a different piece of text.
  
- **Common Registers**:
  - **"**: The unnamed register, used for default yank and delete operations.
  - **0**: The yank register, stores text from the most recent yank operation.
  - **-**: The small delete register, stores text from the last delete operation that was less than one line.
  - **a-z**: Named registers, you can explicitly specify them for specific yanks or deletes (e.g., `"ay`, `"bd`).
  - **: (colon)**: Stores the last command line input.

- **Using Registers**:
  - **Yank (Copy)**: To copy text into a register, use `"aY` to copy into register `a`.
  - **Delete**: To delete text into a register, use `"bd` to delete into register `b`.
  - **Paste**: To paste from a register, use `"ap` to paste from register `a`.

## Tabs and Windows

### Creating and Managing Tabs
- **:tabnew**: Open a new tab.
- **:tabclose**: Close the current tab.
- **:tabnext** or **:tabn**: Move to the next tab.
- **:tabprevious** or **:tabp**: Move to the previous tab.
- **:tabfirst**: Move to the first tab.
- **:tablast**: Move to the last tab.

### Creating and Managing Windows
- **:split** or **:sp**: Split the window horizontally.
- **:vsplit** or **:vsp**: Split the window vertically.
- **Ctrl + w, w**: Switch to the next window.
- **Ctrl + w, h/j/k/l**: Navigate to the left/down/up/right window, respectively.
- **Ctrl + w, q**: Close the current window.

### Resizing Windows
- **Ctrl + w, +**: Increase the height of the current window.
- **Ctrl + w, -**: Decrease the height of the current window.
- **Ctrl + w, >**: Increase the width of the current window.
- **Ctrl + w, <**: Decrease the width of the current window.

## Buffers
- **:ls**: List all open buffers.
- **:buffer n** or **:b n**: Switch to buffer number `n`.
- **:bnext** or **:bn**: Switch to the next buffer.
- **:bprevious** or **:bp**: Switch to the previous buffer.
- **:bdelete n** or **:bd n**: Delete buffer number `n`.

## Managing Folded Text

### Unfolding Commands
- **zo**: Open (unfold) the fold under the cursor.
- **zO**: Open all folds at the current level.
- **zR**: Open all folds in the current buffer.

### Closing Folds
- **zc**: Close (fold) the fold under the cursor.
- **zC**: Close all folds at the current level.
- **zM**: Close all folds in the current buffer.

### Additional Commands
- **zd**: Delete the fold under the cursor (permanently removes the fold).
- **zf**: Create a fold from the current line to the specified line.

### Navigating Folds
- **[z**: Move to the previous fold.
- **]z**: Move to the next fold.

## Opening a Terminal
- **:terminal**: Open a terminal within the Vim session. You can run shell commands directly in this terminal.

## Visual Mode
- **v**: Enter visual mode to select text.
- **V**: Enter visual line mode (select whole lines).
- **Ctrl + v**: Enter visual block mode (select rectangular blocks).
