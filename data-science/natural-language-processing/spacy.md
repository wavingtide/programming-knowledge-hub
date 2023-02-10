# spaCy
*(based on [spaCy documentation](https://spacy.io/usage/spacy-101))*
*(based on version 3.5)*

spaCy is a free, open-source library for advanced Natural Language Processing (NLP) in Python.

# Table of Contents
- [spaCy](#spacy)
- [Table of Contents](#table-of-contents)
- [Features](#features)
- [Installation](#installation)
- [Trained Pipelines](#trained-pipelines)
  - [Components](#components)
  - [Usage](#usage)
    - [Tokenizer](#tokenizer)
    - [Part-of-speech tagging](#part-of-speech-tagging)
    - [Names Entity Recognition](#names-entity-recognition)
    - [Word Vectors and Similarity](#word-vectors-and-similarity)
- [Architect](#architect)
- [Pro tips](#pro-tips)


# Features
| NAME | DESCRIPTION |
| --- | --- |
| **Tokenization** | Segmenting text into words, punctuations marks etc. |
| **Part-of-speech (POS) Tagging** | Assigning word types to tokens, like verb or noun. |
| **Dependency Parsing** | Assigning syntactic dependency labels, describing the relations between individual tokens, like subject or object. |
| **Lemmatization** | Assigning the base forms of words. For example, the lemma of “was” is “be”, and the lemma of “rats” is “rat”. |
| **Sentence Boundary Detection (SBD)** | Finding and segmenting individual sentences. |
| **Named Entity Recognition (NER)** | Labelling named “real-world” objects, like persons, companies or locations. |
| **Entity Linking (EL)** | Disambiguating textual entities to unique identifiers in a knowledge base. |
| **Similarity** | Comparing words, text spans and documents and how similar they are to each other. |
| **Text Classification** | Assigning categories or labels to a whole document, or parts of a document. |
| **Rule-based Matching** | Finding sequences of tokens based on their texts and linguistic annotations, similar to regular expressions. |
| **Training** | Updating and improving a statistical model’s predictions. |
| **Serialization** | Saving objects to files or byte strings. |


# Installation
``` shell
pip install spacy
```

``` shell
python -m spacy download en_core_web_sm
```


# Trained Pipelines
`en_core_web_sm` is an example of trained pipeline by spaCy. The structure is of `[lang]_[type]_[genre]_[size]`.
- `type`: `core` for general-purpose, `dep`
- `genre`: `web` and `news`
- `size`: `sm`, `md`, `lg`, `trf`

spaCy supports different human language models,which can be found on [spacy Documentation](https://spacy.io/usage).

Some spaCy feature requires trained pipeline to work. A pipeline typically consists of
- **Binary weights** for POS tagger, dependency parser and NER
- **Lexical entries** in the vocabulary, i.e. words and their context-independent attributes like shape or spelling 
- **Data files** like lemmatization rules and lookup tables
- **Word vectors**
- **Configuration** of language, setting, model implementation


A pipeline package has the following file structure.
``` shell
.venv/lib/python3.8/site-packages/en_core_web_sm
├── __init__.py
├── __pycache__
│   └── __init__.cpython-38.pyc
├── en_core_web_sm-3.5.0
│   ├── LICENSE
│   ├── LICENSES_SOURCES
│   ├── README.md
│   ├── accuracy.json
│   ├── attribute_ruler
│   │   └── patterns
│   ├── config.cfg
│   ├── lemmatizer
│   │   └── lookups
│   │       └── lookups.bin
│   ├── meta.json
│   ├── ner
│   │   ├── cfg
│   │   ├── model
│   │   └── moves
│   ├── parser
│   │   ├── cfg
│   │   ├── model
│   │   └── moves
│   ├── senter
│   │   ├── cfg
│   │   └── model
│   ├── tagger
│   │   ├── cfg
│   │   └── model
│   ├── tok2vec
│   │   ├── cfg
│   │   └── model
│   ├── tokenizer
│   └── vocab
│       ├── key2row
│       ├── lookups.bin
│       ├── strings.json
│       ├── vectors
│       └── vectors.cfg
└── meta.json
```


## Components
The component of a pipelines are as follows.

![](https://spacy.io/images/pipeline.svg)

| Name | Component | Creates | Description |
| --- | --- | --- | --- |
| **tokenizer** | `Tokenizer` | `Doc` | Segment text into tokens. |
| *processing pipeline* |
| **tagger** | `Tagger` | `Token.tag` | Assign part-of-speech tags. |
| **parser** | `DependencyParser` | `Token.head`, `Token.dep`, `Doc.sents`, `Doc.noun_chunks` | Assign dependency labels. |
| **ner** | `EntityRecognizer` | `Doc.ents`, `Token.ent_job`, `Token.ent_type` | Detect and label names entities. |
| **lemmatizer** | `Lemmatizer` | `Token.lemma` | Assign base forms. |
| **textcat** | `TextCategorizer` | `Doc.cats` | Assign document labels. |
| **custom** | custom components | `Doc._.xxx`, `Token._.xxx`, `Span._.xxx` | Assign custom attributes, methods or properties. | 


``` python
import spacy

nlp = spacy.load('en_core_web_sm')
doc = nlp('This is a text')
```

`nlp` is a `Language` object containing all components and data needed to process text, doc is a `Doc` object.

In v2, `tagger`, `parser` and `ner` components are independent.

In v3, some components depend on each other. Therefore, one needs to be mindful when disabling or reordering the components.

When you call `nlp` on a text, spaCy will tokenize it and then call each component on the `Doc`.

``` python
doc = nlp.make_doc("This is a sentence")  # Create a Doc from raw text
for name, proc in nlp.pipeline:           # Iterate over components in order
    doc = proc(doc)                       # Apply each component
```

To see the underlying components, run
``` python
print(nlp.pipeline)
# [('tok2vec', <spacy.pipeline.Tok2Vec>), ('tagger', <spacy.pipeline.Tagger>), ('parser', <spacy.pipeline.DependencyParser>), ('ner', <spacy.pipeline.EntityRecognizer>), ('attribute_ruler', <spacy.pipeline.AttributeRuler>), ('lemmatizer', <spacy.lang.en.lemmatizer.EnglishLemmatizer>)]
print(nlp.pipe_names)
# ['tok2vec', 'tagger', 'parser', 'ner', 'attribute_ruler', 'lemmatizer']
```

For other build-in pipeline components, check out [documentation](https://spacy.io/usage/processing-pipelines#built-in).


## Usage
When you pass in a text to the trained pipeline `nlp`
``` python
import spacy

nlp = spacy.load("en_core_web_sm")
doc = nlp("Apple is looking at buying U.K. startup for $1 billion")
```

### Tokenizer
Tokenizer segments the text into words, punctuation and so on. It works based on hard-coded rules for the language (e.g. `U.K.` is not splitted by `.` but remain as one token)

``` python
for token in doc:
    print(token.text)
```

``` shell
Apple
is
looking
at
buying
U.K.
startup
for
$
1
billion
```

![](https://spacy.io/images/tokenization.svg)

### Part-of-speech tagging
``` python
for token in doc:
    print(token.text, token.lemma_, token.pos_, token.tag_, token.dep_,
            token.shape_, token.is_alpha, token.is_stop)
```

``` shell
Apple Apple PROPN NNP nsubj Xxxxx True False
is be AUX VBZ aux xx True True
looking look VERB VBG ROOT xxxx True False
at at ADP IN prep xx True True
buying buy VERB VBG pcomp xxxx True False
U.K. U.K. PROPN NNP dobj X.X. False False
startup startup NOUN NN dep xxxx True False
for for ADP IN prep xxx True True
$ $ SYM $ quantmod $ False False
1 1 NUM CD compound d False False
billion billion NUM CD pobj xxxx True False
```

### Names Entity Recognition
``` python
for ent in doc.ents:
    print(ent.text, ent.start_char, ent.end_char, ent.label_)
```

``` shell
Apple 0 5 ORG
U.K. 27 31 GPE
$1 billion 44 54 MONEY
```

### Word Vectors and Similarity
Small `sm` models don't have word vectors. To use word vectors, we need a larger pipeline package. Vector of `Doc` or `Span` will be average of their `Token` vector.
``` shell
python -m spacy download en_core_web_md
```
``` python
import spacy

nlp = spacy.load("en_core_web_md")
doc = nlp("Apple is looking at buying U.K. startup for $1 billion")

for token in doc:
    print(token.text, token.has_vector, token.vector_norm, token.is_oov)
```

``` shell
Apple True 49.544395 False
is True 110.41255 False
looking True 48.28714 False
at True 118.82375 False
buying True 45.90773 False
U.K. True 34.055897 False
startup True 39.72299 False
for True 69.12914 False
$ True 190.25487 False
1 True 118.7086 False
billion True 67.87469 False
```

To get similarity of 2 vectors
``` python
doc1 = nlp("I like salty fries and hamburgers.")
doc2 = nlp("Fast food tastes very good.")
print(doc1, "<->", doc2, doc1.similarity(doc2))
```

``` shell
I like salty fries and hamburgers. <-> Fast food tastes very good. 0.691649353055761
```


# Architect
The central data structures in spaCy
- `Language` class
- `Vocab`
- `Doc`

![](https://spacy.io/images/architecture.svg)


# Pro tips
1. When processing large volumes of text, processing by batch will be more efficient than processing one by one. spaCy has a function for batching.
    ``` python
    - docs = [nlp(text) for text in texts]
    + docs = list(nlp.pipe(texts))
    ```

2. Disable or exclude pipeline components that you are not using can speed up the processing.
    ``` python
    # Load the pipeline without the entity recognizer
    nlp = spacy.load("en_core_web_sm", exclude=["ner"])

    # Load the tagger and parser but don't enable them
    nlp = spacy.load("en_core_web_sm", disable=["tagger", "parser"])
    # Explicitly enable the tagger later on
    nlp.enable_pipe("tagger")
    ```
