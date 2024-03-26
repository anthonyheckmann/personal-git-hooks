#!/bin/bash
# pre-commit hook to increment the version number in a Python file

# make sure the script fails on any error
set -e
set -o pipefail

# Check Bash version
if [[ ${BASH_VERSINFO[0]} -lt 4 || ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -lt 3 ]]; then
    echo "WARN: This script wants Bash version 4.3 or later."
    # exit 1
fi

# Check if any of the python files have the `__version__ = x.y.z` pattern string
if [[ $(git diff --cached --name-only -- '*.py' | xargs grep -l '__version__ =') ]]; then
    echo "Python files have the __version__ pattern"
else
    echo "No Python files have the __version__ pattern"
    exit 0
fi

# Get the files that has the `__version__ = x.y.z` pattern string
files=$(git diff --cached --name-only -- '*.py' | xargs grep -l '__version__ =')

for file in $files; do
    # Get the current version from the file
    version=$(grep -oP '(?<=__version__ = ")[^"]*' "$file")
    echo "Current version in $file is $version"
    # Split the version into an array
    IFS='.' read -ra version_parts <<<"$version"

    # Increment the last part of the version
    if [[ ${BASH_VERSINFO[0]} -lt 4 || ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -lt 3 ]]; then
        # Use syntax compatible with Bash versions prior to 4.3
        version_parts[${#version_parts[@]} - 1]=$((version_parts[${#version_parts[@]} - 1] + 1))

    else
        # Use syntax compatible with Bash 4.3 and later
        ((version_parts[-1]++))
    fi

    # Join the version parts back together
    new_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"

    echo "Version in $file WILL go from $version to ${new_version}"


    # Replace the old version with the new version in the file if we confirm the version increment
    echo "Are you sure you want to commit? (y/n)"

    # Read the user input and specify the tty explicitly
    read -ar answer </dev/tty

    if [ "$answer" == "${answer#[Yy]}" ]; then
        sed -i '' -e "s/__version__ = \"$version\"/__version__ = \"$new_version\"/g" "$file"
        echo -n "Incremented version in $file from $version to $new_version"
        #Add the file to the commit

        if git add "$file"; then
            echo " and added it to the commit"
        else
            echo " but failed to add it to the commit"
            exit 1
        fi

    else
        echo "Skipped incrementing version in $file"
    fi
done
exit 0
