# Hugging Face
*(based on [official documentation](https://huggingface.co/docs/hub/index))*

The Hugging Face Hub is a platform with 120k models, 20k datasets, and 50k demo apps (Spaces), all open source and publicly available. The Hub works as a central place where anyone can share, explore, discover and experiment with open-source machine learning.


# Table of Contents
- [Hugging Face](#hugging-face)
- [Table of Contents](#table-of-contents)
- [Components](#components)


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

The Hub also offers Github repositories functions like versioning, commit history, diffs, branches and over a dozen library integrations.
