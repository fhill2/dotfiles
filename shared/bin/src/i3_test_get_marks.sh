#!/usr/bin/env sh

# get all marks into
# set -e
# set -u

string_contains() {
    haystack="${1}"
    needle="${2}"

    case $haystack in
        *$needle*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}
MARKS=$(sway_print_tree value marks)
string_contains "$MARKS" "asd1234" && echo "contains" || echo "does not contain"

