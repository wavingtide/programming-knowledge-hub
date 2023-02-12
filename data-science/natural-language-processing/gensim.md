# Gensim
*(refer to [Gensim Documentation](https://radimrehurek.com/gensim/index.html))*

Gensim is a free open-source Python library for representing documents as semantic vectors. Gensim is designed to process raw text using unsupervised learning.


# Table of Contents
- [Gensim](#gensim)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Core Concepts](#core-concepts)
  - [Document](#document)
  - [Corpus](#corpus)
  - [Vector](#vector)
  - [Model](#model)


# Installation
``` shell
pip install gensim
```

``` shell
conda install -c conda-forge gensim
```

# Core Concepts
1. `Documents`: some text.
2. `Corpus`: a collection of documents.
3. `Vector`: a mathematically convenient representation of a document.
4. `Model`: an algorithm for transforming vector from one representation to another.

## Document
Document is a `str`.
``` python
document = "Human machine interface for lab abc computer applications"
```

## Corpus
Corpus is a collection of `Document` objects.

``` python
text_corpus = [
    "Human machine interface for lab abc computer applications",
    "A survey of user opinion of computer system response time",
    "The EPS user interface management system"
]
```

It can be used as
1. Input for training a `Model`.
2. Documents for prediction.

## Vector
Each document can be represented as 
- a vector of features. Example of features include number of font types, number of word 'sponge', etc.
- bag-of-word approach: each document is represented by frequency count of each word in the dictionary

Types of vector
- Dense vector
- Sparse vector / bag-of-words vector - the values of all missing features in this sparse representation can be resolved to zero

## Model
Model refers to a transformation from one document representation to another. Example: `tf-idf`.




