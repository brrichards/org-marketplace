#!/usr/bin/env bash
# Example SessionStart hook handler
# This script runs when a new Claude Code session starts.
#
# Use cases:
#   - Set up environment variables
#   - Validate prerequisites
#   - Log session activity
#   - Display org-specific welcome messages

echo "example-plugin: session started at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
