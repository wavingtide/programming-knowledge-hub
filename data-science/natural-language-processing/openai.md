# OpenAI
*(refer to [official documentation]())*

The OpenAI API can be used for almost any NLP tasks.

# Concepts
- Prompt: Inputted text
- Tokens: Texts are broken down into tokens. (e.g. `'hamburger' -> ['ham', 'bur', 'ger']`)
- Models (Davinci, Curie, Babbage, Ada)


# How to write a good prompt?
1. Start with an instruction.
2. Add some examples.
3. Adjust your settings.

Limitation: 2048 tokens (roughly 1500 words)


# Python Library
Installation
``` shell
pip install openai
```

``` python
import os
import openai

# Load your API key from an environment variable or secret management service
openai.api_key = os.getenv("OPENAI_API_KEY")

response = openai.Completion.create(
    model="text-davinci-003", 
    prompt="Say this is a test", 
    temperature=0, 
    max_tokens=7)
```
