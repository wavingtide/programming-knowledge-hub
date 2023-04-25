# Node.js
*(refer to [official documentation](https://nodejs.org/en/))*

Node.js is an open-source and cross-platform JavaScript runtime environment. Node.js runs on top of the Google Chrome V8 JavaScript engine.

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


# Express
Install the Express Generator globally on your machine.
``` shell
npm install -g express-generator
```
