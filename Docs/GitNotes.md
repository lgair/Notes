# Common and Useful Git Commands

## Table of Contents
1. [Getting Started](#getting-started)
2. [Basic Commands](#basic-commands)
3. [Branching](#branching)
4. [Merging and Rebasing](#merging-and-rebasing)
5. [Stashing Changes](#stashing-changes)
6. [Working with Submodules](#working-with-submodules)
7. [Viewing Changes](#viewing-changes)
8. [Undoing Changes](#undoing-changes)
9. [Remote Repositories](#remote-repositories)
10. [Miscellaneous Commands](#miscellaneous-commands)

## Getting Started
- **Initialize a New Repository**:
  ```bash
  git init
  ```

- **Clone an Existing Repository**:
  ```bash
  git clone <repository-url>
  ```

## Basic Commands
- **Check Status**:
  ```bash
  git status
  ```

- **Add Changes**:
  ```bash
  git add <file>        # Add a specific file
  git add .             # Add all changes
  ```

- **Commit Changes**:
  ```bash
  git commit -m "Commit message"
  ```

- **View Commit History**:
  ```bash
  git log
  ```

## Branching
- **Create a New Branch**:
  ```bash
  git branch <branch-name>
  ```

- **Switch to a Branch**:
  ```bash
  git checkout <branch-name>
  ```

- **Create and Switch to a New Branch**:
  ```bash
  git checkout -b <branch-name>
  ```

- **Delete a Branch**:
  ```bash
  git branch -d <branch-name>
  ```

## Merging and Rebasing
- **Merge a Branch**:
  ```bash
  git merge <branch-name>
  ```

- **Rebase a Branch**:
  ```bash
  git rebase <branch-name>
  ```

## Stashing Changes
- **Stash Changes**:
  ```bash
  git stash
  ```

- **Apply Stashed Changes**:
  ```bash
  git stash apply
  ```

- **List Stashes**:
  ```bash
  git stash list
  ```

## Working with Submodules
### Adding a Submodule
```bash
git submodule add <repository-url> <path>
```

### Updating Submodules
```bash
git submodule update --init --recursive
```

### Syncing Submodules Between Branches
1. **Check Out the Source Branch**:
   ```bash
   git checkout source-branch
   ```
2. **Update Submodules**:
   ```bash
   git submodule update --init --recursive
   ```
3. **Check Out the Target Branch**:
   ```bash
   git checkout target-branch
   ```
4. **Merge or Rebase**:
   ```bash
   git merge source-branch
   ```
   or
   ```bash
   git rebase source-branch
   ```
5. **Update Submodules Again**:
   ```bash
   git submodule update --init --recursive
   ```

### Fixing Submodule Modifications
If you find that submodules are marked as modified after switching branches, follow these steps:

1. **Check Submodule Status**:
   ```bash
   git submodule status
   ```

2. **Reset Submodules to the Commit in the Source Branch**:
   ```bash
   git submodule update --recursive --checkout
   ```

3. **Clean Up Untracked Files** (if necessary):
   ```bash
   git submodule foreach 'git clean -fd'
   ```

4. **Verify the Submodule State**:
   ```bash
   git submodule status
   ```

5. **Check for Changes** (if needed):
   ```bash
   git status
   ```

## Viewing Changes
- **View Changes to Files**:
  ```bash
  git diff
  ```

- **View Changes in Staged Files**:
  ```bash
  git diff --cached
  ```

## Undoing Changes
- **Revert a Commit**:
  ```bash
  git revert <commit-hash>
  ```

- **Reset to a Previous Commit**:
  ```bash
  git reset --hard <commit-hash>
  ```

## Remote Repositories
- **Add a Remote Repository**:
  ```bash
  git remote add <name> <repository-url>
  ```

- **Fetch Changes from Remote**:
  ```bash
  git fetch <remote-name>
  ```

- **Pull Changes from Remote**:
  ```bash
  git pull <remote-name> <branch-name>
  ```

- **Push Changes to Remote**:
  ```bash
  git push <remote-name> <branch-name>
  ```

## Miscellaneous Commands
- **Show Current Branch**:
  ```bash
  git branch --show-current
  ```

- **Check Current Configuration**:
  ```bash
  git config --list
  ```

- **Change Commit Message** (for the last commit):
  ```bash
  git commit --amend -m "New commit message"
  ```
