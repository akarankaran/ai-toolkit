# gitignore block — workspace-hygiene

Merge the lines in the fenced block below into the target repo's `.gitignore` (append as a
trailing section; skip any line already present; never remove existing entries). Do **not**
copy this prose — only the lines inside the fence.

```gitignore
# --- workspace-hygiene ---
# Sanctioned scratch dir: agent/human working files, never committed.
.scratch/

# OS / editor cruft
.DS_Store
Thumbs.db
*~
*.swp
*.swo

# Stray temp / backup / log files
*.tmp
*.temp
*.bak
*.orig
*.log
```
