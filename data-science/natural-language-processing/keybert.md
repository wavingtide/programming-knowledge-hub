# KeyBERT
*(refer to [KeyBERT documentation](https://maartengr.github.io/KeyBERT/index.html))*

KeyBERT is a minimal and easy-to-use keyword extraction technique. It uses BERT embeddings to find the keywords and keyphrases that are most similar to a document.

Steps
1. Use BERT embedding to get document-level representation.
2. Extract N-gram words/phrases.
3. Use BERT embedding to get word/phrases embedding.
4. Use cosine similarity to find the word/phrases that are most similar to the entire document.


# Installation
``` shell
pip install keybert
```

``` shell
pip install keybert[flair]
pip install keybert[gensim]
pip install keybert[spacy]
pip install keybert[use]
```

# Usage
``` python
from keybert import KeyBERT

doc = 'This is a sample document'
kw_model = KeyBERT()
keywords = kw_model.extract_keywords(doc)
```

The code above will be the base of any code below.

# MMR and MaxSum
An easy way to increase the diversity of the keywords/keyphrases is using either **Maximal Marginal Relevance (MMR)** or **Max Sum Distance**.
``` python
keywords = kw_model.extract_keywords(doc, use_mmr=True, diversity=0.8)
```

``` python
keywords = kw_model.extract_keywords(doc, use_maxsum=True, nr_candidates=20, top_n=5)
```

**Maximal Marginal Relevance (MMR)** compares the new keywords/keyphrases with the selected one, and try to maximize the within diversity of a document.

**Max Sum Distance** takes `nr_candidates` keywords/keyphrases, and find `top_n` least similar combination by cosine similarity.


# Vectorizer
Before doing the cosine similarity to extract the keywords/keyphrases, the document needs to be broken down to words/phrases. It is done using vectorizer. There are 2 available vectorizer, `CountVectorizer` and `KeyphraseCountVectorizer`.


## `CountVectorizer`
`CountVectorizer` is the default vectorizer and it is from `scikit-learn` library.
``` python
from sklearn.feature_extraction.text import CountVectorizer

vectorizer = CountVectorizer()
keywords = kw_model.extract_keywords(doc, vectorizer=vectorizer)
```

It accepts a number of parameters.
- `ngram_range`: tuple of min and max number of tokens (e.g. `(1,3)`)
- `stop_words`: list of stop words or language (e.g. `'english'`, `['of', 'that']`)
- `vocabulary`: list of vocabulary, limit the keywords generated to the specified vocabularies 
- `tokenizer`: tokenizer to handle non-Western language

``` python
vectorizer = CountVectorizer(ngram_range=(1, 3), stop_words="english")
keywords = kw_model.extract_keywords(doc, vectorizer=vectorizer)
```

``` python
vocab = ['finance', 'ceo', 'board', 'board member', 'company expansion strategy']
vectorizer = CountVectorizer(ngram_range=(1, 3), vocabulary=vocab)
keywords = kw_model.extract_keywords(doc, vectorizer=vectorizer)
```

``` python
from sklearn.feature_extraction.text import CountVectorizer
import jieba

def tokenize_zh(text):
    words = jieba.lcut(text)
    return words

vectorizer = CountVectorizer(tokenizer=tokenize_zh)
keywords = kw_model.extract_keywords(doc, vectorizer=vectorizer)
```

You can also pass the parameters directly to `extract_keywords` and it will be passed to the default `CountVectorizer`.
``` python
kw_model.extract_keywords(doc, keyphrase_ngram_range=(1, 3), stop_words='english'
```

## `KeyphraseVectorizers` *([github](https://github.com/TimSchopf/KeyphraseVectorizers))*

`KeyphraseVectorizers` is a more powerful vectorizer leveragin part-of-speech patterns. The POS is based on `spaCy` library.

Installation
``` shell
pip install keyphrase-vectorizers
```

Usage
``` python
from keyphrase_vectorizers import KeyphraseCountVectorizer
vectorizer = KeyphraseCountVectorizer()
kw_model.extract_keywords(doc, vectorizer=vectorizer, use_mmr=True)
```

If you are familiar with `spaCy`, you will know that there can be different language pipeline.
``` python
vectorizer = KeyphraseCountVectorizer(spacy_pipeline='de_core_news_sm')
```

The default POS pattern is `<J.*>*<N.*>+`, which means 0 or more adjectives followed by 1 or more nouns. You can also specify the POS pattern you prefer.

``` python
vectorizer = KeyphraseCountVectorizer(pos_pattern='<N.*>')
kw_model.extract_keywords(doc, vectorizer=vectorizer)
```

# Embeddings
KeyBERT supports a large varieties of embedding libraries. Please refer to [documentation](https://maartengr.github.io/KeyBERT/guides/embeddings.html) on how to apply different libraries.
- Sentence Transformers
- Hugging Face Transformers
- Flair
- Spacy
- Universal Sentence Encoder (USE)
- Gensim
- Custom Backend

# Other Functions
Candidate keywords/keyphrases
``` python
import yake
from keybert import KeyBERT

# Create candidates
kw_extractor = yake.KeywordExtractor(top=50)
candidates = kw_extractor.extract_keywords(doc)
candidates = [candidate[0] for candidate in candidates]

# Pass candidates to KeyBERT
kw_model = KeyBERT()
keywords = kw_model.extract_keywords(doc, candidates=candidates)
```

Guided KeyBERT
``` python
seed_keywords = ["information"]
keywords = kw_model.extract_keywords(doc, seed_keywords=seed_keywords)
```

Separate embeddings and keyword extraction
``` python
doc_embeddings, word_embeddings = kw_model.extract_embeddings(docs)

keywords = kw_model.extract_keywords(docs, doc_embeddings=doc_embeddings, word_embeddings=word_embeddings)
```

There are several possible parameters for `.extract_embeddings`
- `candidates`
- `keyphrase_ngram_range`
- `stop_words`
- `min_df`
- `vectorizer`

The values of these parameters need to be exactly the same in `.extract_embeddings` as they are in `.extract_keywords`. Else, there will be an error.
