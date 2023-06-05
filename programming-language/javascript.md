# JavaScript

# Useful Website
- [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
- [javascript.info](https://javascript.info/)

# Sandbox / Playground
- [CodePen](https://codepen.io/pen)
- [CodeSandBox](https://codesandbox.io/)
- [SlackBlitz](https://stackblitz.com/)

# Quick Overview
- [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Language_Overview)

# Library/Runtime/Framework of Javascript
- [React](react.md)
- [Node](node.md)
- Express
- Next

# Concept
## Callbacks
*Callbacks* are functions that allow you to schedule asynchronous actions, which means the actions that we initiate now but they finish later.

Example of an asynchonous function
``` javascript
function loadScript(src) {
    // create a <script> tag and append it to the page
    // this causes the script with given src to start loading and run when complete
    let script = document.createElement('script');
    script.src = src;
    document.head.append(script)
}
```
If we use the asynchonous function and a javascript code that depends on the asynchonous function, it will fail
``` javascript
loadScript('/my/script.js');  // has the function newFunction()

newFunction(); // no such function
```
Add a `callback` function as a second arugment to `loadScript`, the `callback` function will be executed when the script load
``` javascript
function loadScript(src, callback) {
    let script = document.createElement('script');
    script.src = src;
    script.onload = () => callback(script);
    document.head.append(script);
}
```
And we can write the new function in the callback
``` javascript
loadScript('/my/script.js', function () { newFunction()} );
```


## Promises, async/await
A *promise* is a special Javascript object that links the "producing code" and the "consuming code" together.
