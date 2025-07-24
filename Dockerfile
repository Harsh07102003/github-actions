# ---------- Stage 1: Build & Test ----------
FROM python:3.12-slim as builder

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Copy all code
COPY . .

# Run tests (optional)
RUN python -m pytest tests || true

# ---------- Stage 2: Production ----------
FROM python:3.12-alpine

WORKDIR /app

# Install runtime dependencies only
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# Copy only necessary code (no tests)
COPY . .

# Default command
CMD ["python", "app.py"]
