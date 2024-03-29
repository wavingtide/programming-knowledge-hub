# Github Actions
*(based on [github documentation](https://docs.github.com/en/actions))*

GitHub Actions is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline.

Github provides virtual machines of different operating systems to run the workflows.

# Terminology
- **Workflow**: A configurable automated process that will run one or more jobs. It is defined in `.github/workflows/` directory in a repository and by a YAML file.
- **Event**: A specific activity in a repository that triggers a workflow. (Example: create pull request, new issue, push commit). Workflow can also be triggered on a schedule or manually.
- **Jobs**: A set of steps in a workflow that execute on the same runner. Steps are executed in order. By default, job run in parallel with each other. You can configure a job's dependencies with other jobs.
- **Actions**: Custom application for the Github Actions platform that perform a complex but frequently repeated task. Actions can be created or found from Github marketplace. (Example: set up authentication to your cloud provider, set up correct toolchain from your build environment)
- **Runners**: Servers that runs your workflow when they are triggered. You can also host your own servers.

# Example Workflows
1. Create `.github/workflows/` directory in your repository to store the workflow files.
2. Create a new file called `learn-github-actions.yml` in the directory.
``` yaml
name: learn-github-actions
run-name: ${{ github.actor }} is learning GitHub Actions
on: [push]
jobs:
  check-bats-version:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '14'
      - run: npm install -g bats
      - run: bats -v
```
3. Commit the change and push them to your Github repository.


# Component of yaml file
- `name` - (Optional) The name of the workflow
- `run-name` - (Optional) The name of the workflow runs
``` yaml
run-name: ${{github.actore}} is trying Github Actions
```
- `on` - Specific the trigger/event which cause the workflow to run.
``` yaml
on: [push, fetch]
```
- `env` - Set variable available to the steps of all jobs in the workflow.
``` yaml
env:
  SERVER: prod
```
- `jobs` - A workflow run is made up of one or more `jobs`.
``` yaml
jobs:
  my_first_job:
    name: My first job
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '14'
      - run: npm install -g bats
  my_second_job:
    name: My second job

```

# Examples

``` yaml
name: Python package

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.7", "3.8", "3.9", "3.10"]

    steps:
      - uses: actions/checkout@v3
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install flake8 pytest
          if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
      - name: Lint with flake8
        run: |
          # stop the build if there are Python syntax errors or undefined names
          flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
          # exit-zero treats all errors as warnings. The GitHub editor is 127 chars wide
          flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
      - name: Test with pytest
        run: |
          pytest
```

``` yaml
steps:
- uses: actions/checkout@v3
- name: Set up Python
  uses: actions/setup-python@v4
  with:
    python-version: '3.x'
- name: Install dependencies
  run: |
    python -m pip install --upgrade pip
    pip install -r requirements.txt
- name: Test with pytest
  run: |
    pip install pytest
    pip install pytest-cov
    pytest tests.py --doctest-modules --junitxml=junit/test-results.xml --cov=com --cov-report=xml --cov-report=html
```

# Deployment

## Environment
One can configure environments with protection rules and secrets.

![](https://i.imgur.com/UzqfuoF.png)

To use an environment in Github Actions, add `environment` to the `jobs`
``` yaml
name: Deployment

on:
  push:
    branches:
      - main

jobs:
  deployment:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: deploy
        # ...deployment-specific steps
```

## Security hardening with OpenID Connect
OpenID Connect allows your workflows to exchange short-lived tokens directly from your cloud provider.
