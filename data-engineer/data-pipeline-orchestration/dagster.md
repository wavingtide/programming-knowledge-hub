# Dagster

Dagster is an orchestrator that's designed for developing and maintaining data assets.

# Table of Contents
- [Dagster](#dagster)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Concepts](#concepts)
- [Command](#command)


# Installation
``` shell
pip install dagster dagit
```

# Concepts
An **asset** is an object in persistent storage, such as table, file, or persisted machine learning model.

A **software-defined asset** is a Dagster object that couples an asset to the function and upstream assets used to produce its content.

**Ops** are the core unit of computation in Dagster, which typically perform simple tasks (e.g. executing a database query, sending a Slack message)

A **graph** is a set of interconnected ops or sub-graphs, which accomplish complex tasks

A **job** are the main unit of execution and monitoring in Dagster.

**Schedules** launch runs on a fixed interval, while sensors allow you to do so based on an external state change

**Dagit** is a web-based interface for viewing and interacting with Dagster objects.


# Command
Create a new project
``` shell
dagster project scaffold --name my-dagster-project
```

Start the Dagster UI
``` shell
dagster dev -f hello-dagster.py
```
