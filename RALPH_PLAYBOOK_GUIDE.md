# Ralph Playbook Implementation Guide

A methodology for using Claude AI as an autonomous development agent.

## Overview

The Ralph Playbook structures AI-assisted development into phases with file-based coordination, enabling Claude to work autonomously in a loop while maintaining context through disk-based state.

## Quick Start

```bash
# 1. Copy template to your project
cd ~/Desktop/ralph-template
./setup.sh /path/to/your-project

# 2. Edit AGENTS.md with your project info
cd /path/to/your-project
vim AGENTS.md  # Add your build commands, tech stack, etc.

# 3. Write your first spec
cp specs/_template.md specs/my-feature.md
vim specs/my-feature.md

# 4. Run planning phase
./loop.sh plan

# 5. Run building phase
./loop.sh build
```

## How It Works

### The Loop

```
┌─────────────────────────────────────────────┐
│                  loop.sh                     │
│  ┌────────────────────────────────────────┐ │
│  │  1. Read PROMPT_*.md                   │ │
│  │  2. Run Claude with prompt             │ │
│  │  3. Claude reads/updates plan          │ │
│  │  4. Claude implements ONE task         │ │
│  │  5. Claude commits changes             │ │
│  │  6. Loop restarts with fresh context   │ │
│  └────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

### Files

| File | Purpose |
|------|---------|
| `loop.sh` | Bash script that runs Claude repeatedly |
| `PROMPT_plan.md` | Instructions for planning mode |
| `PROMPT_build.md` | Instructions for building mode |
| `AGENTS.md` | Project-specific operational guide |
| `IMPLEMENTATION_PLAN.md` | Persistent state between iterations |
| `specs/` | Requirement documents |

### Modes

**Planning Mode** (`./loop.sh plan`)
- Reads specs and existing code
- Performs gap analysis
- Generates prioritized task list
- Does NOT implement anything

**Building Mode** (`./loop.sh build`)
- Reads the implementation plan
- Picks highest priority task
- Implements with tests
- Validates (build, lint, test)
- Commits and updates plan

## Key Principles

### 1. Context is Everything
- Each iteration starts fresh (no memory)
- `IMPLEMENTATION_PLAN.md` is the shared memory
- Use subagents for expensive research

### 2. One Task Per Iteration
- Keeps context focused
- Allows for course correction
- Fresh start if something goes wrong

### 3. Backpressure Through Tests
- Tests provide quality guardrails
- Build/lint failures block progress
- Forces Ralph to fix issues before moving on

### 4. Let Ralph Ralph
- Trust the LLM to self-correct
- Don't over-prescribe solutions
- Provide constraints, not micromanagement

## Command Reference

```bash
# Planning mode (indefinite)
./loop.sh plan

# Building mode (indefinite)
./loop.sh build

# Build with max 5 iterations
./loop.sh build --max-iterations 5

# Build and push after each commit
./loop.sh build --push

# Show help
./loop.sh --help
```

## Tips

1. **Write good specs**: Clear requirements = better implementation
2. **Keep AGENTS.md updated**: Ralph reads this every iteration
3. **Watch the first few iterations**: Tune prompts if needed
4. **Run in a sandbox**: Uses `--dangerously-skip-permissions`
5. **Use version control**: Easy to revert if something goes wrong

## Directory Structure After Setup

```
your-project/
├── loop.sh                    # Run this to start
├── PROMPT_plan.md             # Planning instructions
├── PROMPT_build.md            # Building instructions
├── AGENTS.md                  # YOUR project info (edit this!)
├── IMPLEMENTATION_PLAN.md     # Auto-generated task list
├── specs/
│   ├── README.md
│   ├── _template.md
│   └── your-feature.md        # Your specs go here
└── src/                       # Your existing code
```

## Troubleshooting

**Ralph is stuck in a loop**
- Check `IMPLEMENTATION_PLAN.md` for blockers
- Add more context to `AGENTS.md`
- Simplify the current task in the spec

**Tests keep failing**
- Ensure test commands in `AGENTS.md` are correct
- Check if dependencies are installed
- Review the test output in terminal

**Ralph implements wrong thing**
- Improve spec clarity
- Add more constraints to `AGENTS.md`
- Be more specific about what NOT to do

---

Based on [The Ralph Playbook](https://github.com/ghuntley/how-to-ralph-wiggum) by Geoffrey Huntley.
