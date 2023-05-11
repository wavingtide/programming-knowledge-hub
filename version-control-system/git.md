# Git

*(based on [Pro Git Book](https://git-scm.com/book/en/v2))*

# Table of Contents
- [Git](#git)
- [Table of Contents](#table-of-contents)
- [Initiate a project](#initiate-a-project)
- [Clone](#clone)
- [Status](#status)
- [3 Stages of Git](#3-stages-of-git)
- [Add a new or modified file to staging area](#add-a-new-or-modified-file-to-staging-area)
- [Commit](#commit)
  - [The seven rules of a great Git commit message](#the-seven-rules-of-a-great-git-commit-message)
- [Unstaged a staged file/ Unmodified a modified file](#unstaged-a-staged-file-unmodified-a-modified-file)
- [Add Remote Repository](#add-remote-repository)
- [Push/ pull/ fetch](#push-pull-fetch)
- [Branch](#branch)
- [Rebase](#rebase)
- [Reset when you commit wrongly](#reset-when-you-commit-wrongly)
- [Show history](#show-history)
- [Show diff](#show-diff)
- [`.gitignore` file](#gitignore-file)
- [Moving around](#moving-around)
- [Cherry pick](#cherry-pick)


# Initiate a project
In the project directory
``` shell
git init
```
This will create a `.git` in the respective folder.

# Clone
If you are working on others' projects.
``` shell
git clone <repo>
```
``` shell
git clone https://github.com/libgit2/libgit2
```

# Status
``` shell
git status
```
It will show the branch and the status of your file. If they are untracked, not staged, or 'staged and pending to be committed'.

``` shell
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   docker.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   README.md

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        pro-git.md

nothing added to commit but untracked files present (use "git add" to track)
```

# 3 Stages of Git
![](https://i.imgur.com/GcDnXqE.png)
*Images from [Packt](https://subscription.packtpub.com/book/application-development/9781782168454/1/ch01lvl1sec10/the-three-stages)*

# Add a new or modified file to staging area
``` shell
git add <file>
```
Usage:
``` shell
git add file.py
```
You can add more than one file.
``` shell
git add file1.py file2.py file3.py
```
You can use grep syntax, which is similar to regex. For example, to add everything that is not in `.gitignore`.
``` shell
git add .
```
Or add everything that are being tracked.
``` shell
git add -u
```

# Commit
``` shell
git commit -m <commit message>
```
> Note: 
> 1. Try to make each commit a logically separate changeset.
> 2. Commit early, commit often

One liner
``` shell
git commit -m "Initial commits"
```
Sometimes, it is better to write more descriptions for non-trivial change or complicated logic. Run
``` shell
git commit
```
It will open a text editor (usually default is vim) for you to type the message. After finish typing, run `:wq` to exit the editor (if it is vim).

If you prefer to do everything from a single command then you can provide the commit subject and the commit message body by using the `-m` argument two times:
``` shell
git commit -m "this is the subject" -m "this is the body"
```

## The seven rules of a great Git commit message
*(refer to [How to Write a Git Commit Message](https://cbea.ms/git-commit/))*

1. Separate subject from body with a blank line
2. Limit the subject line to 50 characters
3. Capitalize the subject line
4. Do not end the subject line with a period
5. Use the imperative mood in the subject line
6. Wrap the body at 72 characters
7. Use the body to explain what and why vs. how

# Unstaged a staged file/ Unmodified a modified file
To unstaged a staged file, use one of the following
``` shell
git reset README.md
```
``` shell
git restore --staged README.md
```

To unmodified a modified file (to the previous commit version), use one of the following
``` shell
git checkout -- README.md
```
``` shell
git restore README.md
```

# Add Remote Repository
``` shell
git remote add <shortname> <url>
```
``` shell
git remote add origin https://github.com/libgit2/libgit2
```

If you clone a project, by default, the remote is set as `origin` pointing to the remote repository.

# Push/ pull/ fetch
Push to remote for the first time. Set the upstream branch with `-u` to link it to Github from your local.
``` shell
git push -u origin main
```

Push to remote afterward.
``` shell
git push
```

If someone made changes to the repo, and it didn’t conflict with what you do
``` shell
git pull
```

Most of the time, git pull = git fetch + git merge

If you want to have more control, `git fetch` will pull the remote commits into `<remote>/<branch>` locally (which is `origin/main` branch here) without merging it to the `<branch>` (which is `main` branch here), you can decide if you want to do more inspection or merge.
``` shell
git fetch
```

# Branch
Create new branch 
``` shell
git branch <branch>
```
``` shell
git branch new-branch
```

Change to a new branch
``` shell
git checkout new-branch
```

One liner to combine both steps, create and change to a new branch
``` shell
git checkout -b new-branch
```

List all branches
``` shell
$ git branch
* master
  testing
```

Push a branch from local to remote
``` shell
git push -u origin new-branch
```

Rename a branch (usually people will name `main` branch instead of `master` branch)
``` shell
git branch -M main
```

Remove a local branch
``` shell
git branch --delete new-branch
```
``` shell
git branch -d new-branch
```

Remove a remote branch
``` shell
git push -d origin new-branch
```

Merge 
3 scenarios might happen when merging:
- Fast-forward merge without merge commit
- Three-way merge with merge commit
- Merge conflict with merge commit

**Fast-forward merge**: By default, performed when there is a linear path from the current branch tip to the target branch.
``` shell
$ git checkout main
$ git merge new-feature
[iss53 ad82d7a] Finish the new footer [issue 53]
1 file changed, 1 insertion(+)
```
![](https://i.imgur.com/j4UxxW6.png)
*Image from [atlassian](https://www.atlassian.com/git/tutorials/using-branches/git-merge)*

**Three-way merge**: Performed when there is not a linear path to the target branch and there is no conflict. Git uses the two branch tips and their common ancestor to generate the merge commit.

``` shell
$ git merge new-feature
Merge made by the 'recursive' strategy.
index.html |    1 +
1 file changed, 1 insertion(+)
```
![](https://i.imgur.com/SMI1J4t.png)
*Image from [atlassian](https://www.atlassian.com/git/tutorials/using-branches/git-merge)*

**Merge conflict**: Happened when the two branches you're trying to merge both changed the same part of the same file.

``` shell
$ git merge new-feature
CONFLICT (add/add): Merge conflict in index.html
Auto-merging index.html
Automatic merge failed; fix conflicts and then commit the result.
```

The file with merge conflict will have a session like this to show the conflicting parts.
``` shell
<<<<<<< HEAD:index.html
<div id="footer">contact : email.support@github.com</div>
=======
<div id="footer">
 please contact us at support@github.com
</div>
>>>>>>> iss53:index.html
```

Modify the file to the content you want and do git add and commit
``` shell
<div id="footer">
please contact us at email.support@github.com
</div>
```
`git add` to mark as resolved and `git commit` to complete the merge
``` shell
git add index.html
git commit
```

You can abort the `git merge` in the middle of `git merge` when conflict happen
``` shell
git merge --abort
```

Sometimes you want to avoid fast-forward merge, you want to generate a merge commit to show that a merge is performed.
``` shell
git merge --no-ff <branch>
```

# Rebase
Rebase branch1 to branch2
``` shell
git checkout Branch2
git rebase Branch1
```
Original:
``` shell
a -- b -- c                  <-- Master
     \     \
      \     d -- e           <-- Branch1
       \
        f -- g               <-- Branch2
```

Result:

``` shell
a -- b -- c                        <-- Master
           \
            d -- e                <-- Branch1
             \
              d -- e -- f' -- g'  <-- Branch2
```
Rebase might have conflict too, and can be solved as the same workflow as merge conflict.

Rebase local changes before pushing to clean up your work, but never rebase anything that you’ve pushed somewhere.

# Reset when you commit wrongly
Undo commit and keep everything intact
``` shell
git reset --soft HEAD^
```

Undo commit and staging and keep everything intact
``` shell
git reset HEAD^
```

Reset everything to previous commit
``` shell
git reset --hard HEAD^
```

# Show history
Show previous commits and their message
``` shell
$ git log
commit cc48a3446b784b8d886e98c92826999771ad578c (HEAD -> main, origin/main)
Author: wavetitan <wavetitango@gmail.com>
Date:   Mon Dec 19 23:30:14 2022 +0800

    Last Sync: 2022-12-19 23:30:14

commit 82b6dbe2c54fcd16439d6a3724c55330a2f0ac0d
Author: wavetitan <wavetitango@gmail.com>
Date:   Sun Dec 18 23:38:07 2022 +0800

    Initial commit
```

Use `--graph` for better branch visualization
``` shell
$ git log --pretty=format:"%h %s" --graph
* 2d3acf9 Ignore errors from SIGCHLD on trap
* 5e3ee11 Merge branch 'master' of git://github.com/dustin/grit
|\
| * 420eac9 Add method for getting the current branch
* | 30e367c Timeout code and tests
43
* | 5a09431 Add timeout protection to grit
* | e1193f8 Support for heads with slashes in them
|/
* d6016bc Require time for xmlschema
* 11d191e Merge branch 'defunkt' into local
```

# Show diff
Show the differences between 2 branches
``` shell
git diff branch1..branch2
```

# `.gitignore` file
Add the file that git will ignore, eg: cache file, generated file, dependencies, etcs

Refer to https://github.com/github/gitignore

# Moving around
Move upwards a commit with `^`.
``` shell
# move the HEAD upwards by 2 commits
git checkout main^^
```

Move upwards a commit with `~<num>`.
``` shell
# move the HEAD upwards by 2 commits
git checkout main~2
```

Reassign a branch.
``` shell
# Move the main branch to three parents before HEAD
git branch -f main HEAD~3
```

# Cherry pick
Pick `<commit>` from another branch to add to the HEAD branch.
``` shell
git cherry-pick <commit1> <commit2>
```

# Git Stash
`git stash` temporarily shelves (or stashes) changes you've made to your working copy so you can work on something else, and then come back and re-apply them later on.

Stash the work
``` shell
git stash
```

Reapply previous stashed changes.
``` shell
git stash pop
```
