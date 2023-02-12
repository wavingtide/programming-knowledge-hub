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
It can then be used in another components. Notice that the first letter is capital.
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
