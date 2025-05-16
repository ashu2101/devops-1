
# 📘 Git: How It Works – Concepts, Terminology, and Commands

## 🔧 What is Git?

**Git** is a **distributed version control system** used to track changes in source code during software development. It allows multiple developers to work on a project simultaneously, maintain revision history, and collaborate efficiently.

---

## 🧠 Core Concepts and Terminology

### 1. **Repository (repo)**
A repository is the project’s data structure, containing all files, folders, and change history.

- **Local repository**: On your computer.
- **Remote repository**: Hosted on platforms like GitHub, GitLab, or Bitbucket.

```bash
git init       # Initialize a new Git repository
git clone <url>  # Clone a remote repository to local
```

---

### 2. **Commit**
A **commit** is a snapshot of your project at a given point in time. Each commit has a unique SHA hash and can include a message.

```bash
git add <file>         # Stage file(s) for commit
git add .              # Stage all changes
git commit -m "Message"  # Commit with message
```

---

### 3. **Branch**
A **branch** is a separate line of development. The default branch is usually `main` or `master`.

```bash
git branch             # List branches
git branch <name>      # Create new branch
git checkout <name>    # Switch to a branch
git checkout -b <name> # Create and switch to a new branch
```

---

### 4. **Merge**
Merging integrates changes from one branch into another (usually into `main`).

```bash
git checkout main
git merge <feature-branch>
```

---

### 5. **Fetch**
Fetch downloads new data (commits, branches) from a remote repo but doesn’t update your local working branch.

```bash
git fetch
```

---

### 6. **Pull**
Pull is a combination of `fetch` and `merge`. It updates your current branch with the latest changes from the remote.

```bash
git pull
```

---

### 7. **Push**
Push sends your committed changes to the remote repository.

```bash
git push
```

---

### 8. **Staging Area / Index**
This is where you prepare changes before committing. You stage files using `git add`.

---

### 9. **Working Directory**
The directory where you make changes to your project files.

---

### 10. **HEAD**
`HEAD` points to the current commit or branch you’re working on.

```bash
git log --oneline       # See latest commits (shows HEAD movements)
git show HEAD           # Show the last commit details
```

---

### 11. **Logs**
Git log shows the commit history of the repository.

```bash
git log
git log --oneline       # Compact view
```

---

### 12. **Diff**
Shows differences between working directory, staging area, or commits.

```bash
git diff                # Changes not yet staged
git diff --staged       # Changes staged for commit
git diff <commit1> <commit2> # Differences between two commits
```

---

### 13. **Reset / Revert**
- `reset` is used to move HEAD and optionally modify the working directory or index.
- `revert` creates a new commit that undoes changes.

```bash
git reset --hard <commit>     # Discard history and move to specific commit
git revert <commit>           # Revert a specific commit
```

---

### 14. **Rebase**
Reapply commits on top of another base commit. Used to streamline commit history.

```bash
git rebase <branch>
```

---

### 15. **Tag**
Tags are used to mark specific points in history, commonly for releases.

```bash
git tag                   # List tags
git tag <v1.0>            # Create a new tag
git push origin <tag>     # Push tag to remote
```

---

### 16. **.gitignore**
File used to tell Git which files/folders to ignore.

Example:
```
node_modules/
.env
*.log
```

---

### 17. **Git Config**
Used to set user preferences like name, email, and editor.

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --list
```

---

### 18. **Cherry Pick**
Apply a specific commit from one branch to another.

```bash
git cherry-pick <commit-hash>
```

---

## 🗃️ Useful Git Workflows

### Create a New Repo
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin <url>
git push -u origin main
```

### Clone and Start Working
```bash
git clone <repo-url>
cd project
git checkout -b feature-x
```

### Common Git Shortcuts
```bash
git status           # Show working tree status
git stash            # Save changes temporarily
git stash pop        # Reapply stashed changes
git remote -v        # View connected remotes
```

---

## ✅ Summary Table

| Concept      | Description                                | Command Example                        |
|--------------|--------------------------------------------|----------------------------------------|
| Repository   | Project + history                          | `git init`, `git clone`                |
| Commit       | Save point                                 | `git commit -m "msg"`                  |
| Branch       | Parallel line of work                      | `git branch`, `git checkout -b`        |
| Merge        | Combine branches                           | `git merge branchname`                 |
| Pull         | Fetch + merge                              | `git pull`                             |
| Push         | Upload commits                             | `git push`                             |
| Fetch        | Download changes                           | `git fetch`                            |
| Staging Area | Prep before commit                         | `git add`                              |
| Diff         | Show changes                               | `git diff`, `git diff --staged`        |
| Reset        | Undo changes                               | `git reset`, `git revert`              |
| Log          | View history                               | `git log`, `git log --oneline`         |
| Tag          | Mark versions                              | `git tag v1.0`                         |
| Rebase       | Reapply changes                            | `git rebase branch`                    |
| Cherry Pick  | Copy commit from another branch            | `git cherry-pick <hash>`               |
