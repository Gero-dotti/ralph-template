#!/usr/bin/env bash

# Ralph Playbook - Autonomous Loop Script
# Usage: ./loop.sh [plan|build] [--max-iterations N] [--push]

set -e

MODE="${1:-build}"
MAX_ITERATIONS=0
PUSH_AFTER_COMMIT=false
ITERATION=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        plan|build)
            MODE="$1"
            shift
            ;;
        --max-iterations)
            MAX_ITERATIONS="$2"
            shift 2
            ;;
        --push)
            PUSH_AFTER_COMMIT=true
            shift
            ;;
        --help|-h)
            echo "Ralph Playbook - Autonomous AI Development Loop"
            echo ""
            echo "Usage: ./loop.sh [MODE] [OPTIONS]"
            echo ""
            echo "Modes:"
            echo "  plan    Run in planning mode (gap analysis, generate IMPLEMENTATION_PLAN.md)"
            echo "  build   Run in building mode (implement tasks from plan)"
            echo ""
            echo "Options:"
            echo "  --max-iterations N   Stop after N iterations (0 = unlimited)"
            echo "  --push               Git push after each successful commit"
            echo "  --help, -h           Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./loop.sh plan                    # Run planning indefinitely"
            echo "  ./loop.sh build --max-iterations 5  # Build 5 tasks then stop"
            echo "  ./loop.sh build --push            # Build and push each commit"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# Select prompt file based on mode
PROMPT_FILE="PROMPT_${MODE}.md"

if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "Error: $PROMPT_FILE not found"
    exit 1
fi

MODE_UPPER=$(echo "$MODE" | tr '[:lower:]' '[:upper:]')
echo "============================================"
echo " Ralph Playbook - ${MODE_UPPER} Mode"
echo "============================================"
echo ""
echo "Starting autonomous loop..."
echo "Press Ctrl+C to stop"
echo ""

# Main loop
while true; do
    ITERATION=$((ITERATION + 1))

    echo "----------------------------------------"
    echo " Iteration $ITERATION"
    echo "----------------------------------------"

    # Run Claude with the prompt
    # Using opus model for best reasoning
    # --dangerously-skip-permissions for uninterrupted autonomy
    # -p to read prompt from stdin
    cat "$PROMPT_FILE" | claude \
        --model opus \
        --dangerously-skip-permissions \
        -p

    EXIT_CODE=$?

    if [[ $EXIT_CODE -ne 0 ]]; then
        echo ""
        echo "Claude exited with code $EXIT_CODE"
        echo "Continuing to next iteration..."
        sleep 2
    fi

    # Check for completion signal                                                                                                       
    if [[ -f ".ralph-complete" ]]; then                                                                                                 
        echo ""                                                                                                                         
        echo "✓ All tasks complete!"                                                                                                    
        rm .ralph-complete                                                                                                              
        exit 0                                                                                                                          
    fi

    # Push if requested
    if [[ "$PUSH_AFTER_COMMIT" == "true" ]]; then
        echo "Pushing to remote..."
        git push 2>/dev/null || echo "Push failed or nothing to push"
    fi

    # Check iteration limit
    if [[ $MAX_ITERATIONS -gt 0 && $ITERATION -ge $MAX_ITERATIONS ]]; then
        echo ""
        echo "Reached maximum iterations ($MAX_ITERATIONS)"
        echo "Stopping loop."
        exit 0
    fi

    # Brief pause between iterations
    sleep 1
done