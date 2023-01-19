# spaCy
*(based on [spaCy documentation](https://spacy.io/usage/spacy-101))*

spaCy is a free, open-source library for advanced Natural Language Processing (NLP) in Python.

# Table of Contents
- [spaCy](#spacy)
- [Table of Contents](#table-of-contents)
- [Features](#features)
- [Tokenization](#tokenization)

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


# Tokenization
``` python
import spacy
​
nlp = spacy.load("en_core_web_sm")
doc = nlp("Apple is looking at buying U.K. startup for $1 billion")
for token in doc:
    print(token.text)
```
