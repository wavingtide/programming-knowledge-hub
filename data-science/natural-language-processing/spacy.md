# spaCy
*(based on [spaCy documentation](https://spacy.io/usage/spacy-101))*

spaCy is a free, open-source library for advanced Natural Language Processing (NLP) in Python.

# Table of Contents
- [spaCy](#spacy)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Features](#features)
- [Pipeline](#pipeline)
- [Tokenization](#tokenization)
- [Part-of-speech Tags and Dependencies](#part-of-speech-tags-and-dependencies)
- [Visualizer](#visualizer)
- [Named Entity Recognition](#named-entity-recognition)

# Installation
``` shell
pip install spacy
python -m spacy download en_core_web_sm
```

`en_core_web_sm` is an example of trained pipeline by spaCy. The structure is of `[lang]_[type]_[genre]_[size]`.
- `type`: `core` for general-purpose, `dep`
- `genre`: `web` and `news`
- `size`: `sm`, `md`, `lg`, `trf`

spaCy supports different human language models,which can be found on [spacy Documentation](https://spacy.io/usage).

# Features
| NAME | DESCRIPTION |
| --- | --- |
| Tokenization | Segmenting text into words, punctuations marks etc. |
| Part-of-speech (POS) Tagging | Assigning word types to tokens, like verb or noun. |
| Dependency Parsing | Assigning syntactic dependency labels, describing the relations between individual tokens, like subject or object. |
| Lemmatization | Assigning the base forms of words. For example, the lemma of “was” is “be”, and the lemma of “rats” is “rat”. |
| Sentence Boundary Detection (SBD) | Finding and segmenting individual sentences. |
| Named Entity Recognition (NER) | Labelling named “real-world” objects, like persons, companies or locations. |
| Entity Linking (EL) | Disambiguating textual entities to unique identifiers in a knowledge base. |
| Similarity | Comparing words, text spans and documents and how similar they are to each other. |
| Text Classification | Assigning categories or labels to a whole document, or parts of a document. |
| Rule-based Matching | Finding sequences of tokens based on their texts and linguistic annotations, similar to regular expressions. |
| Training | Updating and improving a statistical model’s predictions. |
| Serialization | Saving objects to files or byte strings. |


# Pipeline
![](https://spacy.io/images/pipeline.svg)

When you call `nlp` on a text, spaCy tokenizes the text to produce a `Doc` object. After that, it is processed in several steps, called processing pipeline.

# Tokenization
``` python
import spacy
​
nlp = spacy.load("en_core_web_sm")
doc = nlp("Apple is looking at buying U.K. startup for $1 billion")
for token in doc:
    print(token.text)
```

# Part-of-speech Tags and Dependencies
``` python
import spacy

nlp = spacy.load("en_core_web_sm")
doc = nlp("Apple is looking at buying U.K. startup for $1 billion")

for token in doc:
    print(token.text, token.lemma_, token.pos_, token.tag_, token.dep_,
            token.shape_, token.is_alpha, token.is_stop)
```
Return
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

# Visualizer
displaCy visualizer
![](https://spacy.io/images/displacy.svg)


# Named Entity Recognition
``` python
import spacy

nlp = spacy.load("en_core_web_sm")
doc = nlp("Apple is looking at buying U.K. startup for $1 billion")

for ent in doc.ents:
    print(ent.text, ent.start_char, ent.end_char, ent.label_)
```

``` shell
Apple 0 5 ORG
U.K. 27 31 GPE
$1 billion 44 54 MONEY
```
