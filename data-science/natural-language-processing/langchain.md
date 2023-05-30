# LangChain

LangChain is a framework for developing applications powered by language models.

# Table of Contents
- [LangChain](#langchain)
- [Table of Contents](#table-of-contents)
- [Schema](#schema)
- [Components](#components)
  - [Models](#models)

# Schema
- **Text** - `text.in`, `text.out`
- **Chat Messages** - message with a content field associated with a user (system, human, ai)
- **Examples** - input / output pairs that represent inputs to a function (model or chain) and then expected output
  - Examples for a model can be used to finetune a model
  - Examples for a chain can be used to evaluate the end-to-end chain, or train a model to replace the whole chain
- **Documents** - unstructured data consists of `page_content` and `metadata`

# Components
## Models
- Large Language Models (LLMs)
- Chat Models
- Text Embedding Models
