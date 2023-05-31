# LangChain
*(refer to [langchain documentation](https://docs.langchain.com/docs/) and [python documentation](https://python.langchain.com/en/latest/index.html))*

LangChain is a framework for developing applications powered by language models.

Philosophy: Language model powered application should
- Be data-aware: Connect other data sources
- Be agentic: Interact with environment

Main value propositions
- Components
- Use-Case Specific Chains: Assembling of components


# Table of Contents
- [LangChain](#langchain)
- [Table of Contents](#table-of-contents)
- [Schema](#schema)
- [Components](#components)
  - [Models](#models)
  - [Prompts](#prompts)
  - [Indexes](#indexes)
  - [Memory](#memory)
  - [Chains](#chains)
  - [Agents](#agents)

# Schema
- **Text** - `text.in`, `text.out`
- **Chat Messages** - message with a content field associated with a user (system, human, ai)
- **Examples** - input / output pairs that represent inputs to a function (model or chain) and then expected output
  - Examples for a model can be used to finetune a model
  - Examples for a chain can be used to evaluate the end-to-end chain, or train a model to replace the whole chain
- **Documents** - unstructured data consists of `page_content` and `metadata`

# Components
## Models
| Model | Input | Output |
| -- | -- | -- |
| Large Language Models (LLMs) | Text string | Text string |
| Chat Models | A list of Chat Messages | A Chat Message |
| Text Embedding Models | Text | A list of floats |


## Prompts
A *prompt* refers to the input to the model, which is often constructed from multiple components. LangChain provides several classes and functions to make constructing and working with prompts easy.
| Component | Description |
| -- | -- |
| `PromptValue` | Input to a model, expose methods to convert to the exact input types that each model type expect (i.e. `text` or `ChatMessage`) |
| `PromptTemplate` | Object responsible for dynamically creating the `PromptValue` based on a combination of user input, other non-static information and a fixed template string |
| Example Selectors | Take in user input and then return a list of examples to use |
| Output Parsers | Classes that help structure language model responses. Instruct the model how output should be formatted (`get_format_instructions() -> str`), parse output into the desired formatting (`parse(str) -> Any`) |


## Indexes
Indexes refer to ways to structure documents so that LLMs can best interact with them.

## Memory


## Chains


## Agents
