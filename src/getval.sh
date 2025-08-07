#!/usr/bin/env bash
set -euo pipefail
HEADER=1
awk -F, -v key_col="${1}" -v key_val="${2}" -v out_col="${3}" -v header="${HEADER}" '
    NR == header {
        for (i=1; i<=NF; i++) {
            if ($i == key_col) key_idx = i
            if ($i == out_col) out_idx = i
        }
    }
    NR > header {
        if (key_idx && out_idx && $(key_idx) == key_val)
            print $(out_idx)
    }
    ' "${4}"
# -----------------------------------------------------------------------------
# getval.sh - Extract a value from a CSV file based on a key match
#
# Usage:
#   ./getval.sh FILE KEY_COLUMN KEY_VALUE OUTPUT_COLUMN
#
# Arguments:
#   KEY_COLUMN      Name of the key column (e.g. "name").
#   KEY_VALUE       The value to match in the key column (e.g. "Bob Smith").
#   OUTPUT_COLUMN   Name of the column whose value should be returned (e.g., "city").
#   FILE            Path to the CSV file.
#
# Example:
#   Given a CSV file "data.csv":
#
#     id,name,age,city
#     1,Bob Smith,30,New York
#     2,Alice Jones,25,Boston
#
#   Running:
#     ./getval.sh name "Bob Smith" city data.csv
#
#   Produces:
#     New York
#
# Notes:
# - The script assumes the header row is on line 1 of the file.
# - Fields must be comma-separated.
# - Matching is case-sensitive and exact.
# - Leading/trailing whitespace in fields may cause mismatches if not handled.
# -----------------------------------------------------------------------------
