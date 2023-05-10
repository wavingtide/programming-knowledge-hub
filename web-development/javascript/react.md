# React
*(refer to [official documentation](https://reactjs.org/) and [beta documentation](https://beta.reactjs.org/))*

*(There might be a migration of documentation site and hence the links above can get outdated)*

React is a JavaScript library for building user interfaces. It can be added into local HTML file or browser with a script tag. New React project can be created with a toolchain or a framework which required node.js installation.


# Table of Contents
- [React](#react)
- [Table of Contents](#table-of-contents)
- [Main Concepts](#main-concepts)
  - [Components](#components)
  - [Markup and Style](#markup-and-style)
  - [State and Event Handler](#state-and-event-handler)
  - [Props](#props)
- [Normal Workflow](#normal-workflow)
- [Setting up a React Environment](#setting-up-a-react-environment)
- [Production-grade React Framework](#production-grade-react-framework)
  - [Next.js](#nextjs)


# Main Concepts
## Components
A component is a piece of the UI (user interface) that has its own logic and appearance (e.g. button, page).

React component is a JavaScript function that return markup.
``` javascript
function MyButton() {
  return (
    <button>I'm a button</button>
  );
}
```
It can then be used in another components. Notice that the first letter of React component should be capital.
``` javascript
export default function MyApp() {
  return (
    <div>
      <h1>Welcome to my app</h1>
      <MyButton />
    </div>
  );
}
```

## Markup and Style
JSX is a convenient and optional markup syntax. It is a syntax extension of JavaScript. A component can only return one JSX tags. You have to wrap there into a shared parent, like a `<div>...</div>` or an empty `<>...</>` wrapper.
``` javascript
function AboutPage() {
  return (
    <>
      <h1>About</h1>
      <p>Hello there.<br />How do you do?</p>
    </>
  )
}

```

To add style, specify a CSS class with classname.
``` javascript
<img className="avatar" />
```

Then write CSS rules in a separate CSS file.
``` javascript
/* In your CSS */
.avatar {
  border-radius: 50%;
}
```

Use curly bracket, `{}` to use Javascript code in JSX.

## State and Event Handler
State is used to remember some information and can be initialized using `useState`. Event handler handled an event (e.g. `onClick`).

``` javascript
import { useState } from 'react';

function MyButton() {
  const [count, setCount] = useState(0);

  function handleClick() {
    setCount(count + 1);
  }

  return (
    <button onClick={handleClick}>
      Clicked {count} times
    </button>
  );
}
```

To share state among components, put it in the parent level.

## Props
Props are a way of passing data from parent to child.

# Normal Workflow
1. Start wth a mockup.
2. Break the UI into component in hierarchy.
3. Build a static version in React.
4. Find the minimal but complete representation of UI state.
5. Identify where your state should live (can be closest common parent component).
6. Add inverse data flow.


# Setting up a React Environment
To set up a react app, you can use `create-react-app`.
``` shell
npx create-react-app frontend
```
![](https://i.imgur.com/v4tWiYo.png)

`create-react-app` will install dependencies, initialize a git repository

The project directory is as follows
``` shell
.
├── README.md
├── node_modules
├── package-lock.json
├── package.json
├── public
│   ├── favicon.ico
│   ├── index.html
│   ├── logo192.png
│   ├── logo512.png
│   ├── manifest.json
│   └── robots.txt
└── src
    ├── App.css
    ├── App.js
    ├── App.test.js
    ├── index.css
    ├── index.js
    ├── logo.svg
    ├── reportWebVitals.js
    └── setupTests.js
```

To run the development server, `cd` into the project directory and run `npm start`
``` shell
cd frontend
npm start
```
![](https://i.imgur.com/DHtCWJD.png)


Bundles the app into static files for production.
``` shell
npm run build
```

Starts the test runner
``` shell
npm test
```

Removes this tool and copies build dependencies, configuration files and scripts into the app direcoty. If you do this, you can't go back.
``` shell
npm run eject
```


# Production-grade React Framework
## Next.js
``` shell
npx create-next-app
```

![](https://i.imgur.com/vMAIQb9.png)

The project directory is as follows
``` shell
.
├── README.md
├── next-env.d.ts
├── next.config.js
├── node_modules
├── package-lock.json
├── package.json
├── pages
│   ├── _app.tsx
│   ├── _document.tsx
│   ├── api
│   └── index.tsx
├── postcss.config.js
├── public
│   ├── favicon.ico
│   ├── next.svg
│   └── vercel.svg
├── styles
│   └── globals.css
├── tailwind.config.js
└── tsconfig.json
```
