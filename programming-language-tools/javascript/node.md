# Node.js
*(refer to [official documentation](https://nodejs.org/en/))*

Node.js is an open-source and cross-platform JavaScript runtime environment. Node.js runs on top of the Google Chrome V8 JavaScript engine.

# Table of Contents
- [Node.js](#nodejs)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Running a Server](#running-a-server)
- [npm Package Manager](#npm-package-manager)
- [Difference between Development and Production](#difference-between-development-and-production)
- [Using TypeScript](#using-typescript)
- [Express](#express)


# Installation
You can install node.js by downloading the installer from [node.js website](https://nodejs.org/en/download/).

For linux, you can do
``` shell
# install cURL
sudo apt install curl

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# install node (lts version)
nvm install --lts
```

Run a javascript file.
``` shell
node app.js
```

# Running a Server
Create a file called `server.js` and run `node server.js` in the terminal.
``` javascript
const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World\n');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
```

# npm Package Manager
`npm` is the standard package manager for Node.js

If a project has a `package.json`, running the following will create a `node_modules` folder and install everything the project needs.
``` shell
npm install
```

To install a single package, run
``` shell
npm install <package-name>
```

Specify version when installing
``` shell
npm install <package-name>@<version>
```

Update dependencies
``` shell
npm update
```

Update a single package
``` shell
npm update <package-name>
```

`npm` can be use to run task
``` shell
npm run <task-name>
```
Example
``` json
{
  "scripts": {
    "watch": "webpack --watch --progress --colors --config webpack.conf.js",
    "dev": "webpack --progress --colors --config webpack.conf.js",
    "prod": "NODE_ENV=production webpack -p --config webpack.conf.js"
  }
}
```
Run
``` shell
npm run watch
```

# Difference between Development and Production
By default, node.js assumes it's always running in a development environment. You can signal Node.js that you are running in production by setting the `NODE_END=production` environment variables.
``` shell
export NODE_ENV=production
```
``` shell
NODE_ENV=production node app.js
```
Setting the environment to `production` generally ensures that
- logging is kept to minimum, essential level
- more caching levels take place to optimize performance


# Using TypeScript
Install TypeScript
``` shell
npm i -D typescript
```

Compile TypeScript to JavaScript
``` shell
npx tsc example.ts
```

# Express
Install the Express Generator globally on your machine.
``` shell
npm install -g express-generator
```
