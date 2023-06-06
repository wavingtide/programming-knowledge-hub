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
*(refer to [javascript.info](https://javascript.info/))*
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

Callback might fail and the error can be handled in the asynchronous function, the following is called *error-first callback* style. The convention is that
1. The first argument of the `callback` is reserved for an error if it occurs. Then `callback(err)` is called
2. The second or subsequent arguments are for the successful result. Then `callback(null, res1, res2)` is called
``` javascript
function loadScript(src, callback) {
    let script = document.createElement('script');
    script.src = src;
    script.onload = () => callback(null, script);
    script.onerror = () => callback(new Error(`Script load error for ${src}`));
    document.head.append(script);
}
```
To use the asychronous function
``` javascript
loadScript('/my/script.js', function(error, script) {
    if (error) {
        // handle error
    } else {
        // script loaded successfully
    }
});
```

If there are multiple asynchronous actions that follow one after another, the code will becomes more nested and deeper, which is hard to maintain. This is called *callback hell* or *pyramid of doom*.

## Promises, async/await
A *promise* is a special Javascript object that links the "producing code" and the "consuming code" together.

The constructor syntax for a promise object is
``` javascript
let promise = new Promise(function(resolve, reject) {
    // executor / the producing code
})
```
A few key components
- executor - the function passed to `new Promise`
- `resolve(value)` - callback that return result `value` when the job is finished successfully
- `reject(error)` - callback that raise `error` when an error has occured

The `promise` object returned by the `new Promise` constructor has these internal properties
- `state`
  - Initially `pending`
  - Change to `"fulfilled"` when `resolve` is called
  - Change to `"rejected"` when `reject` is called
- `result`
  - Initially `undefined`
  - Change to `value` when `resolve(value)` is called
  - Change to `error` when `reject(error)` is called
