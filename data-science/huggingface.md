# Hugging Face
*(based on [official documentation](https://huggingface.co/docs))*

The Hugging Face Hub is a platform with 120k models, 20k datasets, and 50k demo apps (Spaces), all open source and publicly available. The Hub works as a central place where anyone can share, explore, discover and experiment with open-source machine learning.


# Table of Contents
- [Hugging Face](#hugging-face)
- [Table of Contents](#table-of-contents)
- [Components](#components)
- [Installation](#installation)
- [Handle Large Files](#handle-large-files)
- [Transformer](#transformer)
  - [Installation](#installation-1)
  - [Pipeline](#pipeline)


# Components
- **Models** - hosting the latest state-of-the-art models for NLP, vision, and audio tasks
  - **Model card** - inform users of each model's limitations and biases
  - **Metadata** (tasks, language, metrics, training metrics charts (if repo contains TensorBoard traces))
  - **Inference widgets**
  - **API**
- **Datasets** - featuring a wide variety of data for different domains and modalities
  - **Dataset card** & **Dataset preview** - let you explore data directly in your browser
- **Spaces** - interactive apps for demonstrating ML models directly in browser
  - Currently support **Gradio** and **Streamlit**
- **Organization** - Used to group accounts and manage datasets, models, spaces
- **Security** - Security and access control feature
  - User access tokens
  - Access control for organizations
  - Signing commits with GPG
  - Malware scanning

The Hub store models, spaces and datasets as Git repositories, and hence also come with functions like versioning, commit history, diffs, branches and over a dozen library integrations.

Hugging Face has built client library to allow users to interact with the repositories.

# Installation
``` shell
pip install huggingface_hub
huggingface-cli login
```

# Handle Large Files
Install Git Large File Storage (lfs)
``` shell
git lfs install
```

Set up `.gitattributes`
``` shell
huggingface-cli lfs-enable-largefiles .
```

To add more extensions/file types to track
``` shell
git lfs track "*.your_extension"
```


# Transformer
## Installation
``` shell
pip install transformers datasets
```
Install either pytorch or tensorflow
``` shell
pip install pytorch
```
``` shell
pip install tensorflow
```

## Pipeline
Using `pipeline()` is the easiest way to use a pretrained model for inference. You can use it out-of-the-box for many tasks.


| Task | Description | Modality | Pipeline identifier |
| --- | --- | --- | --- |
| Text classification | assign a label to a given sequence of text | NLP | pipeline(task="sentiment-analysis") |
| Text generation | generate text that follows a given prompt | NLP | pipeline(task="text-generation") |
| Name entity recognition | assign a label to each token in a sequence (people, organization, location, etc.) | NLP | pipeline(task="ner") |
| Question answering | extract an answer from the text given some context and a question | NLP | pipeline(task="question-answering") |
| Fill-mask | predict the correct masked token in a sequence | NLP | pipeline(task="fill-mask") |
| Summarization | generate a summary of a sequence of text or document | NLP | pipeline(task="summarization") |
| Translation | translate text from one language into another | NLP | pipeline(task="translation") |
| Image classification | assign a label to an image | Computer vision | pipeline(task="image-classification") |
| Image segmentation | assign a label to each individual pixel of an image (supports semantic, panoptic, and instance segmentation) | Computer vision | pipeline(task="image-segmentation")
| Object detection | predict the bounding boxes and classes of objects in an image | Computer vision | pipeline(task="object-detection") |
| Audio classification | assign a label to an audio file | Audio | pipeline(task="audio-classification") |
| Automatic speech recognition | extract speech from an audio file into text | Audio | pipeline(task="automatic-speech-recognition") |
| Visual question answering | given an image and a question, correctly answer a question about the image | Multimodal | pipeline(task="vqa") |
