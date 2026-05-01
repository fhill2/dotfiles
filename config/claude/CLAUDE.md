# Global Instructions

## Tooling & Performance

- **DO NOT** use `find` with `-exec`. It is slow and triggers security prompts.
- **ALWAYS** use `fd` for finding files. It is faster and more reliable.
- **ALWAYS** use `rg` (ripgrep) for searching file contents.
- Preferred search pattern: `fd <pattern> | xargs rg <content>`

## Permission Handling

- I prefer tools that don't trigger "High-Risk" permission prompts.
- If a command requires multiple pipes or complex shell logic, consider writing a temporary script instead of a one-liner.
