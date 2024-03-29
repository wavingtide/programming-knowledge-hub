# Next.js
*(refer to [official documentation](https://nextjs.org/))*

Next.js is a React framework which provide additional structure, feature and optimization.


# Create a Next App
``` shell
npx create-next-app
```

![](https://i.imgur.com/vMAIQb9.png)

Depending on the option you choose, the project directory might be slightly different, an example is as follows
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

# Routing
There are 2 types of router supported in Next.js, **Pages Router** and **App Router**. App Router is the new paradigm for building application using React's latest features, and hence is recommended.

## Page Routing
In Next.js, a page is a React component from a file in the `pages` directory. (e.g. `pages/about.js` -> `/about`)

File with name  `index` is automatically routed to the root of the directory. (e.g. `pages/blog/index.js` -> `/blog`)

### Nested Routes
The router supports nested folder structures. (e.g. `pages/blog/first-post.js` -> `/blog/first-post`)

## Dynamic Route
A dynamic segment can be created by wrapping a folder's name in square brackets: `[foldername]`

Example: `pages/blog/[slug].js`
``` javascript
import { useRouter } from 'next/router'
 
export default function Page() {
  const router = useRouter()
  return <p>Post: {router.query.slug}</p>
}
```

### Catch-all Segments
Dynamic segments can be extended to catch-all subsequent segments by adding an ellipsis inside the brackets `[...fileName]`.

Example: `pages/shop/[...slug].js` will catch `/shop/clothes`, `/shop/clothes/top`, `/shop/clothes/top/shirts`


### Optional Catch-all Segments
Catch-all segments can be made optional by including the parameter in double square bracket, `[[...fileName]]`.

Example: `pages/shop/[[...slug]].js` will catch the same items as catch-all segments, and also catch `/shop`.




`getStaticProps`
`getStaticPaths`

`getServerSideProps`

