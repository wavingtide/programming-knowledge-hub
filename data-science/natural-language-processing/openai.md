# OpenAI
*(refer to [official documentation]())*

The OpenAI API can be used for almost any NLP tasks. It is available as API, Python and node.js library.

# Concepts
- Prompt: Inputted text
- Tokens: Texts are broken down into tokens. (e.g. `'hamburger' -> ['ham', 'bur', 'ger']`)
- Models (Davinci, Curie, Babbage, Ada)


# Model
- GPT-3
  - text-davinci-003
  - text-curie-001
  - text-babbage-001
  - text-ada-001
- Codex
  - code-davinci-002
  - code-cushman-001
- content-filter-alpha

Different models have different limitations for maximum tokens, most are 2048 tokens (roughly 1500 words).


# Endpoint
OpenAI has the following endpoints
1. Text completion
2. Code completion
3. Image generation
4. Fine-tuning
5. Embeddings


# How to write a good prompt?
1. Start with an instruction.
2. Add some examples.
3. Adjust your settings.


# Python Library
Installation
``` shell
pip install openai
```

The completions endpoint is the center of the API.

``` python
import os
import openai

# Load your API key from an environment variable or secret management service
openai.api_key = os.getenv("OPENAI_API_KEY")

response = openai.Completion.create(
  model="text-davinci-003",
  prompt="Repeat what I said.",
  temperature=0,
  max_tokens=100,
  top_p=1.0,
  frequency_penalty=0.2,
  presence_penalty=0.0,
  stop=["\n"]
)
```

Argument:
- `max_tokens`: maximum number of tokens to generate in the completion
- `temperature`: higher mean the model takes more risks
- `top_p`: the model considers the results of the tokens with top_p probability mass
- `frequency_penalty`: Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
- `presence_penalty`: Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.


# Fine-tuning
You can fine-tune GPT to train it for your task.

Your data must be a [JSONL](https://jsonlines.org/) document.
``` shell
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
...
```

It can pass a CSV, TSV, XLSX, JSON or JSONL file to the following command and it will generate the JSONL file for you.
``` shell
openai tools fine_tunes.prepare_data -f <LOCAL_FILE>
```

To fine tune a model, run
``` shell
openai api fine_tunes.create -t <TRAIN_FILE_ID_OR_PATH> -m <BASE_MODEL>
```

To list all created fine-tune, run
``` shell
openai api fine_tunes.list
```

To use the fine tune model in Python, run
``` python
import openai
openai.Completion.create(
    model=FINE_TUNED_MODEL,
    prompt=YOUR_PROMPT)
```
