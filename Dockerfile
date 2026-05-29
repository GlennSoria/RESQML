# ---- Base image ---------------------------------------------------------
FROM python:3.12-slim

# ---- System dependencies (required by OpenCV) -------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgl1-mesa-glx \
        libglib2.0-0 \
        gcc \
        g++ \
        make && \
    rm -rf /var/lib/apt/lists/*

# ---- Working directory --------------------------------------------------
WORKDIR /app

# ---- Install Python dependencies -----------------------------------------
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- Copy source code ----------------------------------------------------
COPY . .

# ---- Expose the port that Render expects (env var $PORT) -----------------
EXPOSE 8000

# ---- Run the FastAPI app via Gunicorn ------------------------------------
# Gunicorn is already in requirements.txt
CMD ["gunicorn", "main:app", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:$PORT"]
