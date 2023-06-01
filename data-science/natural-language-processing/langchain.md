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
Indexes refer to ways to structure documents so that LLMs can best interact with them. The primary index and retrieval types supported by LangChain are currently centered around vector databases, and therefore a lot of the functionality deep dive on these topics.

- Index can be used for retrieval and other purposes
- Retrieval can be done using index or other logic

| Component | Description |
| -- | -- |
| Document Loaders | Load a list of `Document` object from various sources |
| Text Splitters | Splitting up documents into smaller documents |
| Vector Stores | Stores document and associated embeddings, and provides fast way to look up relevant Documents by embeddings |
| Retrievers | Interface for fetching relevant documents. Provide `get_relevant_texts` method which takes in a string and returns a list of Documents |


## Memory
Memory is a concept of storing and retrieving data in the process of a conversation. There are 2 types of memory
- Short term - Pass data in the context of a singular conversation (i.e. previous `ChatMessages`, summaries of `ChatMessages`)
- Long term - Fetch and update information between conversations

`ChatMessageHistory` class is responsible for remembering all previous chat histories, which can be passed directly to models, or be summarized. It exposes 2 methods and 1 attribute
- `add_user_message` - store message from users
- `add_ai_message` - store message from AI
- `messages` attribute - used for accessing all previous messages


## Chains
Chain is an end-to-end wrapper of sequence of modular components (or other chains) combined in a particular way to accomplish a common use case.

Example:
- LLMChain, which combines a PromptTemplate, a model, an optional output parser (e.g. Guardrails). The chains take user input, format it accordingly, pass it to a model, get a response, and then validate and parse the model output
- Prompt Selector - set different default prompts for LLMs vs Chat Models, or for different model providers
- Index-related chain, handling passing multiple documents to the language model, e.g. question answering over our own document

| Index-Related Chain | Implementation | Description | Pro | Con |
| -- | -- | -- | -- | -- |
| Stuffing | `StuffDocumentsChain` | Stuff all the related data into the prompt as context to pass to the language model | Only make a single call to the LLM. When generating text, the LLM has access to all the data at once | Mosts LLM have a context length, therefore this methods cannot work with large documents |
| Map Reduce | `MapReduceDocumentsChain` | Run an initial prompt on each chunk of data (e.g. summarization, question answering). Then run a different prompt to combine all the initial outputs | Can scale to larger documents, the calls to the LLMs on individual documents can be parallelized | Requires many more calls, lost information in the final combined call |
| Refine |  | Run an initial prompt on the first chunk of data, generate some outputs. For the remaining documents, pass in the output along with the next document, asking the LLM to refine the output based on the new document | Can pull in more relevant context, and may be less lossy than `MapReduceDocumentsChain` | Require many more calls to the LLM, the call are not independent and cannot be parallelized |
| Map-Rerank |  | Run an initial prompt on each chunk of data, that not only tries to complete a task but also gives a score for how certain it is in its answer. The response is then ranked according to this score, and the highest score is returned | Similar pros as `MapReduceDocumentsChain`, require fewer calls compared to `MapReduceDocumentChain` | Cannot combine information between documents. More useful when you expect there is a single simple answer in a single document |


## Agents
An *agent* has access to a suite of tools, and can decide which, if any, of these tools to call depending on the user input.

- Tool - Abstraction around function that make it easy for a language model to interact with it
- Toolkit - Groups of tools that can be used/are necessary to solve a particular problem
- Agent - Wrapper around a model, which takes in user input and returns a response corresponding to an *action* to take and a corresponding *action input*
- Agent Executor - Responsible for calling the agent, getting back the action and action input, and carry out the subsequent actions
