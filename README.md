# personal-git-hooks
Git hooks I made

# Install
Probably best to install these globally

1. first, check your current settings
`git config --global --get core.hooksPath`

2. If it's empty, make a place for your personal hooks, usually `~/.git-hooks/` which will contain the standard hook names of:

    applypatch-msg
    pre-applypatch
    post-applypatch
    pre-commit
    prepare-commit-msg
    commit-msg
    post-commit
    pre-rebase
    post-checkout
    post-merge
    pre-push
    pre-receive
    update
    post-receive
    post-update
    push-to-checkout
    pre-auto-gc
    post-rewrite
    sendemail-validate

3. Then set `git config --global --add core.hooksPath ~/.git-hooks/`


4. When you next run `git commit 'm'` the script will fire


# Notes

The scripts rely on `exit` codes, and any code other than 0 will cause that operation to fail.

Beware that the scripts may not run in an interactive mode, so any user input may not occur as expected.
