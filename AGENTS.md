# Agent Instructions

## Neovim Config Mirror

When making any change to Neovim configuration in this repo, mirror that change into the Datadog workspaces dotfiles repo before finishing the task.

- Treat files under `nvim/` in this repo as Neovim configuration.
- Copy changed Neovim files to `~/dd/workspaces-dotfiles/users/ram.goli/nvim/`, preserving the path relative to this repo's `nvim/` directory.
- Mirror renames and deletions as well as edits.
- Do not overwrite unrelated local changes in either repo. Check `git status --short` in both repos before editing or copying.
- After copying the Neovim changes, create a branch in `~/dd/workspaces-dotfiles`, commit the mirrored changes, push the branch, and open a pull request against that repo's default branch. The default branch is currently `main`; verify it with `git symbolic-ref refs/remotes/origin/HEAD` if needed.
- Include enough context in the pull request title or body to connect the mirrored change back to the source dotfiles change.
