# Ralph

Ralph is a methodology and toolkit for using Claude AI as an autonomous development agent. It enables AI-driven development loops where Claude works on your codebase incrementally and semi-autonomously, with all state persisted to disk between iterations.

Based on [The Ralph Playbook](https://github.com/ghuntley/how-to-ralph-wiggum) by Geoffrey Huntley.

## Prerequisites

- **Claude CLI** - The `claude` command-line tool with API access
- **Git** - Version control (required for tracking changes)
- **Bash 4+** - Shell environment

## Setup

### Option 1: Copy to an existing project

Run the setup script to copy Ralph files to your project:

```bash
./setup.sh /path/to/your-project
```

This copies:
- `loop.sh` - Main orchestration script
- `PROMPT_plan.md` - Planning mode instructions
- `PROMPT_build.md` - Building mode instructions
- `AGENTS.md` - Project configuration (customize this)
- `IMPLEMENTATION_PLAN.md` - Task tracking state
- `specs/` - Specification templates

### Option 2: Clone and configure

```bash
git clone <this-repo> my-project
cd my-project
```

## Configuration

### 1. Configure AGENTS.md

Edit `AGENTS.md` to define your project's:

- **Tech stack** - Languages, frameworks, libraries
- **Build command** - e.g., `npm run build`, `make build`
- **Test command** - e.g., `npm run test`, `pytest`
- **Lint command** - e.g., `npm run lint`, `eslint .`
- **Code style** - Conventions and patterns to follow
- **Architecture** - Project structure and key components

### 2. Write specifications

Create feature specs in the `specs/` directory using the provided template:

```bash
cp specs/_template.md specs/my-feature.md
```

Each spec should include:
- Overview and jobs-to-be-done
- Requirements (functional and non-functional)
- Acceptance criteria
- Dependencies and technical notes

## Usage

### Planning Mode

Analyze the codebase and create an implementation plan:

```bash
./loop.sh plan
```

Ralph will:
1. Read all specs and existing code
2. Perform gap analysis
3. Generate/update `IMPLEMENTATION_PLAN.md` with prioritized tasks

### Building Mode

Implement tasks from the plan one at a time:

```bash
./loop.sh build
```

Each iteration, Ralph will:
1. Select the next task from the plan
2. Implement it
3. Run validation (build/lint/test)
4. Commit changes
5. Update the plan

### Options

```bash
./loop.sh plan                      # Run planning indefinitely
./loop.sh build                     # Run building indefinitely
./loop.sh build --max-iterations 5  # Stop after 5 iterations
./loop.sh build --push              # Git push after each commit
./loop.sh --help                    # Show help
```

Press `Ctrl+C` to stop the loop at any time.

## File Structure

```
├── loop.sh                 # Main orchestration script
├── PROMPT_plan.md          # Instructions for planning mode
├── PROMPT_build.md         # Instructions for building mode
├── AGENTS.md               # Project-specific configuration
├── IMPLEMENTATION_PLAN.md  # Persistent task tracking state
├── RALPH_PLAYBOOK_GUIDE.md # Detailed documentation
└── specs/                  # Feature specifications
    ├── README.md           # How to write specs
    └── _template.md        # Spec template
```

## Key Principles

- **One task per iteration** - Each loop completes exactly one task for manageable context
- **Disk-based state** - All context persists in files since Claude restarts fresh each iteration
- **Tests as guardrails** - Features must pass tests before proceeding
- **Human oversight** - Review changes via git, stop the loop anytime

## Quick Start Example

```bash
# 1. Setup
./setup.sh ~/projects/my-app
cd ~/projects/my-app

# 2. Configure
vim AGENTS.md  # Add your build/test/lint commands

# 3. Write a spec
vim specs/auth-feature.md

# 4. Plan
./loop.sh plan  # Creates implementation plan

# 5. Build
./loop.sh build --max-iterations 10  # Implements tasks
```

## Troubleshooting

- **Loop exits immediately** - Check that `claude` CLI is installed and authenticated
- **Tests failing** - Ralph will attempt to fix; if stuck, review `IMPLEMENTATION_PLAN.md`
- **Want to pause** - Press `Ctrl+C`; progress is saved in git and the plan file

For detailed documentation, see `RALPH_PLAYBOOK_GUIDE.md`.
