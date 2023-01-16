# Pre-commit
*(based on [link](https://pre-commit.com/))*

Pre-commit is one of the Git hooks. Git hooks are scripts to run when a particular event happens. Pre-commit literally runs before a commit takes place.

It is usually used to make sure that the code is linted and formatted properly.

# Installation
Using pip
``` shell
pip install pre-commit
```

Using brew
``` shell
brew install pre-commit
```

Using conda
``` shell
conda install -c conda-forge pre-commit
```

# Quick start
1. Install pre-commit
2. Create a file named `.pre-commit-config.yaml`
   ``` shell
   repos:
   -   repo: https://github.com/pre-commit/pre-commit-hooks
       rev: v2.3.0
       hooks:
       -   id: check-yaml
       -   id: end-of-file-fixer
       -   id: trailing-whitespace
   -   repo: https://github.com/psf/black
       rev: 22.10.0
       hooks:
       -   id: black
   ```
3. Run `pre-commit install`, now pre-commit run automatically on `git commit`.
   ![](https://i.imgur.com/Z2iIBV2.png)

   ![](https://i.imgur.com/JqlRlxG.png)
4. You can also run against all files directly.
   ``` shell
   pre-commit run --all-files
   ```
   ![](https://i.imgur.com/AaiGDj8.png)


# `.pre-commit-config.yaml`
Example:
``` shell
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.3.0
    hooks:
    -   id: check-yaml
    -   id: end-of-file-fixer
    -   id: trailing-whitespace
-   repo: https://github.com/psf/black
    rev: 22.10.0
    hooks:
    -   id: black
```

