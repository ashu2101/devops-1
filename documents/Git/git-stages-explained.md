
# 🔁 Git Workflow: Local Repo, Staging, Working Directory & Remote Repo

This document explains the **Git data model**: how changes flow through the different stages in a Git project—**Working Directory**, **Staging Area**, **Local Repository**, and **Remote Repository**—and what commands move changes between these areas.

---

## 🗂️ 1. Working Directory

### What is it?
The **Working Directory** is where you actively edit your files. It reflects the latest checked-out version of the code.

### Key Characteristics:
- Contains files pulled from the local repository (the last committed state).
- Any uncommitted changes live here.

### Relevant Commands:
```bash
git status       # View changes in the working directory
git diff         # Show file differences before staging
```

---

## 📥 2. Staging Area (Index)

### What is it?
The **Staging Area** is where you prepare a snapshot of your changes before committing. It acts as a buffer between the Working Directory and the Local Repository.

### Key Characteristics:
- Only staged files will be committed.
- Allows partial commits.

### Relevant Commands:
```bash
git add <file>   # Add a file to the staging area
git add .        # Add all modified files to staging
git reset <file> # Unstage a file
git diff --staged  # See staged changes
```

---

## 🗃️ 3. Local Repository

### What is it?
The **Local Repository** is the database on your machine that stores committed versions of your project. Commits represent snapshots in time.

### Key Characteristics:
- Stores the full version history.
- Isolated from other developers until pushed to a remote.

### Relevant Commands:
```bash
git commit -m "message"    # Save staged changes to the local repo
git log                    # View local commit history
git reset --soft <commit>  # Move HEAD to an earlier commit, keep changes staged
```

---

## 🌐 4. Remote Repository

### What is it?
The **Remote Repository** is hosted elsewhere (e.g., GitHub, GitLab). It's used to share work with others and back up code.

### Key Characteristics:
- Sync point between collaborators.
- Doesn’t reflect local changes until pushed.

### Relevant Commands:
```bash
git remote -v          # View connected remote repositories
git push origin main   # Push local commits to the remote
git fetch              # Download new commits from the remote
git pull               # Fetch + merge changes into local branch
```

---

## 🔄 Git Change Flow Summary

Here’s how changes flow between areas using Git commands:

```text
[ Working Directory ]
        |
        | git add
        v
[ Staging Area ]
        |
        | git commit
        v
[ Local Repository ]
        |
        | git push
        v
[ Remote Repository ]
```

And to go the other way:

```text
[ Remote Repository ]
        |
        | git fetch / git pull
        v
[ Local Repository ]
        |
        | git checkout
        v
[ Working Directory ]
```

---

## 🧠 Summary Table

| Area              | Description                             | Key Commands                            |
|-------------------|-----------------------------------------|------------------------------------------|
| Working Directory | Files being edited                      | `git status`, `git diff`                 |
| Staging Area      | Changes prepared for commit             | `git add`, `git reset`, `git diff --staged` |
| Local Repository  | Committed snapshot history              | `git commit`, `git log`, `git reset`     |
| Remote Repository | Shared version of the project           | `git push`, `git pull`, `git fetch`      |

---

This Git architecture allows developers to work independently, prepare changes incrementally, and collaborate effectively across distributed teams.
