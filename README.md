
# 🧠 Amazon Sentiment Analysis App

This project is a **sentiment analysis microservice** that classifies product reviews (e.g., from Amazon) into 5 sentiment categories using a fine-tuned Transformer model.  
It includes:
- A **Python + Flask** backend deployed on **Hugging Face Spaces**
- A **Flutter mobile app** that consumes the API and visualizes results beautifully

---

## 🚀 Features
✅ Real-time text sentiment analysis  
✅ Five-class classification: `very negative`, `negative`, `neutral`, `positive`, `very positive`  
✅ REST API endpoint `/api/predict`  
✅ Hugging Face Spaces deployment (public API)  
✅ Flutter frontend integration  
✅ JSON-based communication between app & API  

---

## 🧩 Tech Stack

| Component | Technology |
|------------|-------------|
| Backend | Python, Flask |
| Model | Hugging Face Transformers |
| Deployment | Hugging Face Spaces |
| Frontend | Flutter |
| Data Exchange | JSON API |

---

## 🧠 Model Overview

The model is a fine-tuned Transformer (e.g. `bert-base-uncased`) trained to detect sentiment in Amazon product reviews.

**Labels:**
1. negative 🙁    
2. positive 🙂   

---

## ⚙️ API Endpoint

### `POST /api/predict`

**Request:**
```json
{
  "data": ["This product is great!"]
}

**Response:**
```json
{
  "data": [[{"label": "positive", "score": 0.92}]]
}

git clone https://huggingface.co/spaces/birolshn/amazon-sentiment-api
cd amazon-sentiment-api

pip install -r requirements.txt

python app.py
